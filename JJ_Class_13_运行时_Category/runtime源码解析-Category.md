###runtime源码解析

1.在一个OC的类中有.h文件和.m文件，一般来说一个是放@interface 一个是放@implementation，和这个类似SEL就是一个函数的声明方法，而IMP就是这个方法的实现，也就是一个函数的指针

在runtime中，一般使用者会引入objc/message.h文件，这个文件用于消息分发，但是运行时对类的加载的文件是在objc/runtime.h文件中，所以首先我们来分析objc/runtime.h文件的代码

````
 #if !OBJC_TYPES_DEFINED
 
/// An opaque type that represents a method in a class definition.
typedef struct objc_method *Method;
 
/// An opaque type that represents an instance variable.
typedef struct objc_ivar *Ivar;
 
/// An opaque type that represents a category.
typedef struct objc_category *Category;
 
/// An opaque type that represents an Objective-C declared property.
typedef struct objc_property *objc_property_t; 
 
````  

这是最上方的定义，定义了四个别名，分别是方法指针、变量指针、分类指针和属性指针（这里要说下变量指针和属性指针得区别：笔者也是根据源码的推测，以及网上的相关搜索，属性是用这一个类的属性，而变量是通过类实例化出来的对象的那一块真实的有存有实际值的变量）
 
 接下来就是一个类的结构体的定义
 
````  
struct objc_class {
    Class isa  OBJC_ISA_AVAILABILITY;
 
 #if !__OBJC2__
    Class super_class                                        OBJC2_UNAVAILABLE;
    const char *name                                         OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
    struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
    struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
 #endif
 
} OBJC2_UNAVAILABLE;
 
````  

这个类的结构体包含一个isa指针，父类指针、变量列表、方法列表、对象列表以及内存列表等

你在代码中没申明一个类出来，系统在运行时会自动通过这个结构体创建出来一个结构体对象，这一个对象就是描述着一个类的所有信息。比如：

```` 
@interface Person : NSObject
@end
 
@implementation Person
@end
```` 

创建出来这样一个类，系统会做的处理，就是创建出来一个结构体对象
 {

super_class:NSObject,

name:Person,

........

 }

接下来的这段代码是指出一个对象的数据类型是objc_object结构体

```` 
#ifdef __OBJC__
@class Protocol;
#else
typedef struct objc_object Protocol;
#endif
```` 

因此我们可以看到上面objc_class结构体中的objc_protocol_list,就是这个类的所有对象的列表，这个列表的结构体定义如下：

```` 

struct objc_protocol_list {
    struct objc_protocol_list *next;
    long count;
    __unsafe_unretained Protocol *list[1];
};
```` 

这是一个链表形式，储存了所有对象的结构体指针，那么我们来看一下，对象又是一个什么样的结构：

```` 

struct objc_object {
private:
    isa_t isa;
 
public:
 
    // ISA() assumes this is NOT a tagged pointer object
    Class ISA();
 
    // getIsa() allows this to be a tagged pointer object
    Class getIsa();
 
    // initIsa() should be used to init the isa of new objects only.
    // If this object already has an isa, use changeIsa() for correctness.
    // initInstanceIsa(): objects with no custom RR/AWZ
    // initClassIsa(): class objects
    // initProtocolIsa(): protocol objects
    // initIsa(): other objects
    void initIsa(Class cls /*nonpointer=false*/);
    void initClassIsa(Class cls /*nonpointer=maybe*/);
    void initProtocolIsa(Class cls /*nonpointer=maybe*/);
    void initInstanceIsa(Class cls, bool hasCxxDtor);
 
    // changeIsa() should be used to change the isa of existing objects.
    // If this is a new object, use initIsa() for performance.
    Class changeIsa(Class newCls);
 
    bool hasNonpointerIsa();
    bool isTaggedPointer();
    bool isBasicTaggedPointer();
    bool isExtTaggedPointer();
    bool isClass();
 
    // object may have associated objects?
    bool hasAssociatedObjects();
    void setHasAssociatedObjects();
 
    // object may be weakly referenced?
    bool isWeaklyReferenced();
    void setWeaklyReferenced_nolock();
 
    // object may have -.cxx_destruct implementation?
    bool hasCxxDtor();
 
    // Optimized calls to retain/release methods
    id retain();
    void release();
    id autorelease();
 
    // Implementations of retain/release methods
    id rootRetain();
    bool rootRelease();
    id rootAutorelease();
    bool rootTryRetain();
    bool rootReleaseShouldDealloc();
    uintptr_t rootRetainCount();
 
    // Implementation of dealloc methods
    bool rootIsDeallocating();
    void clearDeallocating();
    void rootDealloc();
 
private:
    void initIsa(Class newCls, bool nonpointer, bool hasCxxDtor);
 
    // Slow paths for inline control
    id rootAutorelease2();
    bool overrelease_error();
 
#if SUPPORT_NONPOINTER_ISA
    // Unified retain count manipulation for nonpointer isa
    id rootRetain(bool tryRetain, bool handleOverflow);
    bool rootRelease(bool performDealloc, bool handleUnderflow);
    id rootRetain_overflow(bool tryRetain);
    bool rootRelease_underflow(bool performDealloc);
 
    void clearDeallocating_slow();
 
    // Side table retain count overflow for nonpointer isa
    void sidetable_lock();
    void sidetable_unlock();
 
    void sidetable_moveExtraRC_nolock(size_t extra_rc, bool isDeallocating, bool weaklyReferenced);
    bool sidetable_addExtraRC_nolock(size_t delta_rc);
    size_t sidetable_subExtraRC_nolock(size_t delta_rc);
    size_t sidetable_getExtraRC_nolock();
#endif
 
    // Side-table-only retain count
    bool sidetable_isDeallocating();
    void sidetable_clearDeallocating();
 
    bool sidetable_isWeaklyReferenced();
    void sidetable_setWeaklyReferenced_nolock();
 
    id sidetable_retain();
    id sidetable_retain_slow(SideTable& table);
 
    uintptr_t sidetable_release(bool performDealloc = true);
    uintptr_t sidetable_release_slow(SideTable& table, bool performDealloc = true);
 
    bool sidetable_tryRetain();
 
    uintptr_t sidetable_retainCount();
#if DEBUG
    bool sidetable_present();
#endif
};

```` 

对象的结构体比较长，其中的属性和方法比较多，我们在这里只介绍主要的一些属性方法:


首先有一个私有的isa指针，isa是一个联合体，一般是一个指向该对象所属的类的objc_class对象的指针，在创建出来的对象需要调用成员变量或者成员方法时，会通过该isa指针向所属的类的objc_class对象发送消息请求运行方法，共有的成员方法可以通过指针直接调用。

然后继续看runtime.h文件，后续的代码都是一些以OBJC_EXPORT开头的函数，这些函数是一些工具函数，用于对运行时的类进行一些操作，经常使用的有几个函数：

```` 
OBJC_EXPORT Ivar *class_copyIvarList(Class cls, unsigned int *outCount) 
    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0);
```` 
class_copyIvarList函数，用于获取这个类的属性的列表。


objc-private.h

打开头文件就看到了两个熟悉的结构体指针

```` 
typedef struct objc_class *Class;
typedef struct objc_object *id;
```` 
我们会经常用到id这个指针，比较老的Foundation框架中，一般的初始化方法都会返回一个id对象，并且一些有iOS编程经验的老鸟也会说ObjC中的所有对象都可以强转成id类型。那么现在就来分析一下id究竟是个什么东东。

从源码来看真的是好长的一坨结构体,首先看到的是一个isa_t的union：

````
private:
    isa_t isa;
````

这个isa_t用一句话概括就是：
对64位的设备对象进行类对象指针的优化，利用合理的bit（arm64设备为32位）存储类对象的地址，其他位用来进行内存管理。这种优化模式被称为tagged pointer。用在isa_t的实现中称作IndexedIsa。

下面是isa_t在arm64架构下的结构：

````
union isa_t 
{
    uintptr_t bits;
    
#   define ISA_MASK        0x00007ffffffffff8ULL
#   define ISA_MAGIC_MASK  0x001f800000000001ULL
#   define ISA_MAGIC_VALUE 0x001d800000000001ULL
    struct {
        uintptr_t indexed           : 1;
        uintptr_t has_assoc         : 1;
        uintptr_t has_cxx_dtor      : 1;
        uintptr_t shiftcls          : 33; // MACH_VM_MAX_ADDRESS 0x1000000000
        uintptr_t magic             : 6;
        uintptr_t weakly_referenced : 1;
        uintptr_t deallocating      : 1;
        uintptr_t has_sidetable_rc  : 1;
        uintptr_t extra_rc          : 19;
 #       define RC_ONE   (1ULL<<45)
 #       define RC_HALF  (1ULL<<18)
    };
};
````

indexed：标记是否启动指针优化

has_assoc：是否有关联对象

has_cxx_dtor：是否有析构器

shiftcls：类对象指针

magic：标记初始化完成

weakly_refrenced：是否弱引用

deallocating：是否正在释放

extra_rc：引用计数（但是比retaincount小1）

至此，优化情况下的isa_t包含的内容大体总结完毕。
回过头来继续分析objc_object内的函数。

````
void initIsa(Class cls /*indexed=false*/);
void initClassIsa(Class cls /*indexed=maybe*/);
void initProtocolIsa(Class cls /*indexed=maybe*/);
void initInstanceIsa(Class cls, bool hasCxxDtor);
````

值得注意的是这几个函数最后调用的都是

````
inline bool objc_object::initIsa(Class cls, bool indexed, bool hasCxxDtor)

````

下面的函数是用来改变一个对象的Class：

````
Class changeIsa(Class newCls);

````
印象中KVO的实现中，会改变一个对象的Class，以后会带来验证。
接下来的一系列函数顾名思义，我也不做解释，内部的实现基本也都是依赖于isa来进行的。

````
// changeIsa() should be used to change the isa of existing objects.
    // If this is a new object, use initIsa() for performance.
    Class changeIsa(Class newCls);

    bool hasIndexedIsa();
    bool isTaggedPointer();
    bool isClass();

    // object may have associated objects?
    bool hasAssociatedObjects();
    void setHasAssociatedObjects();

    // object may be weakly referenced?
    bool isWeaklyReferenced();
    void setWeaklyReferenced_nolock();
    
    // object may have -.cxx_destruct implementation?
    bool hasCxxDtor();
````

这里我解释一下下面这两个方法的区别。

````
bool hasIndexedIsa();
bool isTaggedPointer();
````
本质上这两个函数都是来判断某个指针是否启用了tagged pointer。不同的是
bool hasIndexedIsa();是用来判断当前对象的isa是否启用tagged pointer，而bool isTaggedPointer();函数用来判断当前的对象指针是否启用了tagged pointer。根据我的调研，比如NSNumber、NSDate等值占用内存比较少的对象启用了tagged pointer。

接下来是一系列管理引用计数以及生命周期的函数：

````
// Optimized calls to retain/release methods
    id retain();
    void release();
    id autorelease();
    // Implementations of retain/release methods
    id rootRetain();
    bool rootRelease();
    id rootAutorelease();
    bool rootTryRetain();
    bool rootReleaseShouldDealloc();
    uintptr_t rootRetainCount();

    // Implementation of dealloc methods
    bool rootIsDeallocating();
    void clearDeallocating();
    void rootDealloc();
````

是不是很熟悉呢？先看一下id retain()的内部实现：

````
inline id 
objc_object::retain()
{
    // UseGC is allowed here, but requires hasCustomRR.
    assert(!UseGC  ||  ISA()->hasCustomRR());
    assert(!isTaggedPointer());

    if (! ISA()->hasCustomRR()) {
        return rootRetain();
    }

    return ((id(*)(objc_object *, SEL))objc_msgSend)(this, SEL_retain);
}
````

翻译一下，如果使用GC但是并没有custom的retain/release方法则会直接断言掉，如果支持tagged pointer就会直接断言掉。接下来的流程就是如果没有custom的retain/release方法就会调用rootRetain()。兜兜转转最后会调用如下方法：

````
ALWAYS_INLINE id 
objc_object::rootRetain(bool tryRetain, bool handleOverflow)
{
    assert(!UseGC);
    if (isTaggedPointer()) return (id)this;

    bool sideTableLocked = false;
    bool transcribeToSideTable = false;

    isa_t oldisa;
    isa_t newisa;

    do {
        transcribeToSideTable = false;
        oldisa = LoadExclusive(&isa.bits);
        newisa = oldisa;
        if (!newisa.indexed) goto unindexed;
        // don't check newisa.fast_rr; we already called any RR overrides
        if (tryRetain && newisa.deallocating) goto tryfail;
        uintptr_t carry;
        newisa.bits = addc(newisa.bits, RC_ONE, 0, &carry);  // extra_rc++

        if (carry) {
            // newisa.extra_rc++ overflowed
            if (!handleOverflow) return rootRetain_overflow(tryRetain);
            // Leave half of the retain counts inline and 
            // prepare to copy the other half to the side table.
            if (!tryRetain && !sideTableLocked) sidetable_lock();
            sideTableLocked = true;
            transcribeToSideTable = true;
            newisa.extra_rc = RC_HALF;
            newisa.has_sidetable_rc = true;
        }
    } while (!StoreExclusive(&isa.bits, oldisa.bits, newisa.bits));

    if (transcribeToSideTable) {
        // Copy the other half of the retain counts to the side table.
        sidetable_addExtraRC_nolock(RC_HALF);
    }

    if (!tryRetain && sideTableLocked) sidetable_unlock();
    return (id)this;

 tryfail:
    if (!tryRetain && sideTableLocked) sidetable_unlock();
    return nil;

 unindexed:
    if (!tryRetain && sideTableLocked) sidetable_unlock();
    if (tryRetain) return sidetable_tryRetain() ? (id)this : nil;
    else return sidetable_retain();
}
````

这段代码确实值得仔细研读,转换成伪代码的形式为：

````
ALWAYS_INLINE id 
objc_object::rootRetain(bool tryRetain, bool handleOverflow)
{
   if (not support tagged pointer) return this;
   do {
       if (isa not support indexed) 
           sidetable_tryRetain(); //利用sidetable进行管理对象的引用计数。 
       if (isa support indexed)
           newisa.bits = addc(newisa.bits, RC_ONE, 0, &carry);  // extra_rc+
   }
}
````
当然内部还有一些对于retry以及overflow的处理，这篇文章就不做过多的分析。但是大体上对于没有进行isa的indexed优化的对象的引用计数是依赖于SideTable()管理，而进行indexed优化的对象则直接利用isa指针进行管理。

接下来的private函数我就不多做分析了，值得注意的是，里面有很多有关于sidetable的函数，但是这些函数是在NSObject.mm中实现的。



1.map_images

进入方法后，先进行加锁，后后转到map_images_nolock方法进行处理

1.1 map_images_nolock

方法内实现共享内存优化，默认方法注册、自动释放池和散列表初始化及类的加载等操作。

1.2 _read_images
方法内实现类加载，方法注册，加载虚函数表，加载协议Protocol，非延迟类方法和静态实例加载

加载分类

###参考文章

[runtime源码](https://opensource.apple.com/tarballs/objc4/)

[iOS中的runtime源码简要分析
](https://blog.csdn.net/xy371661665/article/details/77884855)

[ObjC runtime源码 阅读笔记
](https://segmentfault.com/a/1190000007269581)



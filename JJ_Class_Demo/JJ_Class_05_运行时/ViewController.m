//
//  ViewController.m
//  JJ_Class_05_运行时
//
//  Created by Jay on 15/11/25.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "Test.h"
#import "MyClass.h"
#import "SUTRuntimeMethod.h"
#import "SUTRuntimeMethodHelper.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self runtime_Test];
    [self runtime_MyClass];
//    [self runtime_CreateClass];
//    [self runtime_CreateObject];
//    [self runtime_TypeEncoding];
//    [self runtime_ResolveMethod_all];
}


#pragma mark - runtime方法

/** 运行时Test */
- (void)runtime_Test {
    Test *t = [[Test alloc] init];
    [t ex_registerClassPair];
}

/** 运行时MyClass */
- (void)runtime_MyClass {
    MyClass *myClass = [[MyClass alloc] init];
    
    unsigned int outCount = 0;
    Class cls = myClass.class;
    
    // 类名
    NSLog(@"class name: %s", class_getName(cls));
    NSLog(@"==========================================================");
    
    // 父类
    NSLog(@"super class name: %s", class_getName(class_getSuperclass(cls)));
    NSLog(@"==========================================================");
    
    // 是否是元类
    NSLog(@"MyClass is %@ a meta-class", (class_isMetaClass(cls) ? @"" : @"not"));
    NSLog(@"==========================================================");
    
    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"%s's meta-class is %s", class_getName(cls), class_getName(meta_class));
    NSLog(@"==========================================================");
    
    // 变量实例大小
    NSLog(@"instance size: %zu", class_getInstanceSize(cls));
    NSLog(@"==========================================================");
    
    // 成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name: %s at index: %d", ivar_getName(ivar), i);
    }
    free(ivars);
    
    NSLog(@"==========================================================");
    
    Ivar string = class_getInstanceVariable(cls, "_string");
    if (string != NULL) {
        NSLog(@"instace variable %s", ivar_getName(string));
    }
    NSLog(@"==========================================================");
    
    // 属性操作
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name: %s", property_getName(property));
    }
    free(properties);
    
    NSLog(@"==========================================================");
    
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s", property_getName(array));
    }
    NSLog(@"==========================================================");
    
    // 方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's signature: %s", method_getName(method));
    }
    free(methods);
    NSLog(@"==========================================================");
    
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"method %s", method_getName(method1));
    }
    NSLog(@"==========================================================");
    
    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod != NULL) {
        NSLog(@"class method : %s", method_getName(classMethod));
    }
    NSLog(@"==========================================================");
    
    NSLog(@"MyClass is%@ responsd to selector: method3WithArg1:arg2:", class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"" : @" not");
    NSLog(@"==========================================================");
    
    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    imp();
    
    NSLog(@"==========================================================");
    
    // 协议
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
    Protocol * protocol;
    for (int i = 0; i < outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s", protocol_getName(protocol));
    }
    
    NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    
    NSLog(@"==========================================================");
}


void imp_submethod1() {
    NSLog(@"run sub method 1");
}


/** 动态创建类 */
- (void)runtime_CreateClass {
    Class cls = objc_allocateClassPair(MyClass.class, "MySubClass", 0);
    
    class_addMethod(cls, @selector(submethod1), (IMP)imp_submethod1, "v@:");
    class_replaceMethod(cls, @selector(method1), (IMP)imp_submethod1, "v@:");
    class_addIvar(cls, "_ivar1", sizeof(NSString *), log(sizeof(NSString *)), "i");
    
    objc_property_attribute_t type = {"T", "@\"NSString\""};
    objc_property_attribute_t ownership = { "C", "" };
    objc_property_attribute_t backingivar = { "V", "_ivar1"};
    objc_property_attribute_t attrs[] = {type, ownership, backingivar};
    
    class_addProperty(cls, "property2", attrs, 3);
    objc_registerClassPair(cls);
    
    id instance = [[cls alloc] init];
    [instance performSelector:@selector(submethod1)];
    [instance performSelector:@selector(method1)];
}


/** 动态创建对象 */
- (void)runtime_CreateObject {
    /**
     *  使用class_createInstance函数获取的是NSString实例，而不是类簇中的默认占位符类__NSCFConstantString。
     */
#if 0
    id theObject = class_createInstance(NSString.class, sizeof(unsigned));

    id str1 = [theObject init];
    
    NSLog(@"%@", [str1 class]);
    
    id str2 = @"test";
    NSLog(@"%@", [str2 class]);
#endif
}

//实例操作函数

/**
 *  有这样一种场景，假设我们有类A和类B，且类B是类A的子类。类B通过添加一些额外的属性来扩展类A。现在我们创建了一个A类的实例对象，并希望在运行时将这个对象转换为B类的实例对象，这样可以添加数据到B类的属性中。这种情况下，我们没有办法直接转换，因为B类的实例会比A类的实例更大，没有足够的空间来放置对象。此时，我们就要以使用以上几个函数来处理这种情况，如下代码所示：
 */
/** 转换 */
- (void)runtime_Revrt {
#if 0
    NSObject *a = [[NSObject alloc] init];
    
    id newB = object_copy(a, class_getInstanceSize(MyClass.class));
    
    object_setClass(newB, MyClass.class);
    
    object_dispose(a);
#endif
}

/** 获取类定义 */
- (void)runtime_ClassDefine {
#if 0
    int numClasses;
    Class * classes = NULL;
    
    numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0) {
        classes = malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        NSLog(@"number of classes: %d", numClasses);
        
        for (int i = 0; i < numClasses; i++) {
            Class cls = classes[i];
            NSLog(@"class name: %s", class_getName(cls));
        }
        
        free(classes);
    }
#endif
}

/** 类型编码 */
- (void)runtime_TypeEncoding {
    float a[] = {1.0, 2.0, 3.0};
    NSLog(@"array encoding type: %s", @encode(typeof(a)));
}

#pragma mark - 关联对象

/** 关联对象 */
- (void)runtime_AssociatedObject {
    
}

static char * kDTActionHandlerTapGestureKey;
static char * kDTActionHandlerTapBlockKey;

- (void)setTapActionWithBlock:(void (^)(void))block {
    
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        [self.view addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
        if (action) {
            action();
        }
    }
}
#pragma mark - 隐藏参数
/**
 *  这两个参数为方法的实现提供了调用者的信息。之所以说是隐藏的，是因为它们在定义方法的源代码中没有声明。它们是在编译期被插入实现代码的。
 
    虽然这些参数没有显示声明，但在代码中仍然可以引用它们。我们可以使用self来引用接收者对象，使用_cmd来引用选择器。如下代码所示：
 */
- (void)runtime_msgSend {
#if 0
    id  target = getTheReceiver();
    SEL method = getTheMethod();
    
    if ( target == self || method == _cmd )
        return nil;
    return [target performSelector:method];
#endif
}

#pragma mark - 获取方法地址
/**
 *  我们上面提到过，如果想要避开这种动态绑定方式，我们可以获取方法实现的地址，然后像调用函数一样来直接调用它。特别是当我们需要在一个循环内频繁地调用一个特定的方法时，通过这种方式可以提高程序的性能。
 
 NSObject类提供了methodForSelector:方法，让我们可以获取到方法的指针，然后通过这个指针来调用实现代码。我们需要将methodForSelector:返回的指针转换为合适的函数类型，函数参数和返回值都需要匹配上。
 */
- (void)runtime_methodForSelector {
#if 0
    void (*setter)(id, SEL, BOOL);
    int i;
    setter = (void (*)(id, SEL, BOOL))[target methodForSelector:@selector(setFilled:)];
    for (i = 0 ; i < 1000 ; i++) {
        setter(targetList[i], @selector(setFilled:), YES);
    }
#endif
}


#pragma mark - 消息转发

/** 消息转发 */
- (void)runtime_ResolveMethod {
}


void functionForMethod1(id self, SEL _cmd) {
    NSLog(@"%@, %p", self, _cmd);
}

/** 动态方法解析 */
+ (BOOL)runtime_ResolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString isEqualToString:@"method1"]) {
        class_addMethod(self.class, @selector(method1), (IMP)functionForMethod1, "@:");
    }
    return [super resolveInstanceMethod:sel];
}

/** 备用接收者 */
- (void)runtime_ResolveMethod_backup {
    [[SUTRuntimeMethod object] test];
}

/** 完整消息转发 */
- (void)runtime_ResolveMethod_all {
    [[SUTRuntimeMethod object] test];
}


@end

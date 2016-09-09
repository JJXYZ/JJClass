//
//  runtime方法.h
//  JJ_Class_Demo
//
//  Created by Jay on 15/11/25.
//  Copyright © 2015年 JJ. All rights reserved.
//


#if 0

/**
 *  /* Functions */

/* Working with Instances */

/**
 * 返回指定对象的一份拷贝
 */
 id object_copy(id obj, size_t size);

/**
 * 释放指定对象占用的内存
 */
 id object_dispose(id obj);

/**
 * 返回对象的类
 */
 Class object_getClass(id obj);

/**
 * 设置对象的类
 */
 Class object_setClass(id obj, Class cls);


/**
 * Returns whether an object is a class object.
 *
 * @param obj An Objective-C object.
 *
 * @return true if the object is a class or metaclass, false otherwise.
 */
 BOOL object_isClass(id obj);


/**
 * 返回给定对象的类名
 */
 const char *object_getClassName(id obj);

/**
 * 返回指向给定对象分配的任何额外字节的指针
 */
 void *object_getIndexedIvars(id obj);

/**
 * 返回对象中实例变量的值
    如果实例变量的Ivar已经知道，那么调用object_getIvar会比object_getInstanceVariable函数快，相同情况下，object_setIvar也比object_setInstanceVariable快。
 */
 id object_getIvar(id obj, Ivar ivar);

/**
 * 设置对象中实例变量的值
 */
 void object_setIvar(id obj, Ivar ivar, id value);

/**
 * 修改类实例的实例变量的值
 */
 Ivar object_setInstanceVariable(id obj, const char *name, void *value);

/**
 * 获取对象实例变量的值
 */
 Ivar object_getInstanceVariable(id obj, const char *name, void **outValue);


/**
    根据char *name返回类名
    返回指定类的类定义。
 
 获取类定义的方法有三个：objc_lookUpClass, objc_getClass和objc_getRequiredClass。如果类在运行时未注册，则objc_lookUpClass会返回nil，而objc_getClass会调用类处理回调，并再次确认类是否注册，如果确认未注册，再返回nil。而objc_getRequiredClass函数的操作与objc_getClass相同，只不过如果没有找到类，则会杀死进程。
 */
 Class objc_getClass(const char *name);

/**
 *  返回指定类的元类
    如果指定的类没有注册，则该函数会调用类处理回调，并再次确认类是否注册，如果确认未注册，再返回nil。不过，每个类定义都必须有一个有效的元类定义，所以这个函数总是会返回一个元类定义，不管它是否有效。
 */
 Class objc_getMetaClass(const char *name);


/**
 *  返回指定类的类定义。
 */
 Class objc_lookUpClass(const char *name);
 Class objc_getRequiredClass(const char *name);

/**
 * 获取已注册的类定义的列表
    objc_getClassList函数：获取已注册的类定义的列表。我们不能假设从该函数中获取的类对象是继承自NSObject体系的，所以在这些类上调用方法是，都应该先检测一下这个方法是否在这个类中实现。
 */
 int objc_getClassList(Class *buffer, int bufferCount);

/**
 * 创建并返回一个指向所有已注册类的指针列表
 */
 Class *objc_copyClassList(unsigned int *outCount);


/* Working with Classes */

/**
    获取类的类名
 * 对于class_getName函数，如果传入的cls为Nil，则返回一个字字符串。
 */
 const char *class_getName(Class cls);

/**
 * 判断给定的Class是否是一个元类
 */
 BOOL class_isMetaClass(Class cls);

/**
 * 获取类的父类
    当cls为Nil或者cls为根类时，返回Nil。不过通常我们可以使用NSObject类的superclass方法来达到同样的目的。
 */
 Class class_getSuperclass(Class cls);

/**
 * Sets the superclass of a given class.
 *
 * @param cls The class whose superclass you want to set.
 * @param newSuper The new superclass for cls.
 *
 * @return The old superclass for cls.
 *
 * @warning You should not use this function.
 */
 Class class_setSuperclass(Class cls, Class newSuper)
__OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_5,__MAC_10_5, __IPHONE_2_0,__IPHONE_2_0);

/**
 * 获取版本号
 */
 int class_getVersion(Class cls);

/**
 * 设置版本号
 */
 void class_setVersion(Class cls, int version);

/**
 * 获取实例大小
 */
 size_t class_getInstanceSize(Class cls);

/**
 * 获取类中指定名称实例成员变量的信息
    返回一个指向包含name指定的成员变量信息的objc_ivar结构体的指针(Ivar)
 */
 Ivar class_getInstanceVariable(Class cls, const char *name);

/**
 * 获取类成员变量的信息
    目前没有找到关于Objective-C中类变量的信息，一般认为Objective-C不支持类变量。注意，返回的列表不包含父类的成员变量和属性。
 */
 Ivar class_getClassVariable(Class cls, const char *name);

/**
 * 获取整个成员变量列表
    返回一个指向成员变量信息的数组，数组中每个元素是指向该成员变量信息的objc_ivar结构体的指针。这个数组不包含在父类中声明的变量。outCount指针返回数组的大小。需要注意的是，我们必须使用free()来释放这个数组。
 */
 Ivar *class_copyIvarList(Class cls, unsigned int *outCount);

/**
 * 获取实例方法
    class_getInstanceMethod、class_getClassMethod函数，与class_copyMethodList不同的是，这两个函数都会去搜索父类的实现。
 */
 Method class_getInstanceMethod(Class cls, SEL name);

/**
 * 获取类方法
 */
 Method class_getClassMethod(Class cls, SEL name);

/**
 * 返回方法的具体实现
    class_getMethodImplementation函数，该函数在向类实例发送消息时会被调用，并返回一个指向方法实现函数的指针。这个函数会比method_getImplementation(class_getInstanceMethod(cls, name))更快。返回的函数指针可能是一个指向runtime内部的函数，而不一定是方法的实际实现。例如，如果类实例无法响应selector，则返回的函数指针将是运行时消息转发机制的一部分。
 */
 IMP class_getMethodImplementation(Class cls, SEL name);
 IMP class_getMethodImplementation_stret(Class cls, SEL name);

/**
 * 类实例是否响应指定的selector
    class_respondsToSelector函数，我们通常使用NSObject类的respondsToSelector:或instancesRespondToSelector:方法来达到相同目的。
 */
 BOOL class_respondsToSelector(Class cls, SEL sel);

/**
 * 获取所有方法的数组
    class_copyMethodList函数，返回包含所有实例方法的数组，如果需要获取类方法，则可以使用class_copyMethodList(object_getClass(cls), &count)(一个类的实例方法是定义在元类里面)。该列表不包含父类实现的方法。outCount参数返回方法的个数。在获取到列表后，我们需要使用free()方法来释放它。
 */
 Method *class_copyMethodList(Class cls, unsigned int *outCount);

/**
 * 返回类是否实现指定的协议
    class_conformsToProtocol函数可以使用NSObject类的conformsToProtocol:方法来替代。
 */
 BOOL class_conformsToProtocol(Class cls, Protocol *protocol);

/**
 * 返回类实现的协议列表
    class_copyProtocolList函数返回的是一个数组，在使用后我们需要使用free()手动释放。
 */
 Protocol * __unsafe_unretained *class_copyProtocolList(Class cls, unsigned int *outCount);

/**
 * 获取指定的属性
 */
 objc_property_t class_getProperty(Class cls, const char *name);

/**
 * 获取属性列表
 */
 objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount);

/**
 * 在MAC OS X系统中，我们可以使用垃圾回收器。runtime提供了几个函数来确定一个对象的内存区域是否可以被垃圾回收器扫描，以处理strong/weak引用。
 
 但通常情况下，我们不需要去主动调用这些方法；在调用objc_registerClassPair时，会生成合理的布局。在此不详细介绍这些函数。
 */
 const uint8_t *class_getIvarLayout(Class cls);
 const uint8_t *class_getWeakIvarLayout(Class cls);

/**
 * 增加了一个新的方法，以一类具有给定名称和实施
    class_addMethod的实现会覆盖父类的方法实现，但不会取代本类中已存在的实现，如果本类中包含一个同名的实现，则函数会返回NO。如果要修改已存在实现，可以使用method_setImplementation。一个Objective-C方法是一个简单的C函数，它至少包含两个参数—self和_cmd。
 */
 BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types);

/**
 * 替代方法的实现
    class_replaceMethod函数，该函数的行为可以分为两种：如果类中不存在name指定的方法，则类似于class_addMethod函数一样会添加方法；如果类中已存在name指定的方法，则类似于method_setImplementation一样替代原方法的实现。
 */
 IMP class_replaceMethod(Class cls, SEL name, IMP imp, const char *types);

/**
 * 添加成员变量
    Objective-C不支持往已存在的类中添加实例变量，因此不管是系统库提供的提供的类，还是我们自定义的类，都无法动态添加成员变量。但如果我们通过运行时来创建一个类的话，又应该如何给它添加成员变量呢？这时我们就可以使用class_addIvar函数了。不过需要注意的是，这个方法只能在objc_allocateClassPair函数与objc_registerClassPair之间调用。另外，这个类也不能是元类。成员变量的按字节最小对齐量是1<<alignment。这取决于ivar的类型和机器的架构。如果变量的类型是指针类型，则传递log2(sizeof(pointer_type))。
 */
 BOOL class_addIvar(Class cls, const char *name, size_t size, uint8_t alignment, const char *types);

/**
 * 添加协议
 */
 BOOL class_addProtocol(Class cls, Protocol *protocol);

/**
 * 为类添加属性
 */
 BOOL class_addProperty(Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount);

/**
 * 替换类的属性
 */
 void class_replaceProperty(Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount);

/**
 * 在MAC OS X系统中，我们可以使用垃圾回收器。runtime提供了几个函数来确定一个对象的内存区域是否可以被垃圾回收器扫描，以处理strong/weak引用。
 
 但通常情况下，我们不需要去主动调用这些方法；在调用objc_registerClassPair时，会生成合理的布局。在此不详细介绍这些函数。
 */
 void class_setIvarLayout(Class cls, const uint8_t *layout);
 void class_setWeakIvarLayout(Class cls, const uint8_t *layout);

/**
 * runtime还提供了两个函数来供CoreFoundation的tool-free bridging使用
    通常我们不直接使用这两个函数。
 */
 Class objc_getFutureClass(const char *name);
void objc_setFutureClass ( Class cls, const char *name );


/* Instantiating Classes */

/**
 * 创建类实例
     class_createInstance函数：创建实例时，会在默认的内存区域为类分配内存。extraBytes参数表示分配的额外字节数。这些额外的字节可用于存储在类定义中所定义的实例变量之外的实例变量。该函数在ARC环境下无法使用。
 
 调用class_createInstance的效果与+alloc方法类似。不过在使用class_createInstance时，我们需要确切的知道我们要用它来做什么。
 */
 id class_createInstance(Class cls, size_t extraBytes);

/**
 * 在指定位置创建类实例
 */
 id objc_constructInstance(Class cls, void *bytes);

/**
 * 销毁类实例
    销毁一个类的实例，但不会释放并移除任何与其相关的引用。
 */
 void *objc_destructInstance(id obj);


/**
 * 创建一个新的类和元类。
    objc_allocateClassPair函数：如果我们要创建一个根类，则superclass指定为Nil。extraBytes通常指定为0，该参数是分配给类和元类对象尾部的索引ivars的字节数。
    为了创建一个新类，我们需要调用objc_allocateClassPair。然后使用诸如class_addMethod，class_addIvar等函数来为新创建的类添加方法、实例变量和属性等。完成这些后，我们需要调用objc_registerClassPair函数来注册类，之后这个新类就可以在程序中使用了。
 
    实例方法和实例变量应该添加到类自身上，而类方法应该添加到类的元类上。
 */
Class objc_allocateClassPair(Class superclass, const char *name, size_t extraBytes);

/**
 * 在应用中注册由objc_allocateClassPair创建的类
 */
void objc_registerClassPair(Class cls);

/**
 * Used by Foundation's Key-Value Observing.
 *
 * @warning Do not call this function yourself.
 */
 Class objc_duplicateClass(Class original, const char *name, size_t extraBytes);

/**
 * 销毁一个类及其相关联的类
    objc_disposeClassPair函数用于销毁一个类，不过需要注意的是，如果程序运行中还存在类或其子类的实例，则不能调用针对类调用该方法。
 */
 void objc_disposeClassPair(Class cls);


/* Working with Methods */

/**
 * 获取方法名
    method_getName函数，返回的是一个SEL。如果想获取方法名的C字符串，可以使用sel_getName(method_getName(method))。
 */
 SEL method_getName(Method m);

/**
 * 返回方法的实现
 */
 IMP method_getImplementation(Method m);

/**
 * 获取描述方法参数和返回值类型的字符串
 */
 const char *method_getTypeEncoding(Method m);

/**
 * 返回方法的参数的个数
 */
 unsigned int method_getNumberOfArguments(Method m);

/**
 * 获取方法的返回值类型的字符串
 */
 char *method_copyReturnType(Method m);

/**
 * 获取方法的指定位置参数的类型字符串
 */
 char *method_copyArgumentType(Method m, unsigned int index);

/**
 * 通过引用返回方法的返回值类型字符串
    method_getReturnType函数，类型字符串会被拷贝到dst中。
 */
 void method_getReturnType(Method m, char *dst, size_t dst_len);

/**
 * 通过引用返回方法指定位置参数的类型字符串
 */
 void method_getArgumentType(Method m, unsigned int index,
                                        char *dst, size_t dst_len);

/**
 *  返回指定方法的方法描述结构体
 */
 struct objc_method_description *method_getDescription(Method m);

/**
 * 设置方法的实现
    method_setImplementation函数，注意该函数返回值是方法之前的实现。
 */
 IMP method_setImplementation(Method m, IMP imp);

/**
 * 交换两个方法的实现
 */
 void method_exchangeImplementations(Method m1, Method m2);


/* Working with Instance Variables */

/**
 * 获取成员变量名
 */
 const char *ivar_getName(Ivar v);

/**
 * 获取成员变量类型编码
 */
 const char *ivar_getTypeEncoding(Ivar v);

/**
 * 获取成员变量的偏移量
    ivar_getOffset函数，对于类型id或其它对象类型的实例变量，可以调用object_getIvar和object_setIvar来直接访问成员变量，而不使用偏移量。
 */
 ptrdiff_t ivar_getOffset(Ivar v);


/* Working with Properties */

/**
 * 获取属性名
 */
 const char *property_getName(objc_property_t property);

/**
 * 获取属性特性描述字符串
 */
 const char *property_getAttributes(objc_property_t property);

/**
 * 获取属性的特性列表
 property_copyAttributeList函数，返回值在使用完后需要调用free()释放。
 */
 objc_property_attribute_t *property_copyAttributeList(objc_property_t property, unsigned int *outCount);

/**
 * 获取属性中指定的特性
 property_copyAttributeValue函数，返回的char *在使用完后需要调用free()释放。
 */
 char *property_copyAttributeValue(objc_property_t property, const char *attributeName);


/* Working with Protocols */

/**
 * Returns a specified protocol.
 *
 * @param name The name of a protocol.
 *
 * @return The protocol named \e name, or \c NULL if no protocol named \e name could be found.
 *
 * @note This function acquires the runtime lock.
 */
 Protocol *objc_getProtocol(const char *name);

/**
 * Returns an array of all the protocols known to the runtime.
 *
 * @param outCount Upon return, contains the number of protocols in the returned array.
 *
 * @return A C array of all the protocols known to the runtime. The array contains \c *outCount
 *  pointers followed by a \c NULL terminator. You must free the list with \c free().
 *
 * @note This function acquires the runtime lock.
 */
 Protocol * __unsafe_unretained *objc_copyProtocolList(unsigned int *outCount);

/**
 * Returns a Boolean value that indicates whether one protocol conforms to another protocol.
 *
 * @param proto A protocol.
 * @param other A protocol.
 *
 * @return \c YES if \e proto conforms to \e other, otherwise \c NO.
 *
 * @note One protocol can incorporate other protocols using the same syntax
 *  that classes use to adopt a protocol:
 *  \code
 *  @protocol ProtocolName < protocol list >
 *  \endcode
 *  All the protocols listed between angle brackets are considered part of the ProtocolName protocol.
 */
 BOOL protocol_conformsToProtocol(Protocol *proto, Protocol *other);

/**
 * Returns a Boolean value that indicates whether two protocols are equal.
 *
 * @param proto A protocol.
 * @param other A protocol.
 *
 * @return \c YES if \e proto is the same as \e other, otherwise \c NO.
 */
 BOOL protocol_isEqual(Protocol *proto, Protocol *other);

/**
 * Returns the name of a protocol.
 *
 * @param p A protocol.
 *
 * @return The name of the protocol \e p as a C string.
 */
 const char *protocol_getName(Protocol *p);

/**
 * Returns a method description structure for a specified method of a given protocol.
 *
 * @param p A protocol.
 * @param aSel A selector.
 * @param isRequiredMethod A Boolean value that indicates whether aSel is a required method.
 * @param isInstanceMethod A Boolean value that indicates whether aSel is an instance method.
 *
 * @return An \c objc_method_description structure that describes the method specified by \e aSel,
 *  \e isRequiredMethod, and \e isInstanceMethod for the protocol \e p.
 *  If the protocol does not contain the specified method, returns an \c objc_method_description structure
 *  with the value \c {NULL, \c NULL}.
 *
 * @note This function recursively searches any protocols that this protocol conforms to.
 */
 struct objc_method_description protocol_getMethodDescription(Protocol *p, SEL aSel, BOOL isRequiredMethod, BOOL isInstanceMethod);

/**
 * Returns an array of method descriptions of methods meeting a given specification for a given protocol.
 *
 * @param p A protocol.
 * @param isRequiredMethod A Boolean value that indicates whether returned methods should
 *  be required methods (pass YES to specify required methods).
 * @param isInstanceMethod A Boolean value that indicates whether returned methods should
 *  be instance methods (pass YES to specify instance methods).
 * @param outCount Upon return, contains the number of method description structures in the returned array.
 *
 * @return A C array of \c objc_method_description structures containing the names and types of \e p's methods
 *  specified by \e isRequiredMethod and \e isInstanceMethod. The array contains \c *outCount pointers followed
 *  by a \c NULL terminator. You must free the list with \c free().
 *  If the protocol declares no methods that meet the specification, \c NULL is returned and \c *outCount is 0.
 *
 * @note Methods in other protocols adopted by this protocol are not included.
 */
 struct objc_method_description *protocol_copyMethodDescriptionList(Protocol *p, BOOL isRequiredMethod, BOOL isInstanceMethod, unsigned int *outCount);

/**
 * Returns the specified property of a given protocol.
 *
 * @param proto A protocol.
 * @param name The name of a property.
 * @param isRequiredProperty A Boolean value that indicates whether name is a required property.
 * @param isInstanceProperty A Boolean value that indicates whether name is a required property.
 *
 * @return The property specified by \e name, \e isRequiredProperty, and \e isInstanceProperty for \e proto,
 *  or \c NULL if none of \e proto's properties meets the specification.
 */
 objc_property_t protocol_getProperty(Protocol *proto, const char *name, BOOL isRequiredProperty, BOOL isInstanceProperty);

/**
 * Returns an array of the properties declared by a protocol.
 *
 * @param proto A protocol.
 * @param outCount Upon return, contains the number of elements in the returned array.
 *
 * @return A C array of pointers of type \c objc_property_t describing the properties declared by \e proto.
 *  Any properties declared by other protocols adopted by this protocol are not included. The array contains
 *  \c *outCount pointers followed by a \c NULL terminator. You must free the array with \c free().
 *  If the protocol declares no properties, \c NULL is returned and \c *outCount is \c 0.
 */
 objc_property_t *protocol_copyPropertyList(Protocol *proto, unsigned int *outCount);

/**
 * Returns an array of the protocols adopted by a protocol.
 *
 * @param proto A protocol.
 * @param outCount Upon return, contains the number of elements in the returned array.
 *
 * @return A C array of protocols adopted by \e proto. The array contains \e *outCount pointers
 *  followed by a \c NULL terminator. You must free the array with \c free().
 *  If the protocol declares no properties, \c NULL is returned and \c *outCount is \c 0.
 */
 Protocol * __unsafe_unretained *protocol_copyProtocolList(Protocol *proto, unsigned int *outCount);

/**
 * Creates a new protocol instance that cannot be used until registered with
 * \c objc_registerProtocol()
 *
 * @param name The name of the protocol to create.
 *
 * @return The Protocol instance on success, \c nil if a protocol
 *  with the same name already exists.
 * @note There is no dispose method for this.
 */
 Protocol *objc_allocateProtocol(const char *name);

/**
 * Registers a newly constructed protocol with the runtime. The protocol
 * will be ready for use and is immutable after this.
 *
 * @param proto The protocol you want to register.
 */
 void objc_registerProtocol(Protocol *proto);

/**
 * Adds a method to a protocol. The protocol must be under construction.
 *
 * @param proto The protocol to add a method to.
 * @param name The name of the method to add.
 * @param types A C string that represents the method signature.
 * @param isRequiredMethod YES if the method is not an optional method.
 * @param isInstanceMethod YES if the method is an instance method.
 */
 void protocol_addMethodDescription(Protocol *proto, SEL name, const char *types, BOOL isRequiredMethod, BOOL isInstanceMethod);

/**
 * Adds an incorporated protocol to another protocol. The protocol being
 * added to must still be under construction, while the additional protocol
 * must be already constructed.
 *
 * @param proto The protocol you want to add to, it must be under construction.
 * @param addition The protocol you want to incorporate into \e proto, it must be registered.
 */
 void protocol_addProtocol(Protocol *proto, Protocol *addition);

/**
 * Adds a property to a protocol. The protocol must be under construction.
 *
 * @param proto The protocol to add a property to.
 * @param name The name of the property.
 * @param attributes An array of property attributes.
 * @param attributeCount The number of attributes in \e attributes.
 * @param isRequiredProperty YES if the property (accessor methods) is not optional.
 * @param isInstanceProperty YES if the property (accessor methods) are instance methods.
 *  This is the only case allowed fo a property, as a result, setting this to NO will
 *  not add the property to the protocol at all.
 */
 void protocol_addProperty(Protocol *proto, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount, BOOL isRequiredProperty, BOOL isInstanceProperty);


/* Working with Libraries */

/**
 * Returns the names of all the loaded Objective-C frameworks and dynamic
 * libraries.
 *
 * @param outCount The number of names returned.
 *
 * @return An array of C strings of names. Must be free()'d by caller.
 */
 const char **objc_copyImageNames(unsigned int *outCount);

/**
 * Returns the dynamic library name a class originated from.
 *
 * @param cls The class you are inquiring about.
 *
 * @return The name of the library containing this class.
 */
 const char *class_getImageName(Class cls);

/**
 * Returns the names of all the classes within a library.
 *
 * @param image The library or framework you are inquiring about.
 * @param outCount The number of class names returned.
 *
 * @return An array of C strings representing the class names.
 */
 const char **objc_copyClassNamesForImage(const char *image,
                                                     unsigned int *outCount);


/* Working with Selectors */

/**
 * 返回给定选择器指定的方法的名称
 */
 const char *sel_getName(SEL sel);

/**
 * 在Objective-C Runtime系统中注册一个方法
 */
 SEL sel_getUid(const char *str);

/**
 *   在Objective-C Runtime系统中注册一个方法，将方法名映射到一个选择器，并返回这个选择器
    sel_registerName函数：在我们将一个方法添加到类定义时，我们必须在Objective-C Runtime系统中注册一个方法名以获取方法的选择器。
 我们可以在运行时添加新的selector，也可以在运行时获取已存在的selector，我们可以通过下面三种方法来获取SEL:
 
 sel_registerName函数
 Objective-C编译器提供的@selector()
 NSSelectorFromString()方法
 */
 SEL sel_registerName(const char *str);

/**
 * 比较两个选择器
 */
 BOOL sel_isEqual(SEL lhs, SEL rhs);


/* Objective-C Language Features */

/**
 * This function is inserted by the compiler when a mutation
 * is detected during a foreach iteration. It gets called
 * when a mutation occurs, and the enumerationMutationHandler
 * is enacted if it is set up. A fatal error occurs if a handler is not set up.
 *
 * @param obj The object being mutated.
 *
 */
 void objc_enumerationMutation(id obj);

/**
 * Sets the current mutation handler.
 *
 * @param handler Function pointer to the new mutation handler.
 */
 void objc_setEnumerationMutationHandler(void (*handler)(id));

/**
 * Set the function to be called by objc_msgForward.
 *
 * @param fwd Function to be jumped to by objc_msgForward.
 * @param fwd_stret Function to be jumped to by objc_msgForward_stret.
 *
 * @see message.h::_objc_msgForward
 */
 void objc_setForwardHandler(void *fwd, void *fwd_stret);

/**
 * Creates a pointer to a function that will call the block
 * when the method is called.
 *
 * @param block The block that implements this method. Its signature should
 *  be: method_return_type ^(id self, method_args...).
 *  The selector is not available as a parameter to this block.
 *  The block is copied with \c Block_copy().
 *
 * @return The IMP that calls this block. Must be disposed of with
 *  \c imp_removeBlock.
 */
 IMP imp_implementationWithBlock(id block);

/**
 * Return the block associated with an IMP that was created using
 * \c imp_implementationWithBlock.
 *
 * @param anImp The IMP that calls this block.
 *
 * @return The block called by \e anImp.
 */
 id imp_getBlock(IMP anImp);

/**
 * Disassociates a block from an IMP that was created using
 * \c imp_implementationWithBlock and releases the copy of the
 * block that was created.
 *
 * @param anImp An IMP that was created using \c imp_implementationWithBlock.
 *
 * @return YES if the block was released successfully, NO otherwise.
 *  (For example, the block might not have been used to create an IMP previously).
 */
 BOOL imp_removeBlock(IMP anImp);

/**
 * This loads the object referenced by a weak pointer and returns it, after
 * retaining and autoreleasing the object to ensure that it stays alive
 * long enough for the caller to use it. This function would be used
 * anywhere a __weak variable is used in an expression.
 *
 * @param location The weak pointer address
 *
 * @return The object pointed to by \e location, or \c nil if \e location is \c nil.
 */
 id objc_loadWeak(id *location);

/**
 * This function stores a new value into a __weak variable. It would
 * be used anywhere a __weak variable is the target of an assignment.
 *
 * @param location The address of the weak pointer itself
 * @param obj The new object this weak ptr should now point to
 *
 * @return The value stored into \e location, i.e. \e obj
 */
 id objc_storeWeak(id *location, id obj);


/* Associative References */

/**
 * Policies related to associative references.
 * These are options to objc_setAssociatedObject()
 */
typedef OBJC_ENUM(uintptr_t, objc_AssociationPolicy) {
    OBJC_ASSOCIATION_ASSIGN = 0,           /**< Specifies a weak reference to the associated object. */
    OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, /**< Specifies a strong reference to the associated object.
                                            *   The association is not made atomically. */
    OBJC_ASSOCIATION_COPY_NONATOMIC = 3,   /**< Specifies that the associated object is copied.
                                            *   The association is not made atomically. */
    OBJC_ASSOCIATION_RETAIN = 01401,       /**< Specifies a strong reference to the associated object.
                                            *   The association is made atomically. */
    OBJC_ASSOCIATION_COPY = 01403          /**< Specifies that the associated object is copied.
                                            *   The association is made atomically. */
    };
    
    /**
     * 设置关联对象
     */
     void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
    
    /**
     *  获取关联对象
     */
     id objc_getAssociatedObject(id object, const void *key);
    
    /**
     * 我们可以使用objc_removeAssociatedObjects函数来移除一个关联对象，或者使用objc_setAssociatedObject函数将key指定的关联对象设置为nil。
     */
     void objc_removeAssociatedObjects(id object);

#endif
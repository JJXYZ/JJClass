//
//  ViewController.m
//  JJ_Class_04_KVO的实现原理
//
//  Created by Jay on 16/8/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"
#import "DuPerson.h"

@interface ViewController ()

@property (nonatomic, strong) DuPerson *p;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.p = [[DuPerson alloc] init];
    self.p.age = 1;
    [self.p addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    self.p.age = 3;
}

- (void)dealloc{
    [self.p removeObserver:self forKeyPath:@"age"];
}

/**
 *  疑问
 上述的DuPerson的age属性的值改变了，为什么能调用observeValueForKeyPath: ofObject: change: context:方法？
 */

/**
 *  原理
 系统会动态的生成一个继承于DuPerson的子类，如NSKVONOtifying_DuPerson，然后在该类里面重写setAge:方法，在该子类的setAge:方法实现通知机制，让监听器来调用observeValueForKeyPath: ofObject: change: context:方法来进行监听，所以这里就解决了上面的疑问了。但是又产生了另外一个新的疑问，就是：系统动态生成的NSKVONOtifying_DuPerson类与DuPerson有什么关系？按道理来说，修改p的age属性也只会调用DuPerson类的setAge:方法，但是为什么会执行了NSKVONOtifying_DuPerson的setAge:方法呢？其实这里其关键作用的就是KVO了，那么我们来看看具体的代码实现
 
 通过断点调试可以看到p里面的isa指针指向的是NSKVONOtifying_DuPerson,也就是说p指针指向的对象的类型应经发生改变了
 
 isa指针简介
 其实isa指针是每个对象结构体的首个成员，它是Class类的变量，Class isa,这个变量定义了对象所属的类，所以我们可以通过这个isa变量来查询对象能否响应某个方法，因为一个对象的方法是存放在它所属的类当中，所以我们就可以通过isa变量来找到所属的类，并在该类的方法列表里面寻找对应的方法来实现。
 好了，此时我们就可以解决上述的问题了。
 通过KVO监听后，p指针指向的对象的类型已经发生了改变了，isa指针原来指向DuPerson变为NSKVONOtifying_DuPerson了，所以接下来p.age = 3的时候，它调用的不再是DuPerson类的setAge:方法，而是NSKVONOtifying_DuPerson类的setAge:方法，因为p指针指向的对象通过isa指针找到它的父类，然后再在父类的方法列表里面找到对应的方法来进行实现了。
 NSKVONOtifying_DuPerson类重写setAge:方法
 
 简单的总结：表面看起来是属于A类，底层实现却是属于B类。就例如NSMutableArray底层的真实类型是_NSArrayM一样。
 
 */

/**
 *
 *
 *  @param keyPath 被修改的属性
 *  @param object  被修改的属性所属的对象
 *  @param change  属性改变情况（新旧值）
 *  @param context void * == id
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"%@对象的%@属性改变了：%@",object,keyPath,change);
}


@end

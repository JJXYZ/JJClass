//
//  VC2.m
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2016/9/18.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "VC2.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RWDummySignInService.h"

@interface VC2 ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) RWDummySignInService *signInService;

@end

@implementation VC2

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self signInSignal_then_filter_flattenMap_deliverOn_subscribeNext_RAC];
}

#pragma mark - Private Methods

- (BOOL)isValidName:(NSString *)username {
    return username.length > 3;
}

- (RACSignal *)signInSignal_Service
{
    // 定义一个错误，如果用户拒绝访问则发送
    NSError *accessError = nil;
    
    RACSignal *signInSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.signInService signInWithUsername:self.nameTextField.text password:nil complete:^(BOOL success) {
            // 处理响应
            success = YES;
            if (success) {
                NSLog(@"signInSignal_Service:%d", success);
                [subscriber sendNext:@(success)];
                [subscriber sendCompleted];
            }
            else {
                NSLog(@"signInSignal_Service:%d", success);
                [subscriber sendError:accessError];
            }
        }];
        return nil;
    }];
    return signInSignal;
}

- (RACSignal *)customSignal:(NSString *)text {
    RACSignal *customSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"customSignal:%@", text);
        [subscriber sendNext:text];
        [subscriber sendCompleted];
        return nil;
    }];
    return customSignal;
}

/**
    在上图中，我们可以看到每行数据前面有一片空白，这是用来显示用户头像的。RWTweet类已经有一个profileImageUrl属性，它是一个图片的URL地址。为了让UITableTable滑动得更平滑，我们需要让获取指定URL的图片的操作不运行在主线程中。这可以使用GCD或者是NSOperationQueue。不过，ReactiveCocoa同样为我们提供了解决方案。
 */
- (RACSignal *)signalForLoadingImage:(NSString *)imageUrl {
    
    RACScheduler *scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground];
    
    RACSignal *loadingImageSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        [subscriber sendNext:image];
        [subscriber sendCompleted];
        return nil;
    }] subscribeOn:scheduler];
    
    return loadingImageSignal;
}

#pragma mark - nameTextField

/**
 *  考虑下我们添加到TwitterInstant程序中的代码，想知道我们创建的管道是如何被保存的么？当然，因为它没有被指定给变量或属性，所以它没有增加引用计数，因此注定被销毁？ReactiveCocoa设计的目的之一是允许这样一种编程样式，即管道可以匿名创建。到目前为止，我们的管道都是这么处理的。为了支持这种模式，ReactiveCocoa维护了一个全局的信号集合。如果信号有一个或多个订阅者，它就是可用的。如果所有订阅者都被移除了，信号就被释放了。
 
    剩下最后一个问题：如何取消对信号的订阅？在一个completed事件或error事件后，一个订阅者会自动将自己移除。手动移除可能通过RACDisposable来完成。RACSignal的所有订阅方法都返回一个RACDisposable实例，我们可以调用它的dispose方法来手动移除订阅者。如下代码所示：
 
    注意：如果我们创建了一个管道，但不去订阅它，则管理永远不会执行，包括任何如doNext:块这样的附加操作。
 */
- (void)nameTextField_map_subscripion_dispose_RAC {

    RACSignal *validNameSignal = [self.nameTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidName:text]);
    }];
    
    RACDisposable *subscripion = [validNameSignal subscribeNext:^(NSNumber *isValidName) {
        NSLog(@"subscripion:%@", isValidName);
    }];
    
    /** 在某个位置调用 */
    [subscripion dispose];

}

#pragma mark - weakify & strongify

- (void)nameTextField_weakify_strongify_RAC {
    @weakify(self)
    [[self.nameTextField.rac_textSignal map:^id(NSString *text) {
        return [self isValidName:text] ? [UIColor whiteColor] : [UIColor yellowColor];
    }] subscribeNext:^(UIColor *color) {
        @strongify(self)
        self.nameTextField.backgroundColor = color;
    }];
}

#pragma mark - signInSignal
/**
 *  一个信号可以发送三种事件类型：next, completed, error。
 
    在信号的整个生命周期中，都可能不会发送事件，或者发送一个或多个next事件，其后跟着completed或error事件。
 
    then方法会等到completed事件发出后调用，然后订阅由block参数返回的信号。这有效地将控制从一个信号传递给下一个信号。
 */
- (void)signInSignal_then_RAC {
    @weakify(self);
    [[[self signInSignal_Service] then:^RACSignal *{
        @strongify(self);
        return self.nameTextField.rac_textSignal;
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    } error:^(NSError *error) {
        NSLog(@"An error occurred: %@", error);
    }];
}

/**
 *  在第一部分中我们学习了如何使用flattenMap来将每个next事件映射到一个新的被订阅的信号。这里我们再次使用它们。在viewDidLoad的最后用如下代码更新：
 */
- (void)signInSignal_then_filter_flattenMap_subscribeNext_RAC {
    @weakify(self);
    [[[[[self signInSignal_Service] then:^RACSignal *{
        @strongify(self)
        return self.nameTextField.rac_textSignal;
    }] filter:^BOOL(NSString *text) {
        @strongify(self)
        return [self isValidName:text];
    }] flattenMap:^RACStream *(NSString *text ) {
        @strongify(self)
        return [self customSignal:text];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    } error:^(NSError *error) {
        NSLog(@"An error occurred: %@", error);
    }];
}

/**
 *  注意，从左侧的线程列表中我们可以看到debugger到的代码并没有运行在主线程，即线程Thread 1。记住，更新UI的操作一定得在主线程中操作；因此，如果要在UI上显示tweet列表，则必须切换线程。
 
    这说明了ReactiveCocoa框架的一个重要点。上面显示的操作是在信号初始发出事件时的那个线程执行。尝试在管道的其它步骤添加断点，我们会很惊奇的发现它们会运行在多个不同的线程上。
 
    因此，我们应该如何来更新UI呢？当然ReactiveCocoa也为我们解决了这个问题。我们只需要在flattenMap:后面添加deliverOn:操作：
 */
- (void)signInSignal_then_filter_flattenMap_deliverOn_subscribeNext_RAC {
    @weakify(self);
    [[[[[[self signInSignal_Service] then:^RACSignal *{
        @strongify(self)
        return self.nameTextField.rac_textSignal;
    }] filter:^BOOL(NSString *text) {
        @strongify(self)
        return [self isValidName:text];
    }] flattenMap:^RACStream *(NSString *text) {
        @strongify(self)
        return [self customSignal:text];
    }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    } error:^(NSError *error) {
        NSLog(@"An error occurred: %@", error);
    }];
}


/**
    现在我们应该熟悉这种模式了。以上的方法首先获取一个后台scheduler作为信号执行的线程，而不是主线程。接下来，创建一个下载图片数据的信号并在其有订阅者时创建一个UIImage。最后我们调用subscribeOn:，以确保信号在给定的scheduler上执行。
 */
- (void)signalForLoadingImage_deliverOn_subscribeNext_RAC {
    
    [[[self signalForLoadingImage:nil] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id image) {
        NSLog(@"subscribeNext:%@", image);
    }];
}

/**
    你可能已经发现每次我们输入一个新的字符时，搜索操作都会立即执行。如果我们快速输入，可能会导致程序在一秒钟内执行了多次搜索操作。这当然是不好的，因为：
 
    我们多次调用了Twitter搜索API，同时扔掉了大部分结果。
    我们不断更新结果会分散用户的注意力。
    一个更好的方案是如果搜索文本在一个较短时间内没有改变时我们再去执行搜索操作，如500毫秒。ReactiveCocoa框架让这一任务变得相当简单。
    throttle操作只有在两次next事件间隔指定的时间时才会发送第二个next事件。相当简单吧。运行程序看看效果吧。
 */
- (void)signInSignal_then_throttle_RAC {
    @weakify(self);
    [[[[[[[self signInSignal_Service] then:^RACSignal *{
        @strongify(self);
        return self.nameTextField.rac_textSignal;
    }] filter:^BOOL(NSString *text) {
        @strongify(self)
        return [self isValidName:text];
    }] throttle:0.5] flattenMap:^RACStream *(NSString *text) {
        @strongify(self)
        return [self customSignal:text];
    }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    } error:^(NSError *error) {
        NSLog(@"An error occurred: %@", error);
    }];
}




#pragma mark - Property

- (RWDummySignInService *)signInService {
    if (_signInService) {
        return _signInService;
    }
    _signInService = [RWDummySignInService new];
    return _signInService;
}

@end

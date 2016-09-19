//
//  VC1.m
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2016/9/16.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "VC1.h"
#import "RWDummySignInService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface VC1 ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (strong, nonatomic) RWDummySignInService *signInService;

@end

@implementation VC1

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self name_PasswordTextField_map_1_RAC];
    [self name_PasswordTextField_map_combineLatest_reduce_RAC];
    [self signInButton_rac_signal_doNext_flattenMap_subscribeNext_RAC];
    
}

#pragma mark - Private Methods

- (BOOL)isValidName:(NSString *)username {
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 3;
}

/**
 *  幸运的是，将一个已存在的异步API表示为一个信号相当简单。
    
    上面的代码创建了一个使用当前用户名与密码登录的信号。现在我们来分解一下这个方法。createSignal:方法用于创建一个信号。描述信号的block是一个信号参数，当信号有一个订阅者时，block中的代码会被执行。
 
    block传递一个实现RACSubscriber协议的subscriber(订阅者)，这个订阅者包含我们调用的用于发送事件的方法；我们也可以发送多个next事件，这些事件由一个error事件或complete事件结束。在上面这种情况下，它发送一个next事件来表示登录是否成功，后续是一个complete事件。
 
    这个block的返回类型是一个RACDisposable对象，它允许我们执行一些清理任务，这些操作可能发生在订阅取消或丢弃时。上面这个这个信号没有任何清理需求，所以返回nil。
 */
- (RACSignal *)signInSignal
{
    RACSignal *signInSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"signInSignal subscriber:%@", subscriber);
        [subscriber sendNext:@(1)];
        [subscriber sendCompleted];
        return nil;
    }];
    return signInSignal;
}

- (RACSignal *)signInSignal_Service
{
    RACSignal *signInSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.signInService signInWithUsername:self.nameTextField.text password:self.passwordTextField.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    return signInSignal;
}

#pragma mark - nameTextField

/**
 *  每次在text field中输入时，都会执行block中的代码。没有target-action，没有代理，只有信号与block
 */
- (void)nameTextFieldRAC {
    [self.nameTextField.rac_textSignal subscribeNext:^(NSString *name) {
        NSLog(@"%@", name);
    }];
}

/**
 *  ReactiveCocoa有大量的操作右用于处理事件流。例如，如果我们只对长度大于3的用户名感兴趣，则我们可以使用filter操作。
 
    通过这种方式，我们创建了一个简单的管道。这就是响应式编程的实质，我们将我们程序的功能表示为数据流的形式
 */
- (void)nameTextField_filter_RAC {
    [[self.nameTextField.rac_textSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 3;
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

/**
 *  在这里需要注意的是filter操作的输出仍然是一个RACSignal对象。我们可以将上面这段管道处理拆分成如下代码：
 
    因为RACSignal对象的每个操作都返回一个RACSignal对象，所以我们不需要使用变量就可以构建一个管道。
 */
- (void)nameTextField_filter_1_RAC {
    RACSignal *nameSignal = self.nameTextField.rac_textSignal;
    
    RACSignal *filterName = [nameSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 3;
    }];
    
    [filterName subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

/**
 *  目前为止，我们已经描述了3种不同的事件类型，但还没有深入这些事件的结构。有趣的是，事件可以包含任何东西。为了证明这一点，我们在上面的管道中加入另一个操作。更新我们的代码：
 
    新添加的map操作使用提供的block来转换事件数据。对于收到的每一个next事件，都会运行给定的block，并将返回值作为next事件发送。在上面的代码中，map操作获取一个NSString输入，并将其映射为一个NSNumber对象，并返回。
 */
- (void)nameTextField_map_filter_RAC {
    [[[self.nameTextField.rac_textSignal map:^id(NSString *text) {
        NSLog(@"map:%@", text);
        NSNumber *numLenth = @(text.length);
        return numLenth;
    }] filter:^BOOL(NSNumber *numLenth) {
        NSLog(@"filter:%@", numLenth);
        BOOL isFilter = numLenth.integerValue > 3;
        return isFilter;
    }] subscribeNext:^(id x) {
        NSLog(@"subscribeNext:%@", x);
    }];
}

#pragma mark - nameTextField & passwordTextField

/**
 *  我们要做的第一件事就是创建一对信号来校验用户名与密码的输入是否有效。
 
    我们使用将map操作应用于文本输入框的rac_textSignal，输出是一个NSNumber对象。接着将转换这些信号，以便其可以为文本输入框提供一个合适的背影颜色。我们可以订阅这个信号并使用其结果来更新文本输入框的颜色。可以如下操作：
 */
- (void)name_PasswordTextField_map_RAC {
    
    RACSignal *validNameSignal = [self.nameTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidName:text]);
    }];
    
    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidPassword:text]);
    }];
    
    
    [[validNameSignal map:^id(NSNumber *nameValid) {
        return [nameValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }] subscribeNext:^(UIColor *color) {
        self.nameTextField.backgroundColor = color;
    }];
    
    [[validPasswordSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }] subscribeNext:^(UIColor *color) {
        self.passwordTextField.backgroundColor = color;
    }];
}

/**
 *  从概念上讲，我们将信号的输出值赋值给文本输入框的backgroundColor属性。但是这段代码有点糟糕。我们可以以另外一种方式来做相同的处理。这得益于ReactiveCocoa定义的一些宏。如下代码所示：
 
    RAC宏我们将信号的输入值指派给对象的属性。它带有两个参数，第一个参数是对象，第二个参数是对象的属性名。每次信号发送下一个事件时，其输出值都会指派给给定的属性。这是个非常优雅的解决方案，对吧？
 */
- (void)name_PasswordTextField_map_1_RAC {
    
    RACSignal *validNameSignal = [self.nameTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidName:text]);
    }];
    
    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidPassword:text]);
    }];

    RAC(self.nameTextField, backgroundColor) = [validNameSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    RAC(self.passwordTextField, backgroundColor) = [validPasswordSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
}

/**
 *  在当前的程序中，Sign in按钮只有在两个输入框都有效时才可点击。是时候处理这个响应了。
 
    当前代码有两个信号来标识用户名和密码是否有效：validUsernameSignal和validPasswordSignal。我们的任务是要组合这两个信号，来确定按钮是否可用。
 */
- (void)name_PasswordTextField_map_combineLatest_reduce_RAC {
    
    RACSignal *validNameSignal = [self.nameTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidName:text]);
    }];
    
    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidPassword:text]);
    }];
    
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validNameSignal, validPasswordSignal] reduce:^id(NSNumber *isValidName, NSNumber *isValidPassword) {
        NSNumber *isValid = @(isValidName.boolValue && isValidPassword.boolValue);
        return isValid;
    }];
    
    /**
     *  上面的代码使用了combineLatest:reduce:方法来组合validUsernameSignal与validPasswordSignal最后输出的值，并生成一个新的信号。每次两个源信号中的一个输出新值时，reduce块都会被执行，而返回的值会作为组合信号的下一个值。
     
     注意：RACSignal组合方法可以组合任何数量的信号，而reduce块的参数会对应每一个信号。
     */
    
    /**
     *  现在我们已以有了一个合适的信号，接着在viewDidLoad结尾中添加以下代码，这将信号连接到按钮的enabled属性。
     */
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        self.signInButton.enabled = signupActive.boolValue;
    }];
    
}

#pragma mark - signInButton

/**
    上面的代码从按钮的UIControlEventTouchUpInside事件中创建一个信号，并添加订阅以在每次事件发生时添加日志。
 */
- (void)signInButton_rac_signal_RAC {
    [[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"Button clicked");
    }];
}


/**
 *  可以看到，我们就这样在信号中封装了一个异步API。现在，我们可以使用这个新的信号了，更新viewDidLoad中我们的代码吧：
    
    当点击按钮时rac_signalForControlEvents发出了一个next事件。map这一步创建并返回一个登录信号，意味着接下来的管理接收一个RACSignal。这是我们在subscribeNext:中观察到的对象。
    上面这个方案有时候称为信号的信号(signal of signals)，换句话说，就是一个外部信号包含一个内部信号。可以在输出信号的subscribeNext:块中订阅内部信号。但这会引起嵌套的麻烦。幸运的是，这是个普遍的问题，而ReactiveCocoa已经提供了解决方案。
 */
- (void)signInButton_rac_signal_map_subscribeNext_RAC {
    
    [[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id(id value) {
        return self.signInButton;
    }] subscribeNext:^(id x) {
        NSLog(@"Sign in result: %@", x);
    }];
}

/**
 *  这个问题有解决方案是直观的，只需要使用flattenMap来替换map
 */
- (void)signInButton_rac_signal_flattenMap_subscribeNext_RAC {
    
    [[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self signInSignal_Service];
    }] subscribeNext:^(id x) {
        NSLog(@"Sign in result: %@", x);
    }];
}


/**
 *  我们可以看到在按钮点击事件后添加了doNext:步骤。注意doNext:并不返回一个值，因为它是附加操作。它完成时不改变事件。
 
    注意：在执行异步方法时禁用按钮是个普遍的问题，ReactiveCocoa同样解决了这个问题。RACCommand类封装了这个概念，同时有一个enabled信号以允许我们将一个按钮的enabled属性连接到信号。可以试试。
 */
- (void)signInButton_rac_signal_doNext_flattenMap_subscribeNext_RAC {
    [[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        self.signInButton.enabled = NO;
    }] flattenMap:^RACStream *(id value) {
        return [self signInSignal_Service];
    }] subscribeNext:^(NSNumber *signedIn) {
        self.signInButton.enabled = YES;
        NSLog(@"Sign in result: %@", signedIn);
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

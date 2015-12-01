//
//  RWSearchFormViewController.m
//  TwitterInstant
//
//  Created by Colin Eberhardt on 02/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "RWSearchFormViewController.h"
#import "RWSearchResultsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RACEXTScope.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

/**
 *  然后在下面添加枚举及常量用于标识错误：
 */
typedef NS_ENUM(NSInteger, RWTwitterInstantError) {
    RWTwitterInstantErrorAccessDenied,
    RWTwitterInstantErrorNoTwitterAccounts,
    RWTwitterInstantErrorInvalidResponse
};
static NSString * const RWTwitterInstantDomain = @"TwitterInstant";




@interface RWSearchFormViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchText;

@property (strong, nonatomic) RWSearchResultsViewController *resultsViewController;


@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *twitterAccountType;

@end

@implementation RWSearchFormViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Twitter Instant";
  
  [self styleTextField:self.searchText];
  
  self.resultsViewController = self.splitViewController.viewControllers[1];

#if 0
    /**
     *  这段代码通过信号来检测输入是否有效，并设置相应的输入框背影颜色值。
        rac_textSignal在每次输入时发出next事件，并包含当前输入框的文本。然后map操作将其转换为颜色值，最后subscribeNext:获取这个颜色值并用它来设置输入框的背景颜色。
     */
    [[self.searchText.rac_textSignal map:^id(NSString *text) {
        return [self isValidSearchText:text] ? [UIColor whiteColor] : [UIColor yellowColor];
    }] subscribeNext:^(UIColor *color) {
        self.searchText.backgroundColor = color;
    }];
#endif
    
    /**
     *  考虑下我们添加到TwitterInstant程序中的代码，想知道我们创建的管道是如何被保存的么？当然，因为它没有被指定给变量或属性，所以它没有增加引用计数，因此注定被销毁？ReactiveCocoa设计的目的之一是允许这样一种编程样式，即管道可以匿名创建。到目前为止，我们的管道都是这么处理的。为了支持这种模式，ReactiveCocoa维护了一个全局的信号集合。如果信号有一个或多个订阅者，它就是可用的。如果所有订阅者都被移除了，信号就被释放了。
     */
    
#if 0
    /**
     *  剩下最后一个问题：如何取消对信号的订阅？在一个completed事件或error事件后，一个订阅者会自动将自己移除。手动移除可能通过RACDisposable来完成。RACSignal的所有订阅方法都返回一个RACDisposable实例，我们可以调用它的dispose方法来手动移除订阅者。如下代码所示：
     *
     *  注意：如果我们创建了一个管道，但不去订阅它，则管理永远不会执行，包括任何如doNext:块这样的附加操作。
     */
    RACSignal *backgroundColorSignal = [self.searchText.rac_textSignal map:^id(NSString *text) {
         return [self isValidSearchText:text] ? [UIColor whiteColor] : [UIColor yellowColor];
     }];
    
    RACDisposable *subscripion = [backgroundColorSignal subscribeNext:^(UIColor *color) {
        self.searchText.backgroundColor = color;
    }];
    
    // 在某个位置调用
    [subscripion dispose];
#endif

#if 0
    /**
     *  避免循环引用
     ReactiveCocoa在幕后做了许多事情，让我们不需要担心信号的内存管理问题，但有一点关于内存管理的问题需要特别注意。我们先来看看下面的代码：
     
     subscribeNext:块使用了self，以获取文本输入域。Block会捕获并保留闭包中的值，因此如果在self与信号之间有一个强引用，则会导致循环引用问题。这是不是问题取决于self对象的生命周期。如果self的生命周期是整个程序生存期，则没问题，好好用吧。但在大多数情况下，它确实是一个问题。
     */
    [[self.searchText.rac_textSignal map:^id(NSString *text) {
        return [self isValidSearchText:text] ? [UIColor whiteColor] : [UIColor yellowColor];
    }] subscribeNext:^(UIColor *color) {
        self.searchText.backgroundColor = color;
    }];
#endif
    
#if 1
    /**
     *  为了避循环引用，根据苹果的文档中推荐的捕获self的一个弱引用。如下代码所示：
     */
    __typeof(self) __weak weakSelf = self;
    [[self.searchText.rac_textSignal map:^id(NSString *text) {
        return [weakSelf isValidSearchText:text] ? [UIColor whiteColor] : [UIColor yellowColor];
    }] subscribeNext:^(UIColor *color) {
        weakSelf.searchText.backgroundColor = color;
    }];
    
    /**
     *  在上面的代码中weakSelf是self对象的一个弱引用。现在subscribeNext:中使用了这个变量。不过ReactiveCocoa框架给我们提供了一个更好的选择。首先导入以下头文件：
     
     宏@weakify与@strongify在Extended Objective-C库中引用，它们包含在ReactiveCocoa框架中。@weakify允许我们创建一些影子变量，它是都是弱引用(可以同时创建多个)，@strongify允许创建变量的强引用，这些变量是先前传递给@weakify的。
     */
    @weakify(self)
    [[self.searchText.rac_textSignal map:^id(NSString *text) {
        return [self isValidSearchText:text] ? [UIColor whiteColor] : [UIColor yellowColor];
    }] subscribeNext:^(UIColor *color) {
        @strongify(self)
        self.searchText.backgroundColor = color;
    }];
#endif
    
#if 1
    /**
     *  我们在viewDidLoad的结尾处添加以下代码，来创建账户存储及Twitter账户标识：
     */
    self.accountStore = [[ACAccountStore alloc] init];
    self.twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
#endif
    
#if 1
    /**
     *  一个信号可以发送三种事件类型：next, completed, error。
     
     在信号的整个生命周期中，都可能不会发送事件，或者发送一个或多个next事件，其后跟着completed或error事件。
     
     最后，为了使用这个信号，在viewDidLoad中添加以下代码：
     */
    [[self requestAccessToTwitterSignal] subscribeNext:^(id x) {
         NSLog(@"Access granted");
     } error:^(NSError *error) {
         NSLog(@"An error occurred: %@", error);
     }];
#endif

#if 1
    /**
     *  then方法会等到completed事件发出后调用，然后订阅由block参数返回的信号。这有效地将控制从一个信号传递给下一个信号。
     */
    [[[self requestAccessToTwitterSignal]
      then:^RACSignal *{
          @strongify(self)
          return self.searchText.rac_textSignal;
      }]
     subscribeNext:^(id x) {
         NSLog(@"%@", x);
     } error:^(NSError *error) {
         NSLog(@"An error occurred: %@", error);
     }];
#endif

#if 1
    /**
     *  下一步，我们添加一个filter操作到管道，以移除无效的搜索字符串。在这个实例中，是要求输入长度不小于3：
     */
    [[[[self requestAccessToTwitterSignal] then:^RACSignal *{
           @strongify(self)
           return self.searchText.rac_textSignal;
       }] filter:^BOOL(NSString *text) {
          @strongify(self)
          return [self isValidSearchText:text];
      }] subscribeNext:^(id x) {
         NSLog(@"%@", x);
     } error:^(NSError *error) {
         NSLog(@"An error occurred: %@", error);
     }];
#endif
    
#if 1
    /**
     *  在第一部分中我们学习了如何使用flattenMap来将每个next事件映射到一个新的被订阅的信号。这里我们再次使用它们。在viewDidLoad的最后用如下代码更新：
     */
    [[[[[self requestAccessToTwitterSignal] then:^RACSignal *{
            @strongify(self)
            return self.searchText.rac_textSignal;
        }] filter:^BOOL(NSString *text) {
           @strongify(self)
           return [self isValidSearchText:text];
       }] flattenMap:^RACStream *(NSString *text ) {
          @strongify(self)
          return [self signalForSearchWithText:text];
      }] subscribeNext:^(id x) {
         NSLog(@"%@", x);
     } error:^(NSError *error) {
         NSLog(@"An error occurred: %@", error);
     }];
#endif
    
#if 1
    /**
     *  注意，从左侧的线程列表中我们可以看到debugger到的代码并没有运行在主线程，即线程Thread 1。记住，更新UI的操作一定得在主线程中操作；因此，如果要在UI上显示tweet列表，则必须切换线程。
     
     这说明了ReactiveCocoa框架的一个重要点。上面显示的操作是在信号初始发出事件时的那个线程执行。尝试在管道的其它步骤添加断点，我们会很惊奇的发现它们会运行在多个不同的线程上。
     
     因此，我们应该如何来更新UI呢？当然ReactiveCocoa也为我们解决了这个问题。我们只需要在flattenMap:后面添加deliverOn:操作：
     */
    [[[[[[self requestAccessToTwitterSignal] then:^RACSignal *{
             @strongify(self)
             return self.searchText.rac_textSignal;
         }] filter:^BOOL(NSString *text) {
            @strongify(self)
            return [self isValidSearchText:text];
        }] flattenMap:^RACStream *(NSString *text) {
            @strongify(self)
            return [self signalForSearchWithText:text];
        }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
         NSLog(@"%@", x);
     } error:^(NSError *error) {
         NSLog(@"An error occurred: %@", error);
     }];
#endif
    
}




#pragma mark - Private Methods

- (void)styleTextField:(UITextField *)textField {
  CALayer *textFieldLayer = textField.layer;
  textFieldLayer.borderColor = [UIColor grayColor].CGColor;
  textFieldLayer.borderWidth = 2.0f;
  textFieldLayer.cornerRadius = 0.0f;
}

/**
 *  首先我们来校验输入框的字符长度是否大于2。我们在RWSearchFormViewController.m的viewDidLoad方法下面添加以下代码：
 */
- (BOOL)isValidSearchText:(NSString *)text
{
    return text.length > 2;
}


/**
 *  当账户请求社账号时，用户可以看到一个弹出框。这是一个异步操作，所以将其包装到一个信号中是很好的选择。
 */
- (RACSignal *)requestAccessToTwitterSignal
{
    // 定义一个错误，如果用户拒绝访问则发送
    NSError *accessError = [NSError errorWithDomain:RWTwitterInstantDomain code:RWTwitterInstantErrorAccessDenied userInfo:nil];
    
    // 创建并返回信号
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 请求访问twitter
        @strongify(self)
        [self.accountStore requestAccessToAccountsWithType:self.twitterAccountType
                                                   options:nil
                                                completion:^(BOOL granted, NSError *error) {
                                                    // 处理响应
                                                    if (!granted)
                                                    {
                                                        [subscriber sendError:accessError];
                                                    }
                                                    else
                                                    {
                                                        [subscriber sendNext:nil];
                                                        [subscriber sendCompleted];
                                                    }
                                                }];
        return nil;
    }];
}

/**
 *  Social Framework是访问Twitter搜索API的一个选择。但是Social Framework不是响应式的。接下来是封装所需要的API方法到信号中。现在，我们需要挂起这个过程。
 */
- (SLRequest *)requestforTwitterSearchWithText:(NSString *)text
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
    NSDictionary *params = @{@"q": text};
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    return request;
}

/**
 *  接下来创建一个基于请求的信号。在同一文件中，添加以下代码：
 */
- (RACSignal *)signalForSearchWithText:(NSString *)text {
    // 定义错误
    NSError *noAccountError = [NSError errorWithDomain:RWTwitterInstantDomain code:RWTwitterInstantErrorNoTwitterAccounts userInfo:nil];
    
    NSError *invalidResponseError = [NSError errorWithDomain:RWTwitterInstantDomain code:RWTwitterInstantErrorInvalidResponse userInfo:nil];
    
    // 创建信号block
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        // 创建请求
        SLRequest *request = [self requestforTwitterSearchWithText:text];
        
        // 提供Twitter账户
        NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:self.twitterAccountType];
        if (twitterAccounts.count == 0) {
            [subscriber sendError:noAccountError];
        } else {
            [request setAccount:[twitterAccounts lastObject]];
            
            // 执行请求
            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (urlResponse.statusCode == 200) {
                    // 成功，解析响应
                    NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    [subscriber sendNext:timelineData];
                    [subscriber sendCompleted];
                } else {
                    // 失败，发送一个错误
                    [subscriber sendError:invalidResponseError];
                }
            }];
        }
        
        return nil;
    }];
}

@end

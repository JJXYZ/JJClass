//
//  ViewController.m
//  JJ_Class_19_代码规范
//
//  Created by Jay on 2016/9/19.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

//VC
#import "ViewController.h"
//Helper
#import "ENUMMacro.h"

/**
 导入
 
 如果有一个以上的 import 语句，就对这些语句进行分组。每个分组的注释是可选的。 注：对于模块使用 @import 语法。
 
 //System
 //VC
 //VM
 //View
 //Entity
 //Helper
 
 */



/** 空格 */
@interface ViewController () <UITableViewDelegate, UITableViewDataSource> {
    UIImageView *_imageView;
    UIImageView *_screenImageView;
}

/**
 属性定义时，property关键字与左括号，右括号与属性类型，括号中逗号之后，属性类型与 *之间都应该添加空格；
 小括号中各个部分的顺序约定如下:（nonatomic，atomic）、（strong，weak，assign）放前两位，其余不限制。
 */

/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;

/** dataArr */
@property (nonatomic, strong, readwrite) NSArray *dataArr;

/** isShow */
@property (nonatomic, assign, getter=isShow) BOOL show;

/** tableView */
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

//@synthesize 和 @dynamic 在实现中每个都应该占一行
@synthesize imageView = _imageView;
@synthesize screenImageView = _screenImageView;

@dynamic title;


/**
 #pragma mark - Initialize Methods
 #pragma mark - Life Cycle
 #pragma mark - Super Methods
 #pragma mark - Private Methods
 #pragma mark - Public Methods
 #pragma mark - Event
 #pragma mark - <Delegate>
 #pragma mark - Property
 */


/**
 此分段放初始化方法，包括+方法和-方法，以及自己增加的创建实例的方法。dealloc也放在此分段
 
 dealloc 方法应该放在实现文件的最上面，并且刚在 @synthesize 和 @dynamic 语句的后面。在任何类中，init 都应该直接放在 dealloc 方法的下面。
 */
#pragma mark - Initialize Methods

- (void)dealloc {
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)createViewController {
    return [[self alloc] init];
}

/**
 在UIViewController的子类实现文件中，该分段包含，loadView、viewDidLoad、viewWillAppear、viewDidAppear、 viewWillDisappear、viewDidDisappear、viewWillLayoutSubviews等方法，注意顺序
 */
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutVCUI];
}

- (void)loadView {
    [super loadView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}


/** 重写父类的方法 */
#pragma mark - Super Methods

- (void)requestHandlerWishIsRefresh:(BOOL)isRefresh {
    //do Something
}

/**
 是为实现本类业务而添加的方法，不需要暴露接又给其他类，只提供给本类的方法调用。
 根据具体情况决定是否需要添加该分段。
 */
#pragma mark - Private Methods

- (void)layoutVCUI {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.tableView];
}

/** 单目运算符(!、++、--)无需添加空 */
- (void)oneLineOperator {
    NSUInteger p1;
    NSUInteger p2;
    NSUInteger p3;
    
    p1 = !p2;
    p2 = p3++;
    
    for (NSUInteger i = 0; i < 10; i++) {
        
    }
}

/**
 所有的双目运算符，包括:加(+)、减(-)、乘(*)、除(/)、取余(%)、赋值 (=、+=、-=等)、比较运算符(>、<、==、!=等)、逻辑运算符(&&、||)、位运算符 (|、&、<<、>>)等的两侧都应该添加空格。
 */
- (void)binocularOperator {
    NSUInteger p1;
    NSUInteger p2;
    NSUInteger p3;
    
    NSUInteger result = (p1 + p2) % 3 - p3 * 5;
    BOOL isRight = (p1 >= p2) && (p3 < 10);
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSLog(@"%lu %d", (unsigned long)result, isRight);
}

/** ? 和 : 的两侧都应该添加空格 */
- (void)threeLineOperator {
    NSUInteger p1;
    NSUInteger p2;
    NSUInteger p3;
    
    BOOL isRight = p1 > 40 ? p2 : p3;
    NSLog(@"%d", isRight);
}

/**
 所有方法名中“+”或“-”与方法返回类型之间应添加一个空格，方法中参数类型和“*”之间应该添加一个空格。多个方法的实现之间以及分段应该空一行。
 
 方法定义时，左大括号可以和方法名在同一行，也可以单独占用一行，和方法在同一行中时，左大括与方法的最后一个参数之间应该空一格。
 */
- (void)showWithObject:(NSObject *)object {
    //方法连续调用时，在中括号后添加空格。
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
}

- (void)hideWithObject:(NSObject *)object
{
    
}

/** if语句 */
- (void)ifFuntion {
    NSUInteger type;
    
    if (type == 10) {
        //do Something
    } else {
        //do Something
    }
    
    if (type == 10) {
        //do Something
    }
    else {
        //do Something
    }
    
    if (type == 10)
    {
        //do Something
    }
    else
    {
        //do Something
    }
}

/** switch语句 */
- (void)switchFuntion {
    XNOTableCellTypeName type;
    switch (type) {
        case XNOTableCellTypeNameNone: {
            break;
        }
        case XNOTableCellTypeNameAssets: {
            break;
        }
        case XNOTableCellTypeNameEarningsAmount: {
            break;
        }
        default: {
            break;
        }
    }
}

/** switch语句 */
- (void)errorFuntion {
    NSError *error;
    if (![self trySomethingWithError:&error]) {
        //do Something
    }
}

- (BOOL)trySomethingWithError:(NSError **)error {
    return YES;
}

/**
 变量限定符
 
 当涉及到在 ARC 中被引入变量限定符时， 限定符 (__strong, __weak, __unsafe_unretained, __autoreleasing) 应该位于星号和变量名之间，如：NSString * __weak text。
 */
- (void)variableQualifier {
    NSString * __weak text;
    
    NSLog(@"%@", text);
}

/**
 点语法
 应该始终使用点语法来访问或者修改属性，访问其他实例时首选括号。
 */
- (void)pointSyntax {
    self.view.backgroundColor = [UIColor whiteColor];
    id delegate = [UIApplication sharedApplication].delegate;
    
    NSLog(@"%@", delegate);
}

/**
 字面量
 每当创建 NSString， NSDictionary， NSArray，和 NSNumber 类的不可变实例时，都应该使用字面量。要注意 nil 值不能传给 NSArray 和 NSDictionary 字面量，这样做会导致崩溃。
 */
- (void)literally {
    NSArray *nameArr = @[@"Jack", @"Rose", @"Alex"];
    NSDictionary *productDic = @{@"iPhone" : @"Jack", @"android" : @"Rose"};
    NSNumber *shouldUse = @YES;
    NSNumber *codeNumber = @10086;
    
    NSLog(@"%@%@%@%@", nameArr, productDic, shouldUse, codeNumber);
}

/**
 CGRect函数
 
 当访问一个 CGRect 的 x， y， width， height 时，应该使用CGGeometry 函数代替直接访问结构体成员。
 */
- (void)cgRectFuntion {
    CGRect frame = self.view.frame;
    CGFloat x = CGRectGetMinX(frame);
    CGFloat y = CGRectGetMinY(frame);
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    NSLog(@"%f%f%f%f", x, y, width, height);
}


/**
 方法的声明、定义和调用(建议)
 正常情况下，所有参数应在同一行中，当参数过长时，每个参数占用一行，以冒号对齐
 */
- (UIBarButtonItem *)defaultBackBarItemWithPressedSelector:(SEL)pressedSelector
                                                     title:(nullable NSString *)title
                                               normalImage:(UIImage *)normalImage
                                          highlightedImage:(UIImage *)highlightedImage
                                          normalTitleColor:(UIColor *)normalTitleColor
                                          highlightedColor:(UIColor *)highlightedColor {
    return nil;
}

- (UIBarButtonItem *)defaultBackBarItem
{
    return [self defaultBackBarItemWithPressedSelector:@selector(clickBackButton:)
                                                 title:nil
                                           normalImage:[UIImage imageNamed:@"default_back_normal"]
                                      highlightedImage:[UIImage imageNamed:@"default_back_highlighted"]
                                      normalTitleColor:nil
                                      highlightedColor:nil];
}


/**
 block
 */
- (void)blockFunction {
    [UIView animateWithDuration:1.0 animations:^{
        //do Something
    } completion:^(BOOL finished) {
        //do Something
    }];
}

/**
 为需要暴露给其他类，供其他类(子类)调用的方法，
 根据具体情况决定是否添加该分段。
 */
#pragma mark - Public Methods

- (void)publicFunction {
    
}

/**
 方法名（包括参数方法名）的首字母小写，且以首字母大写的形式分割单词，方法名和参数加起来应该尽可能的像一句话，能够清晰的表达出这个方法所要完成的功能.
 */
- (void)loginResult:(BOOL)isSuccess jsonObject:(id)jsonObject errorMsgDetail:(NSString *)errorMsg errorCode:(NSString *)errorCode {
    
}



/**
 为button的点击事件，geture的响应方法，KVO的回调，Notification的回调方法添加一个 events分段，在该分段的方法中，调用对应业务的方法，对应业务的方法放在对应业务的分段。
 */
#pragma mark - Event

/** 点击事件click */
- (void)clickBackButton:(id)sender {
    
}

/** 通知n */
- (void)nLoginSuccess:(NSNotification *)notification {
    /** return(空格); */
    return ;
}

/** 手势geture */
- (void)getureEvent:(id)sender {
    
}

/** UISwitch */
- (void)switchEvent:(id)sender {
    
}

/** UISlider */
- (void)sliderEvent:(id)sender {
    
}

/**
 为每一个代理添加一个分段，并且分段的名称应该是代理名称，代理名称务必正确拼写，
 这样可以通过command+单击来查看代理的定义
 */
#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


/**
 由每个类都会有属性，需要为属性添加一个分段，该分段包括属性的get和set方法，属性方法 的初始化应尽量放到get方法中完成，而不应该全部放到viewDidLoad或者UIView的init方法中，这样会增加viewDidLoad和init方法的复杂以及影响可读性。
 */
#pragma mark - Property

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 44;
    }
    return _tableView;
}

- (NSArray *)dataArr {
    if (_dataArr) {
        return _dataArr;
    }
    _dataArr = [[NSArray alloc] init];
    return _dataArr;
}

@end

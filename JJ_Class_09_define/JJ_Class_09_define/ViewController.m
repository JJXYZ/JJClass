//
//  ViewController.m
//  JJ_Class_09_define
//
//  Created by Jay on 16/9/1.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"

#define PI 3.14
#define log(x) printf("this is test: x = %d", x)
#define log(x) printf("this is test: "#x" = %d", x)
#define power(x) x*x
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define print(...) printf(__VA_ARGS__)
#define RGB(r, g, b)  {\
    RGBA(r, g, b, 1.0f);\
}
#define weakify( x ) autoreleasepool{} __weak typeof(x) weak##x = x;
#define weakify(...) \ autoreleasepool {} \ metamacro_foreach_cxt(rac_weakify_,, __weak, __VA_ARGS__)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

/**
 *  程序第一步是在预编译之前会有一些操作, 例如删除反斜线和换行符的组合, 将每个注释用一个空格替代...
 
 然后在进入预编译的时候, 会寻找可能存在的预处理指定(由#开头), 例如C中常用的#include, 或者oc中的#import, #define...很多(条件编译语句...)
 
 处理#define的时候,然后预处理器会从#开始, 一直到执行到第一个换行符(写代码的时候换行的作用), 自然, #define只会允许定义一行的宏, 不过正因为上面提到的预处理之前会删除反斜线和换行符的组合, 所以可以利用反斜线定义多行宏, 在删除反斜线和换行符的组合后, 逻辑上就成了一行的宏了
 
 宏作用在预编译时期, 其真正的效果就是代码替换, 而且是直接替换(内联函数!!!), 这个和函数有着很大的区别, 并且正因为是直接替换, 在使用的时候就会有一些的注意点了, 这个在后面会给出例子
 
 宏可以被称为 类对象宏, 类函数宏(开篇给的几个宏中都已经囊括了这两类)
 
 定义宏的语法很简单, 一个宏定义由三部分组成 , 三分部之间用空格分开, #define, 宏的名字, 主体 例如第一个宏#define PI(宏的名字) 3.14(主体), 这里有个注意点就是, 宏的命名和普通的变量命名规则相同
 
 宏在预处理阶段只进行文本的替换(相当于把代码拷贝粘贴), 不会进行具体的计算(发生在编译时期)
 
 
 
 对于宏的基本的东西就介绍到这里了, 还有一些相关的东西就在下面解释一下上面定义的几个宏的过程中提到
 
 #define PI 3.14 这是宏的最简单的定义了, 可能也是大家应用最广的, 就是使用宏来定义一些常量(消除魔法数字)或字符串...,  这一类可以被称为类对象宏, 方便代码阅读和修改, 使用的时候直接使用定义的宏的名字, PI, 那么预处理器就会将代码中的PI替换为3.14
 
 float computeAreaWithRadius(float r) {
 return PI * r * r;
 }
 
 #define log(x) printf("this is test: x = %d", x) 这是宏的第二类定义, 即类函数宏, 这一类的宏和函数类似的写法, ( )中可以写变量, 用作函数的参数, 不过, 这个和函数的区别是, 宏的参数不指定类型, 具体的参数类型在调用宏的时候由传入的参数决定(有点其他语言里的泛型的意思), 这个可以算是和函数相比的优点, 下面测试一些这个宏的使用, 结果你猜对了么?
 
 #define log(x) printf("this is test: x = %d", x)
 int main(int argc, const char * argv[]) {
 int y = 12;
 log(y); // 输出为  this is test: x = 12
 }
 
 #define log(x) printf("this is test: "#x" = %d", x), 这个定义中和上面的区别是使用了一个#运算符, #运算符被用于利用宏参数创建字符串, 区分一下和上面的结果
 
 #define log(x) printf("this is test: "#x" = %d", x)
 int main(int argc, const char * argv[]) {
 int y = 12;
 log(y);
 // 输出为  this is test: y = 12 (而不是 x = 12, 或者 12 = 12)
 // 因为使用#和参数结合可以被替换为宏参数对应的字符串, "#x"表示字符串x, 这里输入的参数为y, 则替换为y(不是12)
 log(2+4)// 输出为 this is test: 2+4 = 6
 }
 
 #define power(x) x*x 这个和上面一样是一个类函数宏, 这里我原本的意愿是计算 x*x即x的平方的值, 不过这样的定义宏在有些情况下是会出问题的, 这个例子就是告诉大家定义类函数宏的时候就真的要小心, 不然客人结果并不是我们预期的
 
 #define power(x) x*x
 int x = 2;
 int pow1 = power(x); // pow1 = 2*2 = 4
 int pow2 = power(x+1); //  pow2 = 3 * 3 = 9  ??
 // 显然对于pow1 = 4是没有问题的
 // 不过对于pow2 = 9 这个结果是有问题的, 定义的宏并没有达到我们预想的效果 结果为 3*3
 // 因为: 上面提到过宏是直接的代码替换, 这里宏展开后就成为了 x+1*x+1 = 2+1*2+1 = 5
 // 这里因为运算优先级的原因导致结果的不一样, 所以pow应该(加上括号)定义为
 #define power(x) (x)*(x)
 
 #define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a] 这里是个简单的多参数的类函数宏的定义, 这个宏在使用OC开发的时候 大家可能都会喜欢使用
 
 #define RGB(r, g, b)  {\
 RGBA(r, g, b, 1.0f);\
 } 这个宏是一个"多行宏"定义的示例, 即在除了最后一行的最后加上反斜线(因为反斜线和换行符的组合在预编译之前会被系统删除), 同时这个宏也说明了, 宏的定义是可以嵌套的(有些编译器可能不支持, xcode中是支持的...)
 
 #define print(...) printf(__VA_ARGS__) 这个宏使用了两个新的东西...和__VA_ARGS__, 这两个是用来定义可变参数宏的, 可以看到是很简单的, 唯一一个注意点就是, ...要放在参数的最后, 如果你使用C定义可变参数的函数就会发现过程就很复杂了
 
 #define print(...) printf(__VA_ARGS__)
 int main(int argc, const char * argv[]) {
 print("测试可变参数 ---- %d", 12); // 输出结果为: 测试可变参数 ---- 12
 }
 
 #define weakify( x ) autoreleasepool{} __weak typeof(x) weak##x = x; 最后一个宏介绍另外一个运算符 ## 这个是宏定义中的连接运算符, 例如上面的weak##x 就是将weak和参数x连接在一起, 同时这一个宏在iOS开发中是很有用的, 使用block的时候为了消除循环引用 通常使用weakSelf, 那么就可以定义这样一个宏, 而不用每次都输入上面一段重复的代码 __weak typeof(self) weakself = self, 那么上面定义的宏和这段代码一样会生成一个弱引用的新变量, 不过上面定义的时候使用了autoreleasepool{}, 这一个自动释放池本质上并没有什么用, 只不过对调用weakify会有影响, 需要使用@weakify(x), ??看上去逼格更高, 不过在RAC中weakify是另外的方式定义的, (开篇给出的第九个宏定义)这个就可以自己下去研究一下了。
 
 #define weakify( x ) autoreleasepool{} __weak typeof(x) weak##x = x;
 加上 autoreleasepool{}使用宏的时候就应该加上@
 像这样:
 - (void)delay {
 @weakify(self)
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 [weakself test];
 });
 }
 当然如果你没有加autoreleasepool{}, 使用宏就不用加上@了
 #define weakify( x ) __weak typeof(x) weak##x = x;
 像这样:
 - (void)delay {
 weakify(self)
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 [weakself test];
 });
 }
 
 这里关于宏的介绍就先这样了, 使用宏很多时候可以让我们的代码更容易阅读和修改, 同时也可以少写很多的重复代码, 希望你在使用C系语言开发的时候能够好好利用这个方便的东西, 如果你使用OC开发iOS那么宏对你而言也会是一大福利, 如果使用swift开发iOS, 那么... 目前swift是不支持宏定义的, 不过可以使用全局的常量和全局函数来替换一部分宏的功能。
 */

@end

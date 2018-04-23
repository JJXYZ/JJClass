//
//  JJiOSInterview10.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/23.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "JJiOSInterview10.h"


/**
 1、Size Classes 具体使用
 对屏幕进行分类
 
 2、UIView和 CALayer是什么关系?
 UIView 显示在屏幕上归功于 CALayer，通过调用 drawRect 方法来渲染自身的内容，调节 CALayer 属性可以调整 UIView 的外观，UIView 继承自 UIResponder，比起CALayer 可以响应用户事件，Xcode6 之后可以方便的通过视图调试功能查看图层之间的关系。
 UIView 是 iOS 系统中界面元素的基础，所有的界面元素都继承自它。它内部是由Core Animation 来实现的，它真正的绘图部分，是由一个叫 CALayer(Core Animation Layer)的类来管理。UIView 本身，更像是一个 CALayer 的管理器，访问它的跟绘图和坐标有关的属性，如 frame，bounds 等，实际上内部都是访问它所在 CALayer 的相关属性。
 UIView 有个 layer 属性，可以返回它的主 CALayer 实例，UIView 有一个layerClass方法，返回主 layer所使用的类，UIView 的子类，可以通过重载这个方法，来让 UIView 使用不同的 CALayer 来显示，如：
 
 - (class) layerClass {
 // 使某个 UIView的子类使用 GL来进行绘制
 return ([CAEAGLLayer class]);
 }
 UIView 的 CALayer 类似 UIView 的子 View 树形结构，也可以向它的 layer 上添加子layer，来完成某些特殊的显示。例如下面的代码会在目标 View 上敷上一层黑色的透明薄膜。
 
 grayCover = [[CALayer alloc]init];
 grayCover.backgroudColor    =   [[UIColor
 blackColor]colorWithAlphaComponent:0.2].CGColor;
 [self.layer addSubLayer:grayCover];
 补充部分：这部分有深度了，大致了解一下吧，UIView 的 layer 树形在系统内部被系统维护着三份 copy
 1.逻辑树，就是代码里可以操纵的，例如更改 layer 的属性等等就在这一份
 2.动画树，这是一个中间层，系统正是在这一层上更改属性，进行各种渲染操作。
 3.显示树，这棵树的内容是当前正被显示在屏幕上的内容。这三棵树的逻辑结构都是一样的，区别只有各自的属性
 
 3、loadView的作用？
 loadView 用来自定义 view，只要实现了这个方法，其他通过 xib 或 storyboard 创建的 view 都不会被加载
 看懂控制器view创建的这个图就行
 
 
 4、IBOutlet连出来的视图属性为什么可以被设置成 weak?
 因为父控件的 subViews 数组已经对它有一个强引用
 
 5、IB中 User Defined Runtime Attributes如何使用？
 User Defined Runtime Attributes 是一个不被看重但功能非常强大的的特性，它能够通过 KVC 的方式配置一些你在 interface builder 中不能配置的属性。当你希望在 IB 中作尽可能多得事情，这个特性能够帮助你编写更加轻量级的viewcontroller
 
 6、沙盒目录结构是怎样的？各自用于那些场景？
 Application：存放程序源文件，上架前经过数字签名，上架后不可修改
 Documents：常用目录，iCloud 备份目录，存放数据
 Library
 1.Caches：存放体积大又不需要备份的数据
 2.Preference：设置目录，iCloud 会备份设置信息
 tmp：存放临时文件，不会被备份，而且这个文件下的数据有可能随时被清除的可能
 7、pushViewController和presentViewController有什么区别
 两者都是在多个试图控制器间跳转的函数
 presentViewController 提供的是一个模态视图控制器(modal)
 pushViewController 提供一个栈控制器数组，push/pop
 
 8、请简述 UITableView的复用机制
 每次创建 cell 的时候通过 dequeueReusableCellWithIdentifier:方法创建 cell，它先到缓存池中找指定标识的 cell，如果没有就直接返回 nil,如果没有找到指定标识的 cell，那么会通过initWithStyle:reuseIdentifier:创建一个
 cell，当 cell 离开界面就会被放到缓存池中，以供下次复用
 
 9、如何高性能的给 UIImageView 加个圆角?
 不好的解决方案
 使用下面的方式会强制 Core Animation提前渲染屏幕的离屏绘制, 而离屏绘制就会给性能带来负面影响，会有卡顿的现象出现
 
 self.view.layer.cornerRadius = 5;
 self.view.layer.masksToBounds = YES;
 正确的解决方案：使用绘图技术
 
 - (UIImage *)circleImage
 {
 // NO代表透明
 UIGraphicsBeginImageContextWithOptions(self.size, NO,
 0.0);
 
 // 获得上下文
 CGContextRef ctx = UIGraphicsGetCurrentContext();
 
 // 添加一个圆
 CGRect rect = CGRectMake(0, 0, self.size.width,
 self.size.height);
 CGContextAddEllipseInRect(ctx, rect);
 
 // 裁剪
 CGContextClip(ctx);
 
 // 将图片画上去
 [self drawInRect:rect];
 
 UIImage *image  =
 UIGraphicsGetImageFromCurrentImageContext();
 
 // 关闭上下文
 UIGraphicsEndImageContext();
 
 return image;
 }
 还有一种方案：使用了贝塞尔曲线"切割"个这个图片, 给 UIImageView 添加了的圆角，其实也是通过绘图技术来实现的
 
 UIImageView *imageView  =   [[UIImageView   alloc]
 initWithFrame:CGRectMake(0, 0, 100, 100)];
 imageView.center = CGPointMake(200, 300);
 UIImage *anotherImage = [UIImage imageNamed:@"image"];
 UIGraphicsBeginImageContextWithOptions(imageView.bounds.
 size, NO, 1.0);
 [[UIBezierPath
 bezierPathWithRoundedRect:imageView.bounds
 cornerRadius:50] addClip];
 [anotherImage drawInRect:imageView.bounds];
 imageView.image = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 [self.view addSubview:imageView];
 10、使用 drawRect有什么影响？
 drawRect 方法依赖 Core Graphics 框架来进行自定义的绘制
 缺点：它处理 touch 事件时每次按钮被点击后，都会用 setNeddsDisplay 进行强制重绘；而且不止一次，每次单点事件触发两次执行。这样的话从性能的角度来说，对 CPU 和内存来说都是欠佳的。特别是如果在我们的界面上有多个这样的UIButton 实例，那就会很糟糕了。这个方法的调用机制也是非常特别. 当你调用 setNeedsDisplay 方法时, UIKit 将会把当前图层标记为 dirty,但还是会显示原来的内容,直到下一次的视图渲染周期,才会将标记为 dirty 的图层重新建立 Core Graphics 上下文,然后将内存中的数据恢复出来, 再使用 CGContextRef 进行绘制
 
 11、描述下 SDWebImage里面给 UIImageView加载图片的逻辑
 1.入口setImageWithURL:placeholderImage:options: 会先把placeholderImage 显示，然后 SDWebImageManager 根据 URL 开始处理图片。
 2.进入 SDWebImageManager-downloadWithURL:delegate:options:userInfo: 交给 SDImageCache 从缓存查找图片是否已经下载queryDiskCacheForKey:delegate:userInfo:
 3.先从内存图片缓存查找是否有图片，如果内存中已经有图片缓存，SDImageCacheDelegate 回调 imageCache:didFindImage:forKey:userInfo: 到 SDWebImageManager。
 4.SDWebImageManagerDelegate 回调 webImageManager:didFinishWithImage: 到UIImageView+WebCache 等前端展示图片。
 5.如果内存缓存中没有，生成 NSInvocationOperation 添加到队列开始从硬盘查找图片是否已经缓存。
 6.根据 URLKey 在硬盘缓存目录下尝试读取图片文件。这一步是在 NSOperation 进行的操作，所以回主线程进行结果回调notifyDelegate:
 7.如果上一操作从硬盘读取到了图片，将图片添加到内存缓存中（如果空闲内存过小，会先清空内存缓存）。SDImageCacheDelegate 回调imageCache:didFindImage:forKey:userInfo: 进而回调展示图片。
 8.如果从硬盘缓存目录读取不到图片，说明所有缓存都不存在该图片，需要下载图片，回调 imageCache:didNotFindImageForKey:userInfo:
 9.共享或重新生成一个下载器 SDWebImageDownloader 开始下载图片。
 10.图片下载由 NSURLConnection 来做，实现相关 delegate 来判断图片下载中、下载完成和下载失败。
 11.connection:didReceiveData: 中利用 ImageIO 做了按图片下载进度加载效果。
 12.connectionDidFinishLoading: 数据下载完成后交给 SDWebImageDecoder 做图片解码处理。
 13.图片解码处理在一个 NSOperationQueue 完成，不会拖慢主线程 UI。如果有需要对下载的图片进行二次处理，最好也在这里完成，效率会好很多。
 14.在主线程notifyDelegateOnMainThreadWithInfo: 宣告解码完成，imageDecoder:didFinishDecodingImage:userInfo: 回调给 SDWebImageDownloader。
 15.imageDownloader:didFinishWithImage: 回调给 SDWebImageManager 告知图片下载完成。
 16.通知所有的 downloadDelegates 下载完成，回调给需要的地方展示图片。
 17.将图片保存到 SDImageCache 中，内存缓存和硬盘缓存同时保存。写文件到硬盘也在以单独 NSInvocationOperation 完成，避免拖慢主线程。
 18.SDImageCache 在初始化的时候会注册一些消息通知，在内存警告或退到后台的时候清理内存图片缓存，应用结束的时候清理过期图片。
 19.SDWebImage 也提供了UIButton+WebCache 和 MKAnnotationView+WebCache，方便使用。
 20.SDWebImagePrefetcher 可以预先下载图片，方便后续使用。
 12、设计个简单的图片内存缓存器
 类似上面 SDWebImage 实现原理即可
 一定要有移除策略：释放数据模型对象
 
 13、控制器的生命周期
 就是问的 view 的生命周期，下面已经按方法执行顺序进行了排序
 
 // 自定义控制器 view，这个方法只有实现了才会执行
 - (void)loadView
 {
 self.view = [[UIView alloc] init];
 self.view.backgroundColor = [UIColor orangeColor];
 }
 // view 是懒加载，只要 view 加载完毕就调用这个方法
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 
 NSLog(@"%s",__func__);
 }
 
 // view 即将显示
 - (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 
 NSLog(@"%s",__func__);
 }
 // view 即将开始布局子控件
 - (void)viewWillLayoutSubviews
 {
 [super viewWillLayoutSubviews];
 
 NSLog(@"%s",__func__);
 }
 // view 已经完成子控件的布局
 - (void)viewDidLayoutSubviews
 {
 [super viewDidLayoutSubviews];
 
 NSLog(@"%s",__func__);
 }
 // view 已经出现
 - (void)viewDidAppear:(BOOL)animated
 {
 [super viewDidAppear:animated];
 
 NSLog(@"%s",__func__);
 }
 // view 即将消失
 - (void)viewWillDisappear:(BOOL)animated
 {
 [super viewWillDisappear:animated];
 
 NSLog(@"%s",__func__);
 }
 // view 已经消失
 - (void)viewDidDisappear:(BOOL)animated
 {
 [super viewDidDisappear:animated];
 
 NSLog(@"%s",__func__);
 }
 // 收到内存警告
 - (void)didReceiveMemoryWarning
 {
 [super didReceiveMemoryWarning];
 
 NSLog(@"%s",__func__);
 }
 // 方法已过期，即将销毁 view
 - (void)viewWillUnload
 {
 }
 // 方法已过期，已经销毁 view
 - (void)viewDidUnload
 {
 }
 14、你是怎么封装一个 view的
 可以通过纯代码或者 xib 的方式来封装子控件
 建立一个跟 view 相关的模型，然后将模型数据传给 view，通过模型上的数据给 view的子控件赋值
 
 /**
 * 纯代码初始化控件时一定会走这个方法
 /
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setup];
    }
    
    return self;
}

/**
 * 通过 xib初始化控件时一定会走这个方法
 /
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    // 初始化代码
}
15、如何进行适配
通过判断版本来控制，来执行响应的代码
功能适配：保证同一个功能在哪里都能用
UI 适配：保证各自的显示风格

// iOS版本适配
#define iOS11 ([[UIDevice currentDevice].systemVersion
doubleValue]>=11.0)
16、如何渲染 UILabel的文字？
通过 NSAttributedString/NSMutableAttributedString（富文本）

17、UIScrollView 的 contentSize能否在viewDidLoad中设置？
能
因为 UIScrollView 的内容尺寸是根据其内部的内容来决定的，所以是可以在viewDidLoad 中设置的。
补充：（这仅仅是一种特殊情况）
前提，控制器 B 是控制器 A 的一个子控制器，且控制器 B 的内容只在控制器 A 的view 的部分区域中显示。假设控制器 B 的 view 中有一个 UIScrollView 这样一个子控件。如果此时在控制器 B 的 viewDidLoad 中设置 UIScrollView 的 contentSize 的话会导致不准确的问题。因为任何控制器的 view 在 viewDidLoad 的时候的尺寸都是不准确的，如果有子控件的尺寸依赖父控件的尺寸，在这个方法中设置会导致子控件的 frame 不准确，所以这时应该-(void)viewDidLayoutSubviews;方法中设置子控件的尺寸。

18、触摸事件的传递
触摸事件的传递是从父控件传递到子控件。
如果父控件不能接收触摸事件，那么子控件就不可能接收到触摸事件。
不能接受触摸事件的四种情况:
1.不接收用户交互，即：userInteractionEnabled = NO
2.隐藏，即：hidden = YES
3.透明，即：alpha <= 0.01
4.未启用，即：enabled = NO
提示：UIImageView 的 userInteractionEnabled 默认就是 NO，因此 UIImageView 以及它的子控件默认是不能接收触摸事件的。
如何找到最合适处理事件的控件：
首先，判断自己能否接收触摸事件，可以通过重写 hitTest:withEvent:方法验证。其次，判断触摸点是否在自己身上，对应方法 pointInside:withEvent:。从后往前(先遍历最后添加的子控件)遍历子控件，重复前面的两个步骤。如果没有符合条件的子控件，那么就自己处理。

19、事件响应者链
如果当前 view 是控制器的 view，那么就传递给控制器，如果控制器不存在，则将其传递给它的父控件，在视图层次结构的最顶层视图也不能处理接收到的事件或消息，则将事件或消息传递给 UIWindow 对象进行处理，如果 UIWindow 对象也不处理，则将事件或消息传递给 UIApplication 对象，如果 UIApplication 也不能处理该事件或消息，则将其丢弃。
补充：如何判断上一个响应者
如果当前这个 view 是控制器的 view，那么控制器就是上一个响应者
如果当前这个 view 不是控制器的 view ，那么 父控件就是上一个响应者


20、如何实现三角形头像
Quartz2D
使用 coreGraphics 裁剪出一个三角形

21、核心动画里包含什么？
iOS动画篇_CoreAnimation(超详细解析核心动画)

22、如何使用核心动画？
创建
设置相关属性
添加到 CALayer 上，会自动执行动画

 */
@implementation JJiOSInterview10

@end

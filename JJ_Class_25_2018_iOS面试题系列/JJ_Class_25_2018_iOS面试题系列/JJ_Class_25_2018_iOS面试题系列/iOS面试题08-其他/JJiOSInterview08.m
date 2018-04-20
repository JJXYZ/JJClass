//
//  JJiOSInterview08.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/20.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "JJiOSInterview08.h"


/**
 一、客户端安全性处理方式？
 1、网络安全
 
 在网络请求中，我们经常使用两种请求方式：GET和POST。如果是用GET发送请求，当我们采用明文的方式给服务器发送数据，数据里面还包含一些敏感数据如账号密码，这些数据都是包装在URL中，并且服务器的访问日志会记录，所以黑客一旦攻破服务器，可以轻易获得所有用户的账号密码。POST相对于GET来说，要相对安全一些，我们发给服务器的数据是包装在请求体中，不会直接暴露在url中。但是其实POST也是不安全的，在MAC电脑上可以利用Charles软件（如果在Windows下，可以使用Fiddler软件）来将自己的电脑设置成代理服务器，从而截取应用的网络请求，所以GET和POST都是不安全的。这时，为了防止账号密码泄漏，我们要对其进行加密。加密的方式有很多种，最简单的就是base64加密，但是base64 过于简单，很容易破解，不推荐使用。第二种就是md5加密，其核心思想是从给定的数据中提取特征码，不容产生重复，安全性比较高，在计算机安全领域使用的比较广泛，但是现在也有专门的网站对md5进行破解，为了使MD5加密更安全，我们会进行加盐，HMac，加时间戳等，提高安全级别和破解难度。第三种就是对称加密和非对称加密。非对称加密:事先生成一对用于加密的公私钥，客户端在登录时，使用公钥将用户的密码加密后，将密文传输到服务器。服务器使用私钥将密码解密。这样的做法，保证黑客即使截获了加密后的密文，由于没有私钥，也无法还原出原始的密码。
 
 2、协议问题
 
 iOS9.0 之前，做网络请求时时用http协议，但是http协议是不安全协议，很容易被攻破，在成功破解了通信协议后，黑客可以模拟客户端登录，进而伪造一些用户行为，可能对用户数据造成危害。像我们平常听到的游戏代练，刷分，其实是游戏的通信协议被破解，黑客制作出了代练的机器人程序。在iOS9.0后，苹果推荐采用https协议进行网络数据传输。当然，如果自己手上有更好更安全的协议，可以用自己的。
 
 3、本地文件安全
 
 iOS应用的数据在本地通常保存在本地文件或本地数据库中。如果对本地的数据不进行加密处理，很可能被黑客篡改，所以我们要对重要的数据进行加密，根据重要程度选择安全性可靠的方式。
 
 4、源代码安全
 
 应用程序上架需要编译成二进制文件，这些二进制文件也是存在安全隐患。黑客可以通知反编译工具，对这个文件进行反编译。对于Objective-C代码，它常常可以反汇编到可以方便阅读的程度，这对于程序的安全性，也是一个很大的危害。因为通过阅读源码，黑客可以更加方便地分析出应用的通信协议和数据加密方式。一般我们应对的方式给我们的代码加一些东西，混淆源代码的内容，比如定义一些乱其八糟的宏，比如打乱代码的顺序等。这样，就算文件被反编译成功，也需要花大量的时间去破解。
 
 二、sip是什么？
 SIP（SessionInitiationProtocol），会话发起协议
 SIP是建立VOIP连接的 IETF 标准，IETF是全球互联网最具权威的技术标准化组织
 所谓VOIP，就是网络电话，直接用互联网打电话，不用耗手机话费
 
 三、有些图片加载的比较慢怎么处理?你是怎么优化程序的性能的?
 1.图片下载放在异步线程
 2.图片下载过程中使用占位图片
 3.如果图片较大，可以考虑多线程断点下载
 
 四、你实现过一个框架或者库以供别人使用么？如果有，请谈一谈构建框架或者库时候的经验；如果没有，请设想和设计框架的 public的 API，并指出大概需要如何做、需要注意一些什么方面，来使别人容易地使用你的框架。
 · 提供给外界的接口功能是否实用、够用
 · 别人使用我的框架时，能不能根据类名、方法名就猜出接口的具体作
 用
 · 别人调用接口时，提供的参数是否够用、调用起来是否简单
 · 别人使用我的框架时，要不要再导入依赖其他的框架
 
 五、App需要加载超大量的数据，给服务器发送请求，但是服务器卡住了如何解决？
 1.设置请求超时
 2.给用户提示请求超时
 3.根据用户操作再次请求数据
 
 六、地图导航不能用了怎么办
 提示用户打开导航定位功能
 
 七、SDWebImage具体如何实现
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
 SDWebImage原理图
 SDWebImage原理图
 八、AFN 与 ASI 有什么区别
 1.AFN基于NSURL，ASI基于底层的CFNetwork框架，因此ASI的性能优于AFN
 2.AFN采取block的方式处理请求，ASI最初采取delegate的方式处理请求，后面也增加了block的方式
 3.AFN只封装了一些常用功能，满足基本需求，直接忽略了很多扩展功能，比如没有封装同步请求；ASI提供的功能较多，预留了各种接口和工具供开发者自行扩展
 4.AFN直接解析服务器返回的JSON、XML等数据，而ASI比较原始，返回的是NSData二进制数据
 
 九、你在实际开发中，有哪些手机架构与性能调试经验
 1.刚接手公司的旧项目时，模块特别多，而且几乎所有的代码都写在控制器里面，比如UI控件代码、网络请求代码、数据存储代码
 2.接下来采取MVC模式进行封装、重构
 · 自定义UI控件封装内部的业务逻辑
 · 封装网络请求工具类
 · 封装数据存储工具类
 
 十、runloop定时源和输入源
 1.你创建的程序不需要显示的创建runloop；每个线程，包括程序的主线程（main thread）都有与之相应的runloop对象,主线程会自行创建并运行runloop
 2.Run loop处理的输入事件有两种不同的来源：输入源（input
 source）和定时源（timer source）
 3.输入源传递异步消息，通常来自于其他线程或者程序。定时源则传递同步消息，在特定时间或者一定的时间间隔发生
 
 十一、你们项目中都用了哪些框架, 及何种开发工具,具体到是哪个版本,这个版本的特性有哪些???(比如 xcode的版本)
 依个人项目而定
 
 十二、多线程安全的几种解决方式以及多线程安全怎么控制？
 互斥锁：@synchronized(self)，原子锁：只对写进行安全控制
 
 十三、即时通讯中的大数据处理
 用put上传到文件服务器，然后发带url的自定义格式的给对方，
 对方接收到之后下载
 
 十四、json解析的具体实现
 解答：JSON的解析就是反序列化：
 
 // 1.URL
 NSURL *URL = [NSURL URLWithString:@"[http://localhost/demo.json](http://localhost/demo.json)"];
 // 2.session
 NSURLSession *session = [NSURLSession sharedSession];
 // 3.发起任务(dataTask)
 NSURLSessionDataTask *dataTask = [session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
 // 5.错误处理
 if (error == nil && data != nil) {
 // 提示 : 服务器返回给客户端的都是二进制数据,客户端无法直接使用;
 // 反序列化 / 数据解析 : 把服务器返回给客户端的二进制数据转换成客户端可以直接使用的OC对象;
 // 6.json反序列化
 id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
 NSLog(@"%@ -- %@",[result class],result);
 } else {
 NSLog(@"%@",error);
 }
 }];
 // 4.启动任务
 [dataTask resume];
 }
 1.SBJson
 2.JSONKit
 3.NSJSONSerialization
 
 十五、如果在网络数据处理过程中,发现一处比较卡,一般怎么解决
 1.检查网络请求操作是否被放在主线程了
 2.看看异步请求的数量是否太多了（子线程数量）
 3.数据量是否太大？如果太大，先清除一些不必要的对象（看不见的数据、图片）
 4.手机CPU使用率和内存问题
 
 十六、怎么介绍一个项目
 1.项目的价值（可以加些“老板”关键字）
 2.项目的模块
 3.我做的是哪个模块
 
 十七、怎么解决 sqlite锁定的问题
 1.设置数据库锁定的处理函数
 
 int sqlite3_busy_handler(sqlite3*, int(*)(void*,int),void*);
 1.设定锁定时的等待时间
 
 int sqlite3_busy_timeout(sqlite3*, 60); ：
 十八、#import跟#include的区别?
 前者不会引起交叉编译的问题。因为在 Objective-C 中会存在 C/C++和 Object-C 混编的问题，如果用 include 引入头文件，会导致交叉编译。
 
 十九、请写出你对 MVC模式的理解
 MVC 模式考虑三种对象：模型对象、视图对象和控制器对象。模型对象负责应用程序的数据和定义操作数据的逻辑；视图对象知道如何显示应用程序的模型数据；控制器对象是 M 与 V 之间的协调者.
 
 二十、链表和数组的区别
 二者都属于一种数据结构。
 
 从逻辑结构来看
 数组必须事先定义固定的长度（元素个数），不能适应数据动态地增减的情况。当数据增加时，可能超出原先定义的元素个数；当数据减少时，造成内存浪费；数组可以根据下标直接存取。
 链表动态地进行存储分配，可以适应数据动态地增减的情况，且可以方便地插入、删除数据项。（数组中插入、删除数据项时，需要移动其它数据项，非常繁琐）链表必须根据 next 指针找到下一个元素。
 从内存存储来看
 (静态)数组从栈中分配空间,对于程序员方便快速,但是自由度小 2. 链表从堆中分配空间, 自由度大但是申请管理比较麻烦。
 从上面的比较可以看出，如果需要快速访问数据，很少或不插入和删除元素，就应该用数组；相反， 如果需要经常插入和删除元素就需要用链表数据结构了。
 
 */
@implementation JJiOSInterview08

@end

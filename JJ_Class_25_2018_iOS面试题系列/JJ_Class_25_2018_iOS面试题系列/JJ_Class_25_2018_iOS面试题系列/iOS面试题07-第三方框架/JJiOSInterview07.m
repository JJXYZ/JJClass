//
//  JJiOSInterview07.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/20.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "JJiOSInterview07.h"


/**
 《2018 iOS面试题系列》
 
 一、第三方API是怎么用的？
 iOS第三方库汇总
 1.第三方API在官方文档都有说明，按照官方文档的一步一步做
 2.参考官方提供的示例程序
 3.先自己创建一个工程试试，等熟悉了，在使用到项目中
 
 二、列举现在熟悉 iOS开发库和第三方开发库？
 友盟（包括第三方登录和分享），高德地图，百度地
 图,AFN,SDWebimage,FMDB, MBProgressHUD,Fabric
 Crashlytics,R.swift,JSms,UMengUShare/UI,CircleProgressView,MJRefresh, IQKeyboardManagerSwift,Moya/RxSwift,Qiniu,SDWebImage,RxDataSources,RealmSwift,Mapbox-iOS-SDK,AudioKit,AudioKit/UI等等
 
 三、SDWebImage内部实现过程
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
 四、使用过友盟、融云吗？
 使用过友盟的社会化分享，集成了 qq 空间、qq 好友、微信、朋友圈、新浪微博分享和数据统计，统计流量来源、内容使用、用户属性和行为数据。可以熟练的自定义分享的界面
 
 融云
 
 五、常使用的支付方式有哪些？介绍一下集成逻辑
 下载 SDK，申请账号、交费、加入客服群，按照 SDK 进行集成 百度钱包、微信支付、支付宝、银联
 iOS之支付
 
 六、你实现过一个框架或者库以供别人使用么？如果有，请谈一谈构建框架或者库时候的经验；如果没有，请设想和设计框架的 public的 API，并指出大概需要如何做、需要注意一些什么方面，来使别人容易地使用你的框架。
 大公司面试三年以上开发人员基本都会问的问题
 答：抽象和封装，方便使用。首先是对问题有充分的了解，比如构建一个文件解压压缩框架，从使用者的角度出发，只需关注发送给框架一个解压请求，框架完成复杂文件的解压操作，并且在适当的时候通知给是哦难过者，如解压完成、解压出错等。在框架内部去构建对象的关系，通过抽象让其更为健壮、便于更改。其次是API的说明文档。
 
 如何将自己的库上传到CocoaPods

 */
@implementation JJiOSInterview07

@end

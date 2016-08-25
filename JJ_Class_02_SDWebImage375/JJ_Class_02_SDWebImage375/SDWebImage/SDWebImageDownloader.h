/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"
#import "SDWebImageOperation.h"

typedef NS_OPTIONS(NSUInteger, SDWebImageDownloaderOptions) {
    //这个属于默认的使用模式了,前往下载,返回进度block信息,完成时调用completedBlock
    SDWebImageDownloaderLowPriority = 1 << 0,
    //渐进式下载 ,如果设置了这个选项,会在下载过程中,每次接收到一段返回数据就会调用一次完成回调,回调中的image参数为未下载完成的部分图像,可以实现将图片一点点显示出来的功能
    SDWebImageDownloaderProgressiveDownload = 1 << 1,

    /**
     * By default, request prevent the of NSURLCache. With this flag, NSURLCache
     * is used with default policies.
     */
    /**
     * 通常情况下request阻止使用NSURLCache.这个选项会默认使用NSURLCache
     */
    SDWebImageDownloaderUseNSURLCache = 1 << 2,

    /**
     * Call completion block with nil image/imageData if the image was read from NSURLCache
     * (to be combined with `SDWebImageDownloaderUseNSURLCache`).
     */
    /**
     *  如果从NSURLCache中读取图片,会在调用完成block的时候,传递空的image或者imageData
     */
    SDWebImageDownloaderIgnoreCachedResponse = 1 << 3,
    /**
     * In iOS 4+, continue the download of the image if the app goes to background. This is achieved by asking the system for
     * extra time in background to let the request finish. If the background task expires the operation will be cancelled.
     */
    /**
     * 系统为iOS 4+时候,如果应用进入后台,继续下载.这个选项是为了实现在后台申请额外的时间来完成请求.如果后台任务到期,操作也会被取消
     */
    SDWebImageDownloaderContinueInBackground = 1 << 4,

    /**
     * Handles cookies stored in NSHTTPCookieStore by setting 
     * NSMutableURLRequest.HTTPShouldHandleCookies = YES;
     */
    /**
     *  通过设置 NSMutableURLRequest.HTTPShouldHandleCookies = YES的方式来处理存储在NSHTTPCookieStore的cookies
     */
    SDWebImageDownloaderHandleCookies = 1 << 5,

    /**
     * Enable to allow untrusted SSL certificates.
     * Useful for testing purposes. Use with caution in production.
     */
    /**
     *  允许不受信任的SSL证书，在测试环境中很有用，在生产环境中要谨慎使用
     */
    SDWebImageDownloaderAllowInvalidSSLCertificates = 1 << 6,

    /**
     * Put the image in the high priority queue.
     */
    /**
     * 将图片下载放到高优先级队列中
     */
    SDWebImageDownloaderHighPriority = 1 << 7,
};

//SDWebImageDownloaderExecutionOrder 的定义
typedef NS_ENUM(NSInteger, SDWebImageDownloaderExecutionOrder) {
    /**
     * Default value. All download operations will execute in queue style (first-in-first-out).
     */
    /**
     * 默认值,所有的下载操作以队列类型(先进先出)执行
     */
    SDWebImageDownloaderFIFOExecutionOrder,

    /**
     * All download operations will execute in stack style (last-in-first-out).
     */
    /**
     * 所有的下载操作以栈类型(后进后出)执行
     */
    SDWebImageDownloaderLIFOExecutionOrder
};

/**
 *  全局常量:不管你定义在任何文件夹,外部都能访问
 */
/**
 *  局部常量:用static修饰后,不能提供外界访问(只能在赋值的.m文件使用,外界不可访问)
 */

//官方也更推荐这样定义常量 而不是用#define
extern NSString *const SDWebImageDownloadStartNotification;
extern NSString *const SDWebImageDownloadStopNotification;

/**
 *  第一个返回已经接收的图片数据的大小,未接收的图片数据的大小,-
 
 这个方法里面就有用到,因为图片的下载是需要时间的,所以这个block回调不止回调一次,会一直持续到图片完全下载或者下载失败才会停止回调
 */
typedef void(^SDWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

//第二个block回调 下载完成的图片 , 图片的数据 , 如果有error返回error ,以及下载是否完成的BOOl值
typedef void(^SDWebImageDownloaderCompletedBlock)(UIImage *image, NSData *data, NSError *error, BOOL finished);

//第三个是header过滤:设置一个过滤器,为下载图片的HTTP request选取header.最终使用的headers是经过这个block过滤时候的返回值
typedef NSDictionary *(^SDWebImageDownloaderHeadersFilterBlock)(NSURL *url, NSDictionary *headers);

/**
 * Asynchronous downloader dedicated and optimized for image loading.
 */
@interface SDWebImageDownloader : NSObject

/**
 * Decompressing images that are downloaded and cached can improve performance but can consume lot of memory.
 * Defaults to YES. Set this to NO if you are experiencing a crash due to excessive memory consumption.
 */
/**
* 解压已经下载缓存起来的图片可以提高性能,但是会消耗大量的内存
* 默认为YES显示比较高质量的图片,如果你遇到因内存消耗过多而造成崩溃的话可以设置为NO,
*/
@property (assign, nonatomic) BOOL shouldDecompressImages;

//下载队列最大的并发数,意思是队列中最多同时运行几条线程(全局搜索了一下,默认值是3)
@property (assign, nonatomic) NSInteger maxConcurrentDownloads;

/**
 * Shows the current amount of downloads that still need to be downloaded
 */
/**
 * 当前在下载队列的操作总数,只读(这是一个瞬间值,因为只要一个操作下载完成就会移除下载队列)
 */
@property (readonly, nonatomic) NSUInteger currentDownloadCount;


/**
 *  The timeout value (in seconds) for the download operation. Default: 15.0.
 */
/**
 *  下载操作的超时时间,默认是15s
 */
@property (assign, nonatomic) NSTimeInterval downloadTimeout;


/**
 * Changes download operations execution order. Default value is `SDWebImageDownloaderFIFOExecutionOrder`.
 */
/**
 *  枚举类型,代表着操作下载的顺序
 */
@property (assign, nonatomic) SDWebImageDownloaderExecutionOrder executionOrder;

/**
 *  Singleton method, returns the shared instance
 *
 *  @return global shared instance of downloader class
 */
/**
 *  SDWeImageDownloder是一个单例,这是初始化方法
 */
+ (SDWebImageDownloader *)sharedDownloader;

/**
 *  Set the default URL credential to be set for request operations.
 */
/**
 *  为request操作设置默认的URL凭据，具体实施为:在将操作添加到队列之前，将操作的credential属性值设置为urlCredential
 */
@property (strong, nonatomic) NSURLCredential *urlCredential;

/**
 * Set username
 */
@property (strong, nonatomic) NSString *username;

/**
 * Set password
 */
@property (strong, nonatomic) NSString *password;

/**
 * Set filter to pick headers for downloading image HTTP request.
 *
 * This block will be invoked for each downloading image request, returned
 * NSDictionary will be used as headers in corresponding HTTP request.
 */
/**
 * 设置一个过滤器，为下载图片的HTTP request选取header.意味着最终使用的headers是经过这个block过滤之后的返回值。
 */
@property (nonatomic, copy) SDWebImageDownloaderHeadersFilterBlock headersFilter;

/**
 * Set a value for a HTTP header to be appended to each download HTTP request.
 *
 * @param value The value for the header field. Use `nil` value to remove the header.
 * @param field The name of the header field to set.
 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 * Returns the value of the specified HTTP header field.
 *
 * @return The value associated with the header field field, or `nil` if there is no corresponding header field.
 */
- (NSString *)valueForHTTPHeaderField:(NSString *)field;

/**
 * Sets a subclass of `SDWebImageDownloaderOperation` as the default
 * `NSOperation` to be used each time SDWebImage constructs a request
 * operation to download an image.
 *
 * @param operationClass The subclass of `SDWebImageDownloaderOperation` to set 
 *        as default. Passing `nil` will revert to `SDWebImageDownloaderOperation`.
 
 设置SDWebImageDownloaderOperation`的`子类作为默认
  *`NSOperation`要每次使用SDWebImage构建的请求
  *操作下载图像。
  *
  * @参数operationClass SDWebImageDownloaderOperation`的`子类设置
  *为默认值。传递`nil`将恢复到`SDWebImageDownloaderOperation`。
 */
- (void)setOperationClass:(Class)operationClass;

/**
 * Creates a SDWebImageDownloader async downloader instance with a given URL
 *
 * The delegate will be informed when the image is finish downloaded or an error has happen.
 *
 * @see SDWebImageDownloaderDelegate
 *
 * @param url            The URL to the image to download
 * @param options        The options to be used for this download
 * @param progressBlock  A block called repeatedly while the image is downloading
 * @param completedBlock A block called once the download is completed.
 *                       If the download succeeded, the image parameter is set, in case of error,
 *                       error parameter is set with the error. The last parameter is always YES
 *                       if SDWebImageDownloaderProgressiveDownload isn't use. With the
 *                       SDWebImageDownloaderProgressiveDownload option, this block is called
 *                       repeatedly with the partial image object and the finished argument set to NO
 *                       before to be called a last time with the full image and finished argument
 *                       set to YES. In case of error, the finished argument is always YES.
 *
 * @return A cancellable SDWebImageOperation
 */
- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(SDWebImageDownloaderOptions)options
                                        progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                       completed:(SDWebImageDownloaderCompletedBlock)completedBlock;

/**
 * Sets the download queue suspension state
 设置下载队列停工状态
 */
- (void)setSuspended:(BOOL)suspended;

@end

/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageDownloader.h"
#import "SDWebImageOperation.h"

extern NSString *const SDWebImageDownloadStartNotification;
extern NSString *const SDWebImageDownloadReceiveResponseNotification;
extern NSString *const SDWebImageDownloadStopNotification;
extern NSString *const SDWebImageDownloadFinishNotification;


/**
 *  NSOperation 是一个抽象类，你可以用它来封装一个任务的相关代码和数据。因为它是个抽象类，所以你不能直接使用它，而是需要继承并实现其子类或者使用系统内置的两个子类（NSInvocationOperation 和 NSBlockOperation）来执行实际的线程任务
 
 NSOperationQueue 类管理着一组 NSOperation 对象的执行，当一个 operation 对象被加入到队列后，它会始终保留在队列中，直到它已经明确的被取消或者完成执行任务。Operations 在队列内（但尚未执行），它们是根据优先级和互相依赖进行组织的，相应的去执行。一个应用可以创建多个操作队列（operation queues）并提交操作（operations）到其中任何一个中
 */
@interface SDWebImageDownloaderOperation : NSOperation <SDWebImageOperation>

/**
 * The request used by the operation's connection.
 */
/**
 * 下载时用于网络请求的request
 */
@property (strong, nonatomic, readonly) NSURLRequest *request;

/**
 * 图片下载完成是否需要解压
 */
@property (assign, nonatomic) BOOL shouldDecompressImages;

/**
 * Whether the URL connection should consult the credential storage for authenticating the connection. `YES` by default.
 *
 * This is the value that is returned in the `NSURLConnectionDelegate` method `-connectionShouldUseCredentialStorage:`.
 */
/**
 * :URLConnection是否需要咨询凭据仓库来对连接进行授权,默认YES
 */
@property (nonatomic, assign) BOOL shouldUseCredentialStorage;

/**
 * The credential used for authentication challenges in `-connection:didReceiveAuthenticationChallenge:`.
 *
 * This will be overridden by any shared credentials that exist for the username or password of the request URL, if present.
 */
/**
 * web服务要求客户端进行挑战,用NSURLConnectionDelegate提供的方法接收挑战,最终会生成一个挑战凭证,也是NSURLCredential的实例 credential
 */
@property (nonatomic, strong) NSURLCredential *credential;

/**
 * The SDWebImageDownloaderOptions for the receiver.
 */
/**
 *
 SDWebImageDownloader.h里面定义的,一些下载相关的选项
 */
@property (assign, nonatomic, readonly) SDWebImageDownloaderOptions options;

/**
 * The expected size of data.
 */
/**
 * 预期的文件大小
 */
@property (assign, nonatomic) NSInteger expectedSize;

/**
 * The response returned by the operation's connection.
 */
/**
 * connection对象进行网络访问,接收到的response
 */
@property (strong, nonatomic) NSURLResponse *response;

/**
 *  Initializes a `SDWebImageDownloaderOperation` object
 *
 *  @see SDWebImageDownloaderOperation
 *
 *  @param request        the URL request
 *  @param options        downloader options
 *  @param progressBlock  the block executed when a new chunk of data arrives. 
 *                        @note the progress block is executed on a background queue
 *  @param completedBlock the block executed when the download is done. 
 *                        @note the completed block is executed on the main queue for success. If errors are found, there is a chance the block will be executed on a background queue
 *  @param cancelBlock    the block executed if the download (operation) is cancelled
 *
 *  @return the initialized instance
 */
/**
 *
 用默认的属性值初始化一个SDWebImageDownloaderOperation对象
 */
- (id)initWithRequest:(NSURLRequest *)request
              options:(SDWebImageDownloaderOptions)options
             progress:(SDWebImageDownloaderProgressBlock)progressBlock
            completed:(SDWebImageDownloaderCompletedBlock)completedBlock
            cancelled:(SDWebImageNoParamsBlock)cancelBlock;

@end

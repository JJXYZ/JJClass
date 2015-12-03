//
//  RWTFlickrSearchImpl.m
//  RWTFlickrSearch
//
//  Created by Jay on 15/12/1.
//  Copyright © 2015年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchImpl.h"
#import "RWTFlickrPhotoMetadata.h"
#import <ReactiveCocoa/RACEXTScope.h>

@interface RWTFlickrSearchImpl () <OFFlickrAPIRequestDelegate>

@property (strong, nonatomic) NSMutableSet *requests;
@property (strong, nonatomic) OFFlickrAPIContext *flickrContext;

@end

@implementation RWTFlickrSearchImpl

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        NSString *OFSampleAppAPIKey = @"45a4251dc1a3c9934f8ff8da7a8216ee";
        NSString *OFSampleAppAPISharedSecret = @"f7d45ce1c8b4bf8d";
        
        /**
         这段代码创建了一个Flickr的上下文，用于存储ObjectiveFlickr请求的数据。
        */
        _flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OFSampleAppAPIKey sharedSecret:OFSampleAppAPISharedSecret];
        
        _requests = [NSMutableSet new];
    }
    
    return self;
}

/**
 *  这个方法需要传入请求方法及请求参数，然后使用block参数来转换响应对象。
 */

/**
 *  不过在庆祝前，我们回到signalFromAPIMethod:arguments:transform:方法来修复之前提到的一个错误。你注意到了么？这个方法为每个请求创建一个新的OFFlickrAPIRequest实例。然后，每个请求的结果是通过代理对象来返回的，而这种情况下，其代理是它自己。结果是，在并发请求的情况下，没有办法指明哪个flickrAPIRequest:didCompleteWithResponse:调用用来响应哪个请求。不过，ObjectiveFlickr代理方法签名在第一个参数中包含了相应请求，所以这个问题很好解决。
 */
- (RACSignal *)signalFromAPIMethod:(NSString *)method arguments:(NSDictionary *)args transform:(id (^)(NSDictionary *response))block
{
    // 1. 创建请求信号
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 2. 创建一个Flick请求对象
        OFFlickrAPIRequest *flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.flickrContext];
        flickrRequest.delegate = self;
        [self.requests addObject:flickrRequest];
        
        /**
         *  当前搜索Flickr的代码只处理了OFFlickrAPIRequestDelegate协议中的flickrAPIRequest:didCompleteWithResponse:方法。不过，这样网络请求由于多种原因会出错。一个好的应用程序必须处理这些错误，以给用户一个良好的用户体验。代理同时定义了flickrAPIRequest:didFailWithError:方法，这个方法在请求出错时调用。我们将用这个方法来处理错误并显示一个提示框给用户。
         
         我们之前讲过信号会发出next，completed和错误事件。其结果是，我们并不需要做太多的事情。
         */
        RACSignal *errorSignal = [self rac_signalForSelector:@selector(flickrAPIRequest:didFailWithError:) fromProtocol:@protocol(OFFlickrAPIRequestDelegate)];
        
        [errorSignal subscribeNext:^(RACTuple *tuple) {
            [subscriber sendError:tuple.second];
        }];
        /**
         *
         上面的代码从代理方法中创建了一个信号，订阅了该信号，如果发生错误则发送一个错误。传递给subscribeNext块的元组包含传递给flickrAPIRequest:didFailWithError:方法的变量。结果是，tuple.second获取源错误并使用它来为错误事件服务。这是一个很好的解决方案，你觉得呢？不是所有的API请求都有内建的错误处理。接下来我们使用它。
         */
        
        // 3. 从代理方法中创建一个信号
        RACSignal *successSignal = [self rac_signalForSelector:@selector(flickrAPIRequest:didCompleteWithResponse:) fromProtocol:@protocol(OFFlickrAPIRequestDelegate)];
        
        // 4. 处理响应
#if 0
        [[[successSignal map:^id(RACTuple *tuple) {
               return tuple.second;
           }] map:block] subscribeNext:^(id x) {
             [subscriber sendNext:x];
             [subscriber sendCompleted];
         }];
#endif
        @weakify(flickrRequest)
        [[[[successSignal filter:^BOOL(RACTuple *tuple) {
                @strongify(flickrRequest)
                return tuple.first == flickrRequest;
            }] map:^id(RACTuple *tuple) {
               return tuple.second;
           }] map:block] subscribeNext:^(id x) {
             [subscriber sendNext:x];
             [subscriber sendCompleted];
         }];
        
        // 5. 开始请求
        [flickrRequest callAPIMethodWithGET:method arguments:args];
        
        // 6. 完成后，移除请求的引用
        return [RACDisposable disposableWithBlock:^{
            [self.requests removeObject:flickrRequest];
        }];
    }];
}

#pragma mark - RWTFlickrSearch

/**
 *  接下来实现flickrImageMetadata方法。不幸的是，这里有些小问题：为了获取图片相关的评论数，我们需要调用flickr.photos.getinfo方法；为了获取收藏数，需要调用flickr.photos.getFavorites方法。这让事件变得有点复杂，因为flickrImageMetadata方法需要调用两个接口请求以获取需要的数据。不过，ReactiveCocoa已经为我们解决了这个问题。
 */
- (RACSignal *)flickrImageMetadata:(NSString *)photoId {
    
    RACSignal *favorites = [self signalFromAPIMethod:@"flickr.photos.getFavorites"
                                           arguments:@{@"photo_id": photoId}
                                           transform:^id(NSDictionary *response) {
                                               NSString *total = [response valueForKeyPath:@"photo.total"];
                                               return total;
                                           }];
    
    RACSignal *comments = [self signalFromAPIMethod:@"flickr.photos.getInfo"
                                          arguments:@{@"photo_id": photoId}
                                          transform:^id(NSDictionary *response) {
                                              NSString *total = [response valueForKeyPath:@"photo.comments._text"];
                                              return total;
                                          }];
    /**
     *  上面的代码使用signalFromAPIMethod:arguments:transform:来从底层的基于ObjectiveFLickr的接口创建信号。上面的代码创建了一个信号对，一个用于获取收藏的数量，一个用于获取评论的数量。
     */
    
    /**
     *  一旦创建了两个信号，combineLatest:reduce:方法生成一个新的信号来组合两者。
     
     这个方法等待源信号的一个next事件。reduce块使用它们的内容来调用，其结果变成联合信号的next事件。
     */
    return [RACSignal combineLatest:@[favorites, comments] reduce:^id(NSString *favs, NSString *coms){
        RWTFlickrPhotoMetadata *meta = [RWTFlickrPhotoMetadata new];
        meta.comments = [coms integerValue];
        meta.favorites = [favs integerValue];
        return  meta;
    }];
}

- (RACSignal *)flickrSearchSignal:(NSString *)searchString {
    return [self signalFromAPIMethod:@"flickr.photos.search"
                           arguments:@{@"text": searchString,
                                       @"sort": @"interestingness-desc"}
                           transform:^id(NSDictionary *response) {
                               
                               RWTFlickrSearchResults *results = [RWTFlickrSearchResults new];
                               results.searchString = searchString;
                               results.totalResults = [[response valueForKeyPath:@"photos.total"] integerValue];
                               
                               NSArray *photos = [response valueForKeyPath:@"photos.photo"];
                               results.photos = [photos linq_select:^id(NSDictionary *jsonPhoto) {
                                   RWTFlickrPhoto *photo = [RWTFlickrPhoto new];
                                   photo.title = [jsonPhoto objectForKey:@"title"];
                                   photo.identifier = [jsonPhoto objectForKey:@"id"];
                                   photo.url = [self.flickrContext photoSourceURLFromDictionary:jsonPhoto
                                                                                           size:OFFlickrSmallSize];
                                   return photo;
                               }];
                               
                               return results;
                           }];
}

#if 0
- (RACSignal *)flickrSearchSignal:(NSString *)searchString
{
    return [[[[RACSignal empty] logAll] delay:2.0] logAll];
}
#endif
@end

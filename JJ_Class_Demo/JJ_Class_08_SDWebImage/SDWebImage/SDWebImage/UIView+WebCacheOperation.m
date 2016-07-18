/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIView+WebCacheOperation.h"
#import "objc/runtime.h"

static char loadOperationKey;

@implementation UIView (WebCacheOperation)

- (NSMutableDictionary *)operationDictionary {
    /**
     *  这个loadOperationKey 的定义是:static char loadOperationKey;
     它对应的绑定在UIView的属性是operationDictionary(NSMutableDictionary类型)
     operationDictionary的value是操作,key是针对不同类型视图和不同类型的操作设定的字符串
     注意:&是一元运算符结果是右操作对象的地址(&loadOperationKey返回static char loadOperationKey的地址)
     */
    NSMutableDictionary *operations = objc_getAssociatedObject(self, &loadOperationKey);
    
    /**
     *  如果可以查到operations,就rerun,反正给视图绑定一个新的,空的operations字典
     */
    if (operations) {
        return operations;
    }
    operations = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &loadOperationKey, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return operations;
}



/**
 *  设置图像加载操作（存储在和UIView做绑定的字典里面）
 */
- (void)sd_setImageLoadOperation:(id)operation forKey:(NSString *)key {
    [self sd_cancelImageLoadOperationWithKey:key];
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    [operationDictionary setObject:operation forKey:key];
}

/**
 *  用这个key找到当前UIView上面的所有操作并取消
 */
- (void)sd_cancelImageLoadOperationWithKey:(NSString *)key {
    // Cancel in progress downloader from queue
    //取消正在下载的队列
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    //如果 operationDictionary可以取到,根据key可以得到与视图相关的操作,取消他们,并根据key值,从operationDictionary里面删除这些操作
    id operations = [operationDictionary objectForKey:key];
    if (operations) {
        if ([operations isKindOfClass:[NSArray class]]) {
            for (id <SDWebImageOperation> operation in operations) {
                if (operation) {
                    [operation cancel];
                }
            }
        } else if ([operations conformsToProtocol:@protocol(SDWebImageOperation)]){
            [(id<SDWebImageOperation>) operations cancel];
        }
        [operationDictionary removeObjectForKey:key];
    }
}

- (void)sd_removeImageLoadOperationWithKey:(NSString *)key {
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    [operationDictionary removeObjectForKey:key];
}

@end

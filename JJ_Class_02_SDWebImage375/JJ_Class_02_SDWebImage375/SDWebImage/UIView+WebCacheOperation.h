/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */


/**
 *  为了方便管理和找到视图正在进行的一些操作,WebCacheOperation将每一个视图的实例和它正在进行的操作(下载和缓存的组合操作)绑定起来,实现操作和视图一一对应关系,以便可以随时拿到视图正在进行的操作,控制其取消等,如何进行绑定我们在下面分析:
 */


#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"

@interface UIView (WebCacheOperation)

/**
 *  Set the image load operation (storage in a UIView based dictionary)
 *
 *  @param operation the operation
 *  @param key       key for storing the operation
    
    设置图像加载操作（存储在和UIView做绑定的字典里面）
 */
- (void)sd_setImageLoadOperation:(id)operation forKey:(NSString *)key;

/**
 *  Cancel all operations for the current UIView and key
 *
 *  @param key key for identifying the operations
 
    用这个key找到当前UIView上面的所有操作并取消
 */
- (void)sd_cancelImageLoadOperationWithKey:(NSString *)key;

/**
 *  Just remove the operations corresponding to the current UIView and key without cancelling them
 *
 *  @param key key for identifying the operations
 */
- (void)sd_removeImageLoadOperationWithKey:(NSString *)key;

@end

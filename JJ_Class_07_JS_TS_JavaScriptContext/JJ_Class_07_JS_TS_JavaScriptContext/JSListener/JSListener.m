//
//  JSListener.m
//  JJ_Class_Demo
//
//  Created by Jay on 16/4/25.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JSListener.h"

@implementation JSListener

#pragma mark - Lifecycle

- (void)dealloc {
    NSLog(@"JSListener dealloc");
}


#pragma mark - WebviewClickListener

- (void)setShareContent:(NSString *)shareUrl :(NSString *)title
{
    self.shareUrl = shareUrl;
    self.shareTitle = title.stringByRemovingPercentEncoding;
    
    NSLog(@"JSListener:shareUrl=%@, shareTitle=%@",self.shareUrl, self.shareTitle);
}

- (void)setShareText:(JSValue *)value {
#if 0
    self.jsValue = value; // Retain cycle
    
    NSLog(@"JSListener:value = %@", self.jsValue.toString);
#else
    _onClickHandler1 = [JSManagedValue managedValueWithValue:value];
    [_context.virtualMachine addManagedReference:_onClickHandler1 withOwner:self];
    
    NSLog(@"JSListener:value = %@", [_onClickHandler1.value toString]);
    
#endif

}

- (void)sayGoodbye {
    NSLog(@"sayGoodbye");
}



@end

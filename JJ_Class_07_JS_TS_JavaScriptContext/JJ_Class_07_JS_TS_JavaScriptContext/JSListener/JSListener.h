//
//  JSListener.h
//  JJ_Class_Demo
//
//  Created by Jay on 16/4/25.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol WebviewClickListener <JSExport>

- (void)setShareContent:(NSString *)shareUrl :(NSString *)title;

- (void)setShareText:(JSValue *)handler;

- (void)sayGoodbye;

@end


@interface JSListener : NSObject <WebviewClickListener>

@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareTitle;

@property (nonatomic, strong) JSValue *jsValue;
@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) JSManagedValue *onClickHandler1;

@end

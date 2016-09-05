//
//  NativeObject.h
//  JJ_Class_07_JS_JavaScriptCore
//
//  Created by Jay on 16/8/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol NativeObjectExport <JSExport>

- (void)log:(NSString*)string;

@end

@interface NativeObject : NSObject <NativeObjectExport>

@end

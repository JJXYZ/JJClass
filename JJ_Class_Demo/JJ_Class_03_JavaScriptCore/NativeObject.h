//
//  NativeObject.h
//  JJ_Class_Demo
//
//  Created by Jay on 16/4/22.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@import JavaScriptCore;

@protocol NativeObjectExport <JSExport>

-(void)log:(NSString *)string;

@end


@interface NativeObject : NSObject <NativeObjectExport>

@end

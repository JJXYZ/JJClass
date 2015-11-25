//
//  JJDefine_UI.h
//  JJDefineDemo
//
//  Created by Jay on 15/11/18.
//  Copyright © 2015年 JJ. All rights reserved.
//

#ifndef JJDefine_UI_h
#define JJDefine_UI_h


/** 字体大小 */
#define FONT(NAME,FONTSIZE) [UIFont fontWithName:(NAME) size:(FONTSIZE)]
#define S_FONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define S_BOLD_FONT(FONTSIZE)   [UIFont boldSystemFontOfSize:FONTSIZE]


/** 颜色(RGB) */
#define RGB(r,g,b)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1];
#define RGBA(r,g,b,a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

/** 颜色(0xFFFFFF) */
#define HEX_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HEX_RGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


/** 资源路径 */
#define PNG_PATH(NAME) [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPG_PATH(NAME) [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME,EXT) [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

/** 加载图片 */
#define PNG_IMAGE_FILE(NAME)         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPG_IMAGE_FILE(NAME)         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define IMAGE_FILE(NAME,EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]
#define IMAGE_NAMED(NAME)       [UIImage imageNamed:NAME]


#endif /* JJDefine_UI_h */

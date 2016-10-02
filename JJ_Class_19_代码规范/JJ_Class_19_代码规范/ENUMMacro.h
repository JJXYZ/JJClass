//
//  ENUMMacro.h
//  JJ_Class_19_代码规范
//
//  Created by Jay on 2016/10/2.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#ifndef ENUMMacro_h
#define ENUMMacro_h


typedef NS_ENUM(NSInteger, XNOTableCellTypeName) {
    XNOTableCellTypeNameNone = -1,
    XNOTableCellTypeNameEarningsAmount, //累计收益
    XNOTableCellTypeNameAssets, //我的资产
};

typedef NS_ENUM(NSInteger, XNOTableCellTypeTitle) {
    /** None */
    XNOTableCellTypeTitleNone = -1,
    /** 累计收益 */
    XNOTableCellTypeTitleEarningsAmount,
    /** 我的资产 */
    XNOTableCellTypeTitleAssets,
};


/**
 XNOTableCellTypeAcount

 - XNOTableCellTypeAcountNone:           累计收益
 - XNOTableCellTypeAcountEarningsAmount: 我的资产
 */
typedef NS_ENUM(NSInteger, XNOTableCellTypeAcount) {
    XNOTableCellTypeAcountNone = -1,
    XNOTableCellTypeAcountEarningsAmount,
    XNOTableCellTypeAcountAssets,
};


#endif /* ENUMMacro_h */

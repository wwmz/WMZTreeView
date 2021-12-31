//
//  WMZTreeParam.h
//  WMZTree
//
//  Created by wmz on 2019/10/17.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZTreeConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMZTreeParam : NSObject
/// 子数据
@property (nonatomic, strong) NSMutableArray <WMZTreeParam*> *children;
/// 半选中
@property (nonatomic, assign) BOOL halfSelect;
/// 全选中
@property (nonatomic, assign) BOOL isSelected;
/// 全选中
@property (nonatomic, assign) NSInteger depath;
/// 半选中
@property (nonatomic, assign) BOOL tempHalfSelect;
/// 全选中
@property (nonatomic, assign) BOOL isTempSelected;

WMZTreeParam * TreeParam(void);


/// 能否选中 默认NO
WMZTreePropStatementAndPropSetFuncStatement(assign, WMZTreeParam, BOOL,                  canSelect)

/// 是否展开 默认NO
WMZTreePropStatementAndPropSetFuncStatement(assign, WMZTreeParam, BOOL,                  isExpand)

/// name
WMZTreePropStatementAndPropSetFuncStatement(strong, WMZTreeParam, NSString*,             name)

/// 其他数据
WMZTreePropStatementAndPropSetFuncStatement(strong, WMZTreeParam, id,                    data)

/// 当前节点ID 必传
WMZTreePropStatementAndPropSetFuncStatement(strong, WMZTreeParam, NSString*,             currentId)

/// 父节点ID
WMZTreePropStatementAndPropSetFuncStatement(strong, WMZTreeParam, NSString*,             parentId)

@end

NS_ASSUME_NONNULL_END

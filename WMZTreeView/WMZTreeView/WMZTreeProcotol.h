//
//  WMZTreeProcotol.h
//  WMZTreeView
//
//  Created by wmz on 2022/10/12.
//  Copyright © 2022 wmz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WMZTreeProcotol <NSObject>
/// 能否选中 默认NO
@property (nonatomic, assign) BOOL canSelect;
/// 是否展开 默认NO
@property (nonatomic, assign) BOOL isExpand;
/// name
@property (nonatomic, copy) NSString *name;
/// 其他数据
@property (nonatomic, strong) id data;
/// 当前节点ID 必传
@property (nonatomic, copy) NSString *currentId;
/// 父节点ID
@property (nonatomic, copy, nullable) NSString *parentId;
/// 子数据
@property (nonatomic, strong) NSMutableArray <NSObject<WMZTreeProcotol>*> *children;
///custom
/// 半选中
@property (nonatomic, assign) BOOL halfSelect;
/// 全选中
@property (nonatomic, assign) BOOL isSelected;
/// 深度
@property (nonatomic, assign) NSInteger depath;
/// 半选中
@property (nonatomic, assign) BOOL tempHalfSelect;
/// 全选中
@property (nonatomic, assign) BOOL isTempSelected;

@end

NS_ASSUME_NONNULL_END

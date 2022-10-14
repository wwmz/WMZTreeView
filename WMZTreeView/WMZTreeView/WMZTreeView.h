//
//  WMZTreeView.h
//  WMZTree
//
//  Created by wmz on 2019/10/17.
//  Copyright © 2019 wmz. All rights reserved.
//
#import "WMZTreeBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMZTreeView : WMZTreeBaseView

/// 初始化
- (instancetype)initWithParam:(WMZTreeViewParam*)param;

/// 更新或者设置子节点数组
/// @param currrentID 当前节点 (传@""表示更新第一级)
/// @param data 子节点数组
/// @return BOOL 是否更新或者设置成功
- (BOOL)updateKeyChildren:(NSString*)currrentID data:(NSArray*)data;

 /// 获取当前选中的节点数组
 /// @param halfSelect 包含半选中
 /// @return NSArray 返回数组
- (NSArray*)getCheckedNodesWithHalfSelect:(BOOL)halfSelect;

 /// 为 Tree 中的一个节点追加一个子节点
 /// @param currrentID 当前节点
 /// @param param 子节点数据
 /// @return BOOL 是否追加成功
- (BOOL)append:(NSString*)currrentID node:(NSObject<WMZTreeProcotol>*)param;

/// 删除节点
/// @param currrentID 当前节点
/// @return BOOL 是否追加成功
- (BOOL)remove:(NSString*)currrentID;

/// 为 Tree 的一个节点的前面增加一个节点
/// @param currrentID 当前节点
/// @param param 子节点数据
/// @return BOOL 是否追加成功
- (BOOL)insertBefore:(NSString*)currrentID node:(NSObject<WMZTreeProcotol>*)param;

/// 为 Tree 的一个节点的后面增加一个节点
/// @param currrentID 当前节点
/// @param param 子节点数据
/// @return BOOL 是否追加成功
- (BOOL)insertAfter:(NSString*)currrentID node:(NSObject<WMZTreeProcotol>*)param;

/// 更新编辑状态
- (void)updateEditing;

/// 传进来的是JSON数组 转为树形模型
- (void)changeJSONtToTreeModel:(NSArray*)data type:(TreeDataType)type;

/// 全选
- (void)selectAll;

/// 全部取消选中
- (void)notSelectAll;

/// 获取父节点
- (NSObject<WMZTreeProcotol>*)getParentId:(NSString*)currrentID;

/// 更新数据
- (void)update;

@end

NS_ASSUME_NONNULL_END

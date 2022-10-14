//
//  WMZTreeBaseView.h
//  WMZTree
//
//  Created by wmz on 2019/10/19.
//  Copyright © 2019 wmz. All rights reserved.
//
#import "WMZTreeViewParam.h"
#import "WMZTreeParam.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMZTreeBaseView : UIView

@property(nonatomic, strong) WMZTreeViewParam *param;
/// 转换为树形
@property(nonatomic, strong) WMZTreeParam *tree;
/// 主视图
@property(nonatomic, strong) UITableView *table;
/// 已展开的树形数组
@property(nonatomic, strong, readonly) NSMutableArray <NSObject<WMZTreeProcotol> *>*data;
/// 储存的model字典
@property(nonatomic, strong, readonly) NSMutableDictionary <NSNumber*,NSObject<WMZTreeProcotol> *>*tmpDic;
/// 全部字典
@property(nonatomic, strong, readonly) NSMutableDictionary <NSString*,NSObject<WMZTreeProcotol> *>*dic;
/// 数据为空的占位显示图
@property(nonatomic, strong, readonly) UIView *emptyView;
/// 字典转模型
- (NSObject<WMZTreeProcotol>*)dictionaryToParam:(NSDictionary*)dic;
/// 寻找所有子节点
- (NSMutableArray*)getSonData:(NSObject<WMZTreeProcotol>*)node type:(TreeDataType)type;
///寻找所有父节点
- (NSArray*)searchAllParentNode:(NSObject<WMZTreeProcotol> *)param;
///处理空视图
- (void)setUpEmptyView:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END

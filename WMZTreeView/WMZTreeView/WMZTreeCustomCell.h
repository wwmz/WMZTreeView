//
//  WMZTreeCustomCell.h
//  WMZTree
//
//  Created by wmz on 2019/10/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZTreeParam.h"
#import "WMZTreeViewParam.h"
NS_ASSUME_NONNULL_BEGIN
@protocol WMZTreeCustomDelagete <NSObject>

/// 勾选了节点
/// @param checkStrictly 是否关联父子节点
- (void)selectNode:(WMZTreeParam*)param checkStrictly:(BOOL)checkStrictly;

/// 节点上其他UI的交互
- (void)userWithNode:(WMZTreeParam*)param param:(id)data cell:(UITableViewCell*)cell;

@end
@interface WMZTreeCustomCell : UITableViewCell
@property (nonatomic, strong) UIButton *icon;
@property (nonatomic, strong) UILabel *la;
@property (nonatomic, strong) UIButton *check;
@property (nonatomic, strong) WMZTreeViewParam *parentModel;
@property (nonatomic, strong) WMZTreeParam *model;
@property (nonatomic, weak) id<WMZTreeCustomDelagete> delagete;
- (void)UI;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier parentModel:(WMZTreeViewParam*)parentModel;
@end

NS_ASSUME_NONNULL_END

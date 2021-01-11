//
//  WMZTreeViewParam.h
//  WMZTree
//
//  Created by wmz on 2019/10/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZTreeConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface WMZTreeViewParam : NSObject
WMZTreeViewParam * TreeViewParam(void);

//展示数据 必传
WMZTreePropStatementAndPropSetFuncStatement(strong, WMZTreeViewParam, NSArray*,         wData)
//frame  必传
WMZTreePropStatementAndPropSetFuncStatement(assign, WMZTreeViewParam, CGRect,           wFrame)

//内容为空的时候展示的数据 default nil  (image为图片 name为文字)
WMZTreePropStatementAndPropSetFuncStatement(copy,   WMZTreeViewParam, NSDictionary*,    wEmptyData)
//高亮当前选中节点颜色，default是 nil。
WMZTreePropStatementAndPropSetFuncStatement(strong, WMZTreeViewParam, UIColor*,         wHighlightCurrent)
//节点的字体大小 default 15.0f;
WMZTreePropStatementAndPropSetFuncStatement(assign, WMZTreeViewParam, CGFloat,          wNodeTextFont)
//节点的字体颜色 default 333333
WMZTreePropStatementAndPropSetFuncStatement(strong, WMZTreeViewParam, UIColor*,         wNodeTextColor)

//是否默认展开所有节点  default NO
WMZTreePropStatementAndPropSetFuncStatement(assign, WMZTreeViewParam, BOOL,             wDefaultExpandAll)
//同级的能否多选 default YES 设置为NO的时候 wCheckStrictly为NO 
WMZTreePropStatementAndPropSetFuncStatement(assign, WMZTreeViewParam, BOOL,             wCanMultipleSelect)
//在显示复选框的情况下，是否严格的遵循父子互相关联的做法，defualt为 YES
WMZTreePropStatementAndPropSetFuncStatement(assign, WMZTreeViewParam, BOOL,             wCheckStrictly)
//隐藏展开图标，defualt为 NO
WMZTreePropStatementAndPropSetFuncStatement(assign, WMZTreeViewParam, BOOL,             wHideExpanIcon)
//节点是否可被选择 default NO
WMZTreePropStatementAndPropSetFuncStatement(assign, WMZTreeViewParam, BOOL,             wShowCheckbox)
//是否每次只打开一个同级树节点展开 手风琴效果 default NO
WMZTreePropStatementAndPropSetFuncStatement(assign, WMZTreeViewParam, BOOL,             wAccordion)
//是否开启拖拽节点功能  ⚠️目前只支持没有子节点的节点拖拽 如果有什么方便的办法可以支持多个cell一起拖拽的告知下
WMZTreePropStatementAndPropSetFuncStatement(assign, WMZTreeViewParam, BOOL,             wDraggable)

//当canSelect为NO的时候 是否显示(不可点击) defaultNO
WMZTreePropStatementAndPropSetFuncStatement(assign, WMZTreeViewParam, BOOL,             wShowOnly)
//默认展开的节点的 key 的数组 default nil
WMZTreePropStatementAndPropSetFuncStatement(strong, WMZTreeViewParam, NSArray*,         wDefaultExpandedKeys)
//相邻级节点间的水平缩进距离  默认2
WMZTreePropStatementAndPropSetFuncStatement(assign, WMZTreeViewParam, NSInteger,        wIndent)
//自定义树节点的图标
WMZTreePropStatementAndPropSetFuncStatement(strong, WMZTreeViewParam, NSString*,        wExpandIcon)
//自定义树节点展开的图标
WMZTreePropStatementAndPropSetFuncStatement(strong, WMZTreeViewParam, NSString*,        wSelectExpandIcon)
//自定义树节点未勾选的图标
WMZTreePropStatementAndPropSetFuncStatement(strong, WMZTreeViewParam, NSString*,        wCheckIcon)
//自定义树节点勾选的图标
WMZTreePropStatementAndPropSetFuncStatement(strong, WMZTreeViewParam, NSString*,        wSelectCheckIcon)
//自定义树节点半选中的图标 (没有全选)
WMZTreePropStatementAndPropSetFuncStatement(strong, WMZTreeViewParam, NSString*,        wHalfSelectCheckIcon)


//自定义节点cell
WMZTreePropStatementAndPropSetFuncStatement(copy, WMZTreeViewParam, CustomTreeCell,     wEventTreeCell)
//自定义cell其他交互
WMZTreePropStatementAndPropSetFuncStatement(copy, WMZTreeViewParam, CellUserEnabled,    wEventCellUserEnabled)
//自定义cell高度
WMZTreePropStatementAndPropSetFuncStatement(copy, WMZTreeViewParam, CustomTreeCellHeight,wEventCellHeight)
//节点被点击时的回调
WMZTreePropStatementAndPropSetFuncStatement(copy, WMZTreeViewParam, NodeClickBlock,     wEventNodeClick)
//节点拖拽完成回调
WMZTreePropStatementAndPropSetFuncStatement(copy, WMZTreeViewParam, CellDraggable,      wEventNodeDraggable)
//节点选中状态发生变化时的回调
WMZTreePropStatementAndPropSetFuncStatement(copy, WMZTreeViewParam, NodeCheckChange,    wEventCheckChange)


@end

NS_ASSUME_NONNULL_END



//
//  WMZTreeViewParam.m
//  WMZTree
//
//  Created by wmz on 2019/10/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZTreeViewParam.h"

@implementation WMZTreeViewParam
WMZTreePropSetFuncImplementation(WMZTreeViewParam, NSArray*,         wData)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, CGRect,           wFrame)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, NSDictionary*,    wEmptyData)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, UIColor*,         wHighlightCurrent)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, CGFloat,          wNodeTextFont)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, UIColor*,         wNodeTextColor)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, NSArray*,         wDefaultExpandedKeys)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, BOOL,             wShowOnly)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, BOOL,             wShowCheckbox)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, BOOL,             wAccordion)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, BOOL,             wCheckStrictly)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, BOOL,             wDraggable)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, BOOL,             wDefaultExpandAll)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, BOOL,             wHideExpanIcon)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, NSInteger,        wIndent)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, NSString*,        wExpandIcon)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, NSString*,        wSelectExpandIcon)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, NSString*,        wCheckIcon)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, NSString*,        wSelectCheckIcon)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, NSString*,        wHalfSelectCheckIcon)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, NodeClickBlock,   wEventNodeClick)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, NodeCheckChange,  wEventCheckChange)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, CustomTreeCell,   wEventTreeCell)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, CellUserEnabled,  wEventCellUserEnabled)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, CustomTreeCellHeight,wEventCellHeight)
WMZTreePropSetFuncImplementation(WMZTreeViewParam, CellDraggable,    wEventNodeDraggable)
WMZTreeViewParam * TreeViewParam(void){
    return  [WMZTreeViewParam new];
}

- (instancetype)init{
    if (self = [super init]) {
        _wNodeTextFont = 15.0f;
        _wNodeTextColor = [UIColor blackColor];
        _wIndent = 2;
        _wExpandIcon = @"close";
        _wSelectExpandIcon = @"open";
        _wCheckIcon = @"treeCheck";
        _wSelectCheckIcon = @"treeCheckSelect";
        _wHalfSelectCheckIcon = @"treeHalfSelect";
        _wCheckStrictly = YES;
    }
    return self;
}

@end

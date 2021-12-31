//
//  WMZTreeConfig.h
//  WMZTree
//
//  Created by wmz on 2019/10/17.
//  Copyright © 2019 wmz. All rights reserved.
//

#ifndef WMZTreeConfig_h
#define WMZTreeConfig_h

#import <UIKit/UIKit.h>

#define TreeColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define  TreeWidth   [UIScreen mainScreen].bounds.size.width
#define  TreeHeight  [UIScreen mainScreen].bounds.size.height

#define TreeAlert(TITLE,MESSAGE,QUVC) UIAlertController *alertController = [UIAlertController alertControllerWithTitle:TITLE message:MESSAGE preferredStyle:UIAlertControllerStyleAlert];\
[alertController addAction:[UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDefault handler:nil]];\
[QUVC presentViewController:alertController animated:YES completion:nil];


#define WMZTreePropStatementAndPropSetFuncStatement(propertyModifier,className, propertyPointerType, propertyName)           \
@property(nonatomic,propertyModifier)propertyPointerType  propertyName;                                                 \
- (className * (^) (propertyPointerType propertyName)) propertyName##Set;

#define WMZTreePropSetFuncImplementation(className, propertyPointerType, propertyName)                                       \
- (className * (^) (propertyPointerType propertyName))propertyName##Set{                                                \
return ^(propertyPointerType propertyName) {                                                                            \
self->_##propertyName = propertyName;                                                                                         \
return self;                                                                                                            \
};                                                                                                                      \
}

typedef enum :NSInteger{
    ///获取全部包括自身
    TreeDataAllWithSelf,
    ///获取全部数据不包括自身
    TreeDataGetSelectAll,
    ///获取全部(以下全不包括自身)
    TreeDataAll,
    ///全部选中的子节点
    TreeDataSelectAll,
    ///获取同级的节点
    TreeDataSameLevel,
    ///获取展开的和第一级
    TreeDataExpandOrNotParent,
    ///增加
    TreeDataInsert,
    ///删除
    TreeDataDelete,
}TreeDataType;

/// 点击
typedef void (^NodeClickBlock)(id node);

/// 勾选
typedef void (^NodeCheckChange)(id node,BOOL isSelect);

/// cell
typedef UITableViewCell* (^CustomTreeCell)(id model,NSIndexPath* path,UITableView *table,id param);

/// cell交互
typedef void (^CellUserEnabled)(id model,NSIndexPath* path,UITableView *table,id userInfo);

/// cell拖拽
typedef void (^CellDraggable)(NSIndexPath* sourceIndexPath,NSIndexPath* destinationIndexPath,UITableView *table);

/// cell height
typedef CGFloat (^CustomTreeCellHeight)(id model,NSIndexPath* path,UITableView *table);

#endif /* WMZTreeConfig_h */

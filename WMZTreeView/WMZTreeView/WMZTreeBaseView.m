//
//  WMZTreeBaseView.m
//  WMZTree
//
//  Created by wmz on 2019/10/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZTreeBaseView.h"

@interface WMZTreeBaseView()
/// 已展开的树形数组
@property(nonatomic, strong, readwrite) NSMutableArray *data;
/// 全部字典
@property(nonatomic, strong, readwrite) NSMutableDictionary *dic;
/// 数据为空的占位显示图
@property(nonatomic, strong, readwrite) UIView *emptyView;

@end

@implementation WMZTreeBaseView

/// 处理空视图
- (void)setUpEmptyView:(NSDictionary*)dic{
    UIImageView *image = (UIImageView*)[self.emptyView viewWithTag:999];
    UILabel *la = (UILabel*)[self.emptyView viewWithTag:998];
    la.center = self.emptyView.center;
    image.frame = CGRectMake(image.frame.origin.x, CGRectGetMinY(la.frame)-image.frame.size.height, image.frame.size.width, image.frame.size.height);
    image.center = CGPointMake(self.emptyView.center.x, image.center.y);
    if (dic[WMZTreeImage]) image.image = [UIImage imageNamed:dic[WMZTreeImage]];
    if (dic[WMZTreeName]) la.text = dic[WMZTreeName];
}

- (WMZTreeParam*)dictionaryToParam:(NSDictionary*)dic{
    WMZTreeParam *param = TreeParam();
    if (dic[WMZTreeName]) param.nameSet(dic[WMZTreeName]);
    if (dic[WMZTreeCurrentId]) param.currentIdSet(dic[WMZTreeCurrentId]);
    if (dic[WMZTreeParentId]) param.parentIdSet(dic[WMZTreeParentId]);
    if (dic[WMZTreeExpand]) param.isExpandSet([dic[WMZTreeExpand] boolValue]);
    if (dic[WMZTreeCanSelect]) param.canSelectSet([dic[WMZTreeCanSelect] boolValue]);
    if (dic[WMZTreeExistData]) param.dataSet(dic[WMZTreeExistData]);
    if (dic[WMZTreeChildren]) param.children = [NSMutableArray arrayWithArray:dic[WMZTreeChildren]];
    if (param.currentId) {
        [self.dic setObject:param forKey:param.currentId];
        if (!param.parentId && param) [self.tree.children addObject:param];
    }
    return param;
}

/// 寻找所有子节点
- (NSMutableArray*)getSonData:(WMZTreeParam*)node type:(TreeDataType)type{
    NSMutableArray *sonData = [NSMutableArray new];
    if (!node) return sonData;
    NSMutableArray *stack = [NSMutableArray new];
    [stack addObject:node];
    WMZTreeParam *tmpNode = [WMZTreeParam new];
    while (stack.count) {
           WMZTreeParam *son = nil;
           tmpNode = stack.lastObject;
           WMZTreeParam *parentNode = self.dic[tmpNode.parentId];
           [stack removeLastObject];
           
           if (!tmpNode.depath&&tmpNode!=node) {
               tmpNode.depath = parentNode.depath+1;
           }
           if (type == TreeDataAllWithSelf) {
               if (parentNode.isExpand) {
                   if(tmpNode) [sonData addObject:tmpNode];
               }else{
                   if (parentNode.isExpand&&[sonData indexOfObject:parentNode]!=NSNotFound) {
                       if(tmpNode) [sonData addObject:tmpNode];
                   }
               }
           }else if (type == TreeDataAll) {
               if (tmpNode!=node) {
                   tmpNode.isExpand = YES;
                   if(tmpNode) [sonData addObject:tmpNode];
               }
           }else if (type == TreeDataGetSelectAll) {
               if (tmpNode!=node) {
                   if(tmpNode) [sonData addObject:tmpNode];
               }
           }else if (type == TreeDataSelectAll) {
               if (tmpNode!=node) {
                   tmpNode.isSelected = node.isSelected;
                   if (!node.isSelected) {
                       tmpNode.halfSelect = NO;
                   }
               }
           }else if (type == TreeDataExpandOrNotParent) {
               if (tmpNode!=node) {
                   if (!tmpNode.parentId) {
                       if(tmpNode) [sonData addObject:tmpNode];
                   }else if (([sonData indexOfObject:parentNode]!=NSNotFound)&&parentNode.isExpand){
                            if(tmpNode) [sonData addObject:tmpNode];
                   }
               }
           }else if(type == TreeDataDelete || type == TreeDataInsert){
               if (tmpNode!=node) {
                   if ([tmpNode.parentId isEqualToString: node.currentId]) {
                       if (type == TreeDataInsert?(parentNode.isExpand):(!parentNode.isExpand)) {
                           if(tmpNode) [sonData addObject:tmpNode];
                       }
                   }else{
                       if (parentNode.isExpand&&
                           [sonData indexOfObject:parentNode]!=NSNotFound) {
                           if(tmpNode) [sonData addObject:tmpNode];
                       }
                   }
               }
           }else if(type == TreeDataSameLevel){
               if (parentNode) {
                   for (NSInteger i = 0; i < parentNode.children.count; i++) {
                       son = parentNode.children[i];
                       if (son!=tmpNode) {
                           if(son) [sonData addObject:son];
                       }
                   }
                    break;
               }
           }else{
               if (tmpNode!=node) {
                   if (tmpNode) [sonData addObject:tmpNode];
               }
           }
           
           for (NSInteger i = tmpNode.children.count - 1; i >= 0; i--) {
               son = tmpNode.children[i];
               if(son) [stack addObject:son];
           }
       }
       return sonData;
}


/// 寻找该节点的所有父节点
- (NSArray*)searchAllParentNode:(WMZTreeParam *)param{
    NSMutableArray *arr = [NSMutableArray new];
    NSMutableArray *loop= [NSMutableArray new];
    if (param.parentId && self.dic[param.parentId])
        [loop addObject:self.dic[param.parentId]];
    
    while (loop.count) {
        WMZTreeParam *tmp = loop.lastObject;
        if (param.isSelected) {
           tmp.halfSelect = NO;
           tmp.isSelected = YES;
           for (WMZTreeParam *son in tmp.children) {
                if (!son.isSelected&&son.canSelect) {
                    tmp.halfSelect = YES;
                    tmp.isSelected = NO;
                    break;
                }
           }
        }else{
            tmp.halfSelect = NO;
            tmp.isSelected = NO;
            for (WMZTreeParam *son in tmp.children) {
                if (son!=tmp&&son.isSelected&&son.canSelect) {
                    tmp.halfSelect = YES;
                    break;
                }
            }
        }
        [loop removeLastObject];
        if(tmp) [arr addObject:tmp];
        if (tmp.parentId && self.dic[tmp.parentId]) {
            [loop addObject:self.dic[tmp.parentId]];
        }
    }
    return arr;
}

- (UIView *)emptyView{
    if (!_emptyView) {
        _emptyView = [UIView new];
        _emptyView.frame = self.bounds;
        UIImageView *image = [UIImageView new];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.tag = 999;
        image.frame = CGRectMake(0, 0, _emptyView.bounds.size.width<200?_emptyView.bounds.size.width*0.8:200, _emptyView.bounds.size.height<200?_emptyView.bounds.size.height*0.8:200);
        [_emptyView addSubview:image];
        UILabel *la = [UILabel new];
        la.tag = 998;
        la.textAlignment = NSTextAlignmentCenter;
        la.frame = CGRectMake(0, 0, _emptyView.bounds.size.width, 40);
        [_emptyView addSubview:la];
    }
    return _emptyView;
}

- (UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _table.estimatedRowHeight = 100;
        if (@available(iOS 11.0, *)) {
            _table.estimatedSectionFooterHeight = 0.01;
            _table.estimatedSectionHeaderHeight = 0.01;
            _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000
         if (@available(iOS 15.0, *)) {
             _table.sectionHeaderTopPadding = 0;
         }
        #endif
        _table.backgroundColor = UIColor.clearColor;
        _table.dragDelegate = self;
        _table.delegate = (id)self;
        _table.dataSource = (id)self;
    }
    return _table;
}

- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

- (NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = [NSMutableDictionary new];
    }
    return _dic;
}

@end

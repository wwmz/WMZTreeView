


//
//  WMZTreeView.m
//  WMZTree
//
//  Created by wmz on 2019/10/17.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZTreeView.h"
#import "WMZTreeCustomCell.h"
@interface WMZTreeView()<UITableViewDelegate,UITableViewDataSource,WMZTreeCustomDelagete>
@end
@implementation WMZTreeView

- (instancetype)initWithParam:(WMZTreeViewParam*)param{
    if (self = [super init]) {
        self.param = param;
        self.frame = self.param.wFrame;
        [self setUp];
    }
    return self;
}

/// 更新编辑状态
- (void)updateEditing{
    self.table.editing = self.param.wDraggable;
    [self.table reloadData];
}

/// 全选
- (void)selectAll{
    NSMutableArray *insetArr = [self getSonData:self.tree type:TreeDataGetSelectAll];
    for (NSObject<WMZTreeProcotol> *param in insetArr) {
        if (param.canSelect) param.isSelected = YES;
    }
    [self.table reloadData];
}

/// 全部取消选中
- (void)notSelectAll{
    NSMutableArray *insetArr = [self getSonData:self.tree type:TreeDataGetSelectAll];
    for (NSObject<WMZTreeProcotol> *param in insetArr) {
        if (param.canSelect) param.isSelected = NO;
    }
    [self.table reloadData];
}

- (void)setUp{
    if (!self.param.wData||
        ![self.param.wData isKindOfClass:[NSArray class]]) return;
    BOOL JSON = NO;
    for (id model in self.param.wData) {
        if ([model isKindOfClass:[NSDictionary class]]) {
            JSON = YES;
            break;
        }
    }
    self.tree = WMZTreeParam.new;
    if (JSON) {
        @autoreleasepool {
            [self changeJSONtToTreeModel:self.param.wData type:self.param.wDefaultExpandAll?TreeDataAll: TreeDataExpandOrNotParent];
        }
    }else{
        @autoreleasepool {
            [self dealTreeData:self.param.wData];
        }
        [self.data addObjectsFromArray:[self getSonData:self.tree type:self.param.wDefaultExpandAll?TreeDataAll: TreeDataExpandOrNotParent ]];
    }
    if (!self.data.count) {
        [self.table removeFromSuperview];
        [self addSubview:self.emptyView];
        [self setUpEmptyView:self.param.wEmptyData];
    }else{
        [self.emptyView removeFromSuperview];
        [self addSubview:self.table];
        self.table.editing = self.param.wDraggable;
    }
    if (self.param.wDefaultExpandedKeys) {
        for (NSString *key in self.param.wDefaultExpandedKeys) {
            NSObject<WMZTreeProcotol> *value = self.dic[key];
            if (value) {
                value.isSelected = YES;
                if (self.param.wCheckStrictly) {
                    [self setSelectNodeParentAndSonNodeStatus:value checkStrictly:self.param.wCheckStrictly reload:NO];
                }
            }
        }
    }
    [self.table reloadData];
}

/// 解析传入的数组 传入的NSObject<WMZTreeProcotol>组成的数组
- (void)dealTreeData:(NSArray<NSObject<WMZTreeProcotol>*>*)items {
    [items enumerateObjectsUsingBlock:^(NSObject<WMZTreeProcotol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dic setObject:obj forKey:obj.currentId];
    }];
    
    [items enumerateObjectsUsingBlock:^(NSObject<WMZTreeProcotol>*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.parentId) {
            if (obj && [obj conformsToProtocol:@protocol(WMZTreeProcotol)]) [self.tree.children addObject:obj];
        }else{
            NSObject<WMZTreeProcotol> *param = self.dic[obj.parentId];
            if (obj && [obj conformsToProtocol:@protocol(WMZTreeProcotol)]){
                if(!param.children) param.children = NSMutableArray.new;
                [param.children addObject:obj];
            }
            if (param){
                __block NSInteger canSelectCount = 0;
                [param.children enumerateObjectsUsingBlock:^(NSObject<WMZTreeProcotol> * _Nonnull sonObj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (!sonObj.canSelect) canSelectCount += 1;
                }];
                if (canSelectCount &&
                    canSelectCount == param.children.count) {
                    if (param.canSelect) param.canSelect = NO;
                }
            }
        }
    }];
}

/// 传进来的是字典 转为树形模型
- (void)changeJSONtToTreeModel:(NSArray*)data type:(TreeDataType)type{
    if (!data) return;
    NSMutableArray *stack = [NSMutableArray new];
    NSDictionary *dic = @{WMZTreeChildren:data};
    if(dic) [stack addObject:dic];
    id tmpDic ;
    while (stack.count) {
        tmpDic  = stack.lastObject;
        NSObject<WMZTreeProcotol> *tmpNode = nil;
        if ([tmpDic isKindOfClass:[NSDictionary class]]) {
            tmpNode = [self dictionaryToParam:tmpDic];
        }else{
            tmpNode = tmpDic;
        }
        if (tmpNode.parentId) {
            NSObject<WMZTreeProcotol> *parentNode = self.dic[tmpNode.parentId];
            NSInteger index = [parentNode.children indexOfObject:tmpDic];
            parentNode.children[index] = tmpNode;
        }
        NSObject<WMZTreeProcotol> *parentNode = self.dic[tmpNode.parentId];
        if (!tmpNode.depath&&tmpDic!=dic) {
            tmpNode.depath = parentNode.depath+1;
        }
        [stack removeLastObject];
        if (tmpNode.currentId) {
            if (type == TreeDataAll) {
                if (tmpDic!=dic) {
                    tmpNode.isExpand = YES;
                    if (tmpNode) [self.data addObject:tmpNode];
                }
            }else if (type == TreeDataExpandOrNotParent) {
                if (self.data ) {
                    if (!tmpNode.parentId && tmpNode) {
                        [self.data addObject:tmpNode];
                    }
                    else if (([self.data indexOfObject:parentNode]!=NSNotFound)&&
                              parentNode.isExpand &&
                              tmpNode){
                              [self.data  addObject:tmpNode];
                    }
                 }
            } 
        }
        for (NSInteger i = tmpNode.children.count - 1; i >= 0; i--) {
            if (tmpNode.children[i]) {
                [stack addObject:tmpNode.children[i]];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject<WMZTreeProcotol> *param = self.data[indexPath.row];
    if (self.param.wEventCellHeight) {
        return self.param.wEventCellHeight(param,indexPath,tableView);
    }
    return 44;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
       
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSObject<WMZTreeProcotol> *param = self.data[sourceIndexPath.row];
    NSObject<WMZTreeProcotol> *toParam = self.data[destinationIndexPath.row];
    if (param.parentId) {
        NSObject<WMZTreeProcotol> *parent = self.dic[param.parentId];
        [parent.children removeObject:param];
    }
    param.parentId = toParam.parentId;
    param.depath = toParam.depath;
    param.isExpand = NO;
    if (toParam.parentId) {
        NSObject<WMZTreeProcotol> *parent = self.dic[toParam.parentId];
        NSInteger index = [parent.children indexOfObject:toParam];
        if (index <= parent.children.count) {
            [parent.children insertObject:param atIndex:index];
        }
    }
    [self.data removeObject:param];
    NSMutableArray *paramArr = [self getSonData:param type:TreeDataGetSelectAll];
    [self.data insertObject:param atIndex:destinationIndexPath.row];
    int i = 0;
    for (NSObject<WMZTreeProcotol> *son in paramArr) {
        if([self.data indexOfObject:son] != NSNotFound){
            [self.data removeObject:son];
            [self.data insertObject:son atIndex:destinationIndexPath.row + i + 1];
        }
        i ++;
    }
    [tableView reloadData];
    if (self.param.wEventNodeDraggable) {
        self.param.wEventNodeDraggable(sourceIndexPath, destinationIndexPath, tableView);
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.param.wEventTreeCell) {
        WMZTreeCustomCell *cell = (WMZTreeCustomCell*)self.param.wEventTreeCell(self.data[indexPath.row],indexPath,tableView,self.param);
        if ([cell isKindOfClass:WMZTreeCustomCell.class])
            cell.delagete = self;
        
        if (cell) return cell;
    }
    WMZTreeCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WMZTreeCustomCell class])];
    if (!cell) {
        cell = [[WMZTreeCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([WMZTreeCustomCell class]) parentModel:self.param];
    }
    cell.delagete = self;
    cell.model = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject<WMZTreeProcotol> *param = self.data[indexPath.row];
    [self tapNodeAction:param indexRow:indexPath.row];
}

- (void)tapNodeAction:(NSObject<WMZTreeProcotol>*)param indexRow:(NSInteger)row{
   param.isExpand = !param.isExpand;
   if (param.children.count) {
       if (param.isExpand) {
           NSMutableArray *insetArr = [self getSonData:param type:TreeDataInsert];
           NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row + 1, insetArr.count)];
           [self.data insertObjects:insetArr atIndexes:indexSet];
       }else{
           NSArray *arr = [self getSonData:param type:TreeDataDelete];
           [self.data removeObjectsInArray:arr];
       }
   }
   else{
       param.isExpand = NO;
   }
   /// 手风琴效果
   if (self.param.wAccordion&&param.isExpand) {
       NSObject<WMZTreeProcotol> *parentModel =  param.parentId?(self.dic[param.parentId]):self.tree;
       for (NSObject<WMZTreeProcotol> *model in parentModel.children) {
           if (!model.isExpand||model == param) continue;
           if (model.isExpand) {
               model.isExpand = NO;
               [self.data removeObjectsInArray:[self getSonData:model type:TreeDataDelete]];
           }
      }
   }
   /// 设计数据过多 全局刷新
   [self.table reloadData];
   if (self.param.wEventNodeClick) {
       self.param.wEventNodeClick(param);
   }
}

#pragma WMZtreeCellDelagete
- (void)selectNode:(NSObject<WMZTreeProcotol> *)param checkStrictly:(BOOL)checkStrictly{
    [self setSelectNodeParentAndSonNodeStatus:param checkStrictly:checkStrictly reload:YES];
    if (self.param.wEventCheckChange) {
        self.param.wEventCheckChange(param,param.isSelected);
    }
}

- (void)userWithNode:(NSObject<WMZTreeProcotol> *)param param:(id)data cell:(id)cell{
    if (self.param.wEventCellUserEnabled) {
        self.param.wEventCellUserEnabled(param, [self.table indexPathForCell:cell], self.table,data);
    }
}

/// 关联所有父级和所有子级
- (void)setSelectNodeParentAndSonNodeStatus:(NSObject<WMZTreeProcotol> *)param checkStrictly:(BOOL)checkStrictly reload:(BOOL)reload{
    /// 关闭多选
    if (!self.param.wCanMultipleSelect) {
        NSArray *sameLevel = [self getSonData:param type:TreeDataSameLevel];
        [sameLevel enumerateObjectsUsingBlock:^(NSObject<WMZTreeProcotol>*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isSelected = NO;
            obj.halfSelect = NO;
        }];
        if (reload) {
            [self.table reloadData];
        }
    }else{
        if (checkStrictly) {
          /// 关联上级
          NSArray *parentNode = nil;
          if (param.parentId) {
              parentNode = [self searchAllParentNode:param];
          }
            
          /// 关联下级
          if (param.children.count) {
              [self getSonData:param type:TreeDataSelectAll];
          }
            
          if (reload) {
             [self.table reloadData];
          }
      }else{
          //不关联直接刷新
          NSIndexPath *path = [NSIndexPath indexPathForRow:[self.data indexOfObject:param] inSection:0];
          [self.table beginUpdates];
          [self.table reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
          [self.table endUpdates];
      }
    }
}

- (BOOL)updateKeyChildren:(NSString*)currrentID data:(NSArray*)data{
    if (!currrentID) {
        NSLog(@"节点id不能为空");return NO;
    }
    
    if (currrentID&&currrentID.length) {
        NSObject<WMZTreeProcotol> *currentParam = self.dic[currrentID];
        
        /// 删除旧的
        NSArray *arr = [self getSonData:currentParam type:999];
        for (NSObject<WMZTreeProcotol> *param in arr) {
            if ([self.data indexOfObject:param]!=NSNotFound) {
                [self.data removeObject:param];
            }
            [self.dic removeObjectForKey:param.currentId];
        }
        
        /// 替换新的
        currentParam.children = [NSMutableArray arrayWithArray:data];
        for (NSObject<WMZTreeProcotol> *param in data) {
            if (param) {
                [self.dic setObject:param forKey:param.currentId];
            }
        }
        
        if (currentParam.isExpand) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.data indexOfObject:currentParam] inSection:0];
            NSArray *insetArr = [self getSonData:currentParam type:TreeDataInsert];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, insetArr.count)];
            [self.data insertObjects:insetArr atIndexes:indexSet];
        }
        
        [self.table reloadData];
    }else{
        [self.dic removeAllObjects];
        [self.data removeAllObjects];
        self.param.wData = [NSArray arrayWithArray:data];
        [self setUp];
    }

    return YES;
}

- (NSArray*)getCheckedNodesWithHalfSelect:(BOOL)halfSelect{
    NSMutableArray *allData = [self getSonData:self.tree type:TreeDataGetSelectAll];
    NSMutableArray *checkArr = [NSMutableArray new];
    for (NSObject<WMZTreeProcotol> *param in allData) {
        if (param.isSelected&&param.canSelect ) {
            if (param) [checkArr addObject:param];
        }else{
            if (halfSelect&&param.halfSelect&&param.canSelect) {
                if(param) [checkArr addObject:param];
            }
        }
    }
    return [NSArray arrayWithArray:checkArr];
}

- (BOOL)append:(NSString*)currrentID node:(NSObject<WMZTreeProcotol>*)param{
    BOOL success = NO;
    if (!currrentID) {
        NSLog(@"节点id不能为空");return NO;
    }
    if (!param||![param isKindOfClass:[NSObject<WMZTreeProcotol> class]]) {
        NSLog(@"子节点错误");return NO;
    }
    if ([self.dic objectForKey:param.currentId]) {
        NSLog(@"要添加的节点已存在");return NO;
    }
    NSObject<WMZTreeProcotol> *parent = self.dic[currrentID];
    param.depath = parent.depath+1;
    NSArray *parentExpandArr =  [self getSonData:parent type:TreeDataInsert];
    if(param) [parent.children addObject:param];
    [self.dic setObject:param forKey:param.currentId];
    NSArray *arr =  [self getSonData:param type:TreeDataAllWithSelf];
    NSInteger index = [self.data indexOfObject:parent];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index+ parentExpandArr.count + 1, arr.count)];
    [self.data insertObjects:arr atIndexes:indexSet];
    
    if (!parent.isExpand) {
        NSInteger num = [self.data indexOfObject:parent];
        if (num!=NSNotFound) {
            [self tapNodeAction:parent indexRow:num];
        }
    }
    
    [self.table reloadData];
    
    return success;
}

- (BOOL)remove:(NSString*)currrentID{
    if (!currrentID) {
        NSLog(@"节点id不能为空");return NO;
    }
    BOOL success = NO;
    NSObject<WMZTreeProcotol> *parent = self.dic[currrentID];
    if (!parent) {
        NSLog(@"节点不存在");return NO;
    }
    /// 删除自身
    if ([self.dic valueForKey:parent.currentId]) {
        [self.dic removeObjectForKey:parent.currentId];
         success = YES;
    }
    if ([self.data indexOfObject:parent]!=NSNotFound) {
        [self.data removeObject:parent];
        success = YES;
    }
    if (parent.parentId) {
        NSObject<WMZTreeProcotol> *parentNode = self.dic[parent.parentId];
        [parentNode.children removeObject:parent];
    }
    
    /// 删除子节点
    NSArray *parentExpandArr =  [self getSonData:parent type:TreeDataDelete];
    for (NSObject<WMZTreeProcotol> *param in parentExpandArr) {
        if ([self.dic valueForKey:param.currentId]) {
            [self.dic removeObjectForKey:param.currentId];
        }
        if ([self.data indexOfObject:param]!=NSNotFound) {
            [self.data removeObject:param];
        }
    }
    
    [self.table reloadData];
    
    return success;
}

- (BOOL)insertBefore:(NSString*)currrentID node:(NSObject<WMZTreeProcotol>*)param{
    if (!currrentID) {
        NSLog(@"节点id不能为空");return NO;
    }
    if (!param||![param isKindOfClass:[NSObject<WMZTreeProcotol> class]]) {
        NSLog(@"追加的节点错误");return NO;
    }
    if ([self.dic objectForKey:param.currentId]) {
        NSLog(@"要添加的节点已存在");return NO;
    }
    BOOL success = NO;
    NSObject<WMZTreeProcotol> *node = self.dic[currrentID];
    param.depath = node.depath;
    [self.dic setObject:param forKey:param.currentId];
    NSInteger index = [self.data indexOfObject:node];
    if (!node.parentId) {
        NSInteger sonIndex= [self.tree.children indexOfObject:node];
        [self.tree.children insertObject:param atIndex:sonIndex];
    }else{
        NSObject<WMZTreeProcotol> *parentNode = self.dic[node.parentId];
        NSInteger sonIndex= [parentNode.children indexOfObject:node];
        [parentNode.children insertObject:param atIndex:sonIndex];
    }

    [self.data insertObject:param atIndex:index];
    
    if (param.isExpand) {
        NSArray *arr = [self getSonData:param type:999];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index + 1, arr.count)];
        [self.data insertObjects:arr atIndexes:indexSet];
        
    }
    [self.table reloadData];
    return success;
}

- (BOOL)insertAfter:(NSString*)currrentID node:(NSObject<WMZTreeProcotol>*)param{
    if (!currrentID) {
        NSLog(@"节点id不能为空");return NO;
    }
    if (!param||![param isKindOfClass:[NSObject<WMZTreeProcotol> class]]) {
        NSLog(@"追加的节点错误");return NO;
    }
    if ([self.dic objectForKey:param.currentId]) {
        NSLog(@"要添加的节点已存在");return NO;
    }
   BOOL success = NO;
   NSObject<WMZTreeProcotol> *node = self.dic[currrentID];
   param.depath = node.depath;
   [self.dic setObject:param forKey:param.currentId];
   NSArray *parentExpandArr =  [self getSonData:node type:TreeDataInsert];
   NSInteger index = [self.data indexOfObject:node];
   if (!node.parentId) {
       if(param) [self.tree.children addObject:param];
   }else{
       NSObject<WMZTreeProcotol> *parentNode = self.dic[node.parentId];
       if(param) [parentNode.children addObject:param];
   }

   [self.data insertObject:param atIndex:index+1+parentExpandArr.count];
   
   if (param.isExpand) {
       NSArray *arr = [self getSonData:param type:999];
       NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index + 2+ parentExpandArr.count, arr.count)];
       [self.data insertObjects:arr atIndexes:indexSet];
       
   }
   [self.table reloadData];
   return success;
}

- (NSObject<WMZTreeProcotol>*)getParentId:(NSString*)currrentID{
    NSObject<WMZTreeProcotol> *node = self.dic[currrentID];
    return self.dic[node.parentId];
}

- (void)update{
    [self.data removeAllObjects];
    [self setUp];
    [self.table reloadData];
}

@end

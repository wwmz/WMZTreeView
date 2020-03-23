


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

/*
*更新编辑状态
*/
- (void)updateEditing{
    self.table.editing = self.param.wDraggable;
    [self.table reloadData];
}

/*
*全选
*/
- (void)selectAll{
    for (WMZTreeParam *param in self.data) {
        if (param.canSelect) {
            param.isSelected = YES;
        }
    }
    [self.table reloadData];
}

/*
*全部取消选中
*/
- (void)notSelectAll{
    for (WMZTreeParam *param in self.data) {
        if (param.canSelect) {
            param.isSelected = NO;
        }
    }
    [self.table reloadData];
}

- (void)setUp{
    
    if (!self.param.wData||![self.param.wData isKindOfClass:[NSArray class]]) return;
    BOOL JSON = NO;
    for (id model in self.param.wData) {
        if ([model isKindOfClass:[NSDictionary class]]) {
            JSON = YES;
            break;
        }
    }
    self.tree = TreeParam();
    if (JSON) {
        [self changeJSONtToTreeModel:self.param.wData type:self.param.wDefaultExpandAll?TreeDataAll: TreeDataExpandOrNotParent];

    }else{
        [self dealTreeData:self.param.wData];
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
        self.table.delegate = self;
        self.table.dataSource = self;
    }
    
    if (self.param.wDefaultExpandedKeys) {
        
        for (NSString *key in self.param.wDefaultExpandedKeys) {
            WMZTreeParam *value = self.dic[key];
            if (value) {
                value.isSelected = YES;
                if (self.param.wCheckStrictly) {
                    [self setSelectNodeParentAndSonNodeStatus:value checkStrictly:self.param.wCheckStrictly reload:NO];
                }
            }
        }
        [self.table reloadData];
    }
}

/*
*解析传入的数组 传入的WMZTreeParam组成的数组
*/
- (void)dealTreeData:(NSArray*)items {
    for (int i = 0; i<items.count; i++) {
        @autoreleasepool {
            WMZTreeParam *model = items[i];
            [self.dic setObject:model forKey:model.currentId];
        }
    }
    NSMutableArray *arr = [NSMutableArray new];
    [self.dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, WMZTreeParam * _Nonnull obj, BOOL * _Nonnull stop) {
      @autoreleasepool {
        if (!obj.parentId) {
            [self.tree.children addObject:obj];
        }else{
            WMZTreeParam *param = self.dic[obj.parentId];
            if (param) {
                [param.children addObject:obj];
            }
            [arr addObject:param];
        }
     }
    }];
    
    [arr enumerateObjectsUsingBlock:^(WMZTreeParam*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block NSInteger canSelectCount = 0;
        [obj.children enumerateObjectsUsingBlock:^(WMZTreeParam * _Nonnull sonObj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!sonObj.canSelect) {
                canSelectCount += 1;
            }
        }];
        if (canSelectCount && canSelectCount == obj.children.count) {
            if (obj.canSelect) {
                obj.canSelect = NO;
            }
        }
    }];
}

//传进来的是字典 转为树形模型
- (void)changeJSONtToTreeModel:(NSArray*)data type:(TreeDataType)type{
    if (!data) return;
    NSMutableArray *stack = [NSMutableArray new];
    NSDictionary *dic = @{@"children":data};
    [stack addObject:dic];
    id tmpDic ;
    while (stack.count) {
        tmpDic  = stack.lastObject;
        WMZTreeParam *tmpNode = nil;
        if ([tmpDic isKindOfClass:[NSDictionary class]]) {
            tmpNode = [self dictionaryToParam:tmpDic];
        }else{
            tmpNode = tmpDic;
        }
        if (tmpNode.parentId) {
            WMZTreeParam *parentNode = self.dic[tmpNode.parentId];
            NSInteger index = [parentNode.children indexOfObject:tmpDic];
            parentNode.children[index] = tmpNode;
        }

        
        WMZTreeParam *parentNode = self.dic[tmpNode.parentId];
        if (!tmpNode.depath&&tmpDic!=dic) {
            tmpNode.depath = parentNode.depath+1;
        }
        [stack removeLastObject];
        
        if (tmpNode.currentId) {
            if (type == TreeDataAll) {
                if (tmpDic!=dic) {
                    tmpNode.isExpand = YES;
                    [self.data addObject:tmpNode];
                }
            }else if (type == TreeDataExpandOrNotParent) {
                if (self.data ) {
                    if (!tmpNode.parentId) {
                        [self.data addObject:tmpNode];
                    }else if (([self.data indexOfObject:parentNode]!=NSNotFound)&&parentNode.isExpand){
                              [self.data  addObject:tmpNode];
                    }
                 }
            } 
        }
        for (NSInteger i = tmpNode.children.count - 1; i >= 0; i--) {
            [stack addObject:tmpNode.children[i]];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.param.wEventCellHeight) {
        return self.param.wEventCellHeight(self.data[indexPath.row],indexPath,tableView);
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

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    WMZTreeParam *param = self.data[sourceIndexPath.row];
    WMZTreeParam *toParam = self.data[destinationIndexPath.row];
    if (param.parentId) {
        WMZTreeParam *parent = self.dic[param.parentId];
        [parent.children removeObject:param];
    }
    
    param.parentId = toParam.parentId;
    param.depath = toParam.depath;
    param.isExpand = NO;
    if (toParam.parentId) {
        WMZTreeParam *parent = self.dic[toParam.parentId];
        NSInteger index = [parent.children indexOfObject:toParam];
        [parent.children insertObject:param atIndex:index];
    }
    [self.data removeObject:param];
    [self.data insertObject:param atIndex:destinationIndexPath.row];
    
    [tableView reloadData];
    
    if (self.param.wEventNodeDraggable) {
        self.param.wEventNodeDraggable(sourceIndexPath, destinationIndexPath, tableView);
    }
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    //目前只支持没有子集的可以拖拽
    WMZTreeParam *param = self.data[indexPath.row];
    if (param.children.count>0) {
        return NO;
    }
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.param.wEventTreeCell) {
        WMZTreeCustomCell *cell = (WMZTreeCustomCell*)self.param.wEventTreeCell(self.data[indexPath.row],indexPath,tableView,self.param);
        cell.delagete = self;
        return cell;
    }else{
        WMZTreeCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WMZTreeCustomCell class])];
        if (!cell) {
            cell = [[WMZTreeCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([WMZTreeCustomCell class]) parentModel:self.param];
        }
        cell.delagete = self;
        cell.model = self.data[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WMZTreeParam *param = self.data[indexPath.row];
    param.isExpand = !param.isExpand;
    if (param.children.count) {
        if (param.isExpand) {
            NSMutableArray *insetArr = [self getSonData:param type:TreeDataInsert];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, insetArr.count)];
            [self.data insertObjects:insetArr atIndexes:indexSet];
        }else{
            NSArray *arr = [self getSonData:param type:TreeDataDelete];
            [self.data removeObjectsInArray:arr];
        }
    }
    else{
        param.isExpand = NO;
    }
    
    
    //手风琴效果
    if (self.param.wAccordion&&param.isExpand) {
        WMZTreeParam *parentModel =  param.parentId?(self.dic[param.parentId]):self.tree;
        for (WMZTreeParam *model in parentModel.children) {
            if (!model.isExpand||model == param) continue;
            if (model.isExpand) {
                model.isExpand = NO;
                [self.data removeObjectsInArray:[self getSonData:model type:TreeDataDelete]];
            }
       }
    }
    //设计数据过多 全局刷新
    [self.table reloadData];
    
    if (self.param.wEventNodeClick) {
        self.param.wEventNodeClick(param);
    }
}



#pragma WMZtreeCellDelagete
- (void)selectNode:(WMZTreeParam *)param checkStrictly:(BOOL)checkStrictly{
    [self setSelectNodeParentAndSonNodeStatus:param checkStrictly:checkStrictly reload:YES];
    if (self.param.wEventCheckChange) {
        self.param.wEventCheckChange(param,param.isSelected);
    }
}

- (void)userWithNode:(WMZTreeParam *)param param:(id)data cell:(id)cell{
    if (self.param.wEventCellUserEnabled) {
        self.param.wEventCellUserEnabled(param, [self.table indexPathForCell:cell], self.table,data);
    }
}
/*
 *关联所有父级和所有子级
 */
- (void)setSelectNodeParentAndSonNodeStatus:(WMZTreeParam *)param checkStrictly:(BOOL)checkStrictly reload:(BOOL)reload{
    if (checkStrictly) {
          //关联上级
          NSArray *parentNode = nil;
          if (param.parentId) {
              parentNode = [self searchAllParentNode:param];
          }
            
          //关联下级
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

/*
 *更新或者设置子节点数组
 */
- (BOOL)updateKeyChildren:(NSString*)currrentID data:(NSArray*)data{
    
    if (!currrentID) {
        NSLog(@"节点id不能为空");return NO;
    }
    
    if (currrentID&&currrentID.length) {
        WMZTreeParam *currentParam = self.dic[currrentID];
        
        //删除旧的
        NSArray *arr = [self getSonData:currentParam type:999];
        for (WMZTreeParam *param in arr) {
            if ([self.data indexOfObject:param]!=NSNotFound) {
                [self.data removeObject:param];
            }
            [self.dic removeObjectForKey:param.currentId];
        }
        
        //替换新的
        currentParam.children = [NSMutableArray arrayWithArray:data];
        for (WMZTreeParam *param in data) {
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

/*
 *获取当前选中的节点数组
 */
- (NSArray*)getCheckedNodesWithHalfSelect:(BOOL)halfSelect{
    NSMutableArray *checkArr = [NSMutableArray new];
    for (WMZTreeParam *param in self.data) {
        if (param.isSelected&&param.canSelect) {
            [checkArr addObject:param];
        }else{
            if (halfSelect&&param.halfSelect&&param.canSelect) {
                [checkArr addObject:param];
            }
        }
    }
    return [NSArray arrayWithArray:checkArr];
}

/*
 *为 Tree 中的一个节点追加一个子节点
 */
- (BOOL)append:(NSString*)currrentID node:(WMZTreeParam*)param{
    BOOL success = NO;
    if (!currrentID) {
        NSLog(@"节点id不能为空");return NO;
    }
    if (!param||![param isKindOfClass:[WMZTreeParam class]]) {
        NSLog(@"子节点错误");return NO;
    }
    if ([self.dic objectForKey:param.currentId]) {
        NSLog(@"要添加的节点已存在");return NO;
    }
    WMZTreeParam *parent = self.dic[currrentID];
    param.depath = parent.depath+1;
    NSArray *parentExpandArr =  [self getSonData:parent type:TreeDataInsert];
    [parent.children addObject:param];
    [self.dic setObject:param forKey:param.currentId];
    NSArray *arr =  [self getSonData:param type:TreeDataAllWithSelf];
    NSInteger index = [self.data indexOfObject:parent];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index+ parentExpandArr.count + 1, arr.count)];
    [self.data insertObjects:arr atIndexes:indexSet];
    [self.table reloadData];
    return success;
}

/*
 *删除节点
 */
- (BOOL)remove:(NSString*)currrentID{
    if (!currrentID) {
        NSLog(@"节点id不能为空");return NO;
    }
    BOOL success = NO;
    WMZTreeParam *parent = self.dic[currrentID];
    if (!parent) {
        NSLog(@"节点不存在");return NO;
    }
    //删除自身
    if ([self.dic valueForKey:parent.currentId]) {
        [self.dic removeObjectForKey:parent.currentId];
         success = YES;
    }
    if ([self.data indexOfObject:parent]!=NSNotFound) {
        [self.data removeObject:parent];
        success = YES;
    }
    if (parent.parentId) {
        WMZTreeParam *parentNode = self.dic[parent.parentId];
        [parentNode.children removeObject:parent];
    }
    
    //删除子节点
    NSArray *parentExpandArr =  [self getSonData:parent type:TreeDataDelete];
    for (WMZTreeParam *param in parentExpandArr) {
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

/*
 *为 Tree 的一个节点的前面增加一个节点
 */
- (BOOL)insertBefore:(NSString*)currrentID node:(WMZTreeParam*)param{
    if (!currrentID) {
        NSLog(@"节点id不能为空");return NO;
    }
    if (!param||![param isKindOfClass:[WMZTreeParam class]]) {
        NSLog(@"追加的节点错误");return NO;
    }
    if ([self.dic objectForKey:param.currentId]) {
        NSLog(@"要添加的节点已存在");return NO;
    }
    BOOL success = NO;
    WMZTreeParam *node = self.dic[currrentID];
    param.depath = node.depath;
    [self.dic setObject:param forKey:param.currentId];
    NSInteger index = [self.data indexOfObject:node];
    if (!node.parentId) {
        NSInteger sonIndex= [self.tree.children indexOfObject:node];
        [self.tree.children insertObject:param atIndex:sonIndex];
    }else{
        WMZTreeParam *parentNode = self.dic[node.parentId];
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

/*
 *为 Tree 的一个节点的后面增加一个节点
 */
- (BOOL)insertAfter:(NSString*)currrentID node:(WMZTreeParam*)param{
    if (!currrentID) {
        NSLog(@"节点id不能为空");return NO;
    }
    if (!param||![param isKindOfClass:[WMZTreeParam class]]) {
        NSLog(@"追加的节点错误");return NO;
    }
    if ([self.dic objectForKey:param.currentId]) {
        NSLog(@"要添加的节点已存在");return NO;
    }
   BOOL success = NO;
   WMZTreeParam *node = self.dic[currrentID];
   param.depath = node.depath;
   [self.dic setObject:param forKey:param.currentId];
   NSArray *parentExpandArr =  [self getSonData:node type:TreeDataInsert];
   NSInteger index = [self.data indexOfObject:node];
   if (!node.parentId) {
       [self.tree.children addObject:param];
   }else{
       WMZTreeParam *parentNode = self.dic[node.parentId];
       [parentNode.children addObject:param];
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


/*
*获取父节点
*/
- (WMZTreeParam*)getParentId:(NSString*)currrentID{
    WMZTreeParam *node = self.dic[currrentID];
    return self.dic[node.parentId];
}


/*
*更新数据
*/
- (void)update{
    [self setUp];
    [self.table reloadData];
}

@end

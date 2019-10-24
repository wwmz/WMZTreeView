//
//  WMZTreeParam.m
//  WMZTree
//
//  Created by wmz on 2019/10/17.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZTreeParam.h"

@implementation WMZTreeParam

WMZTreePropSetFuncImplementation(WMZTreeParam, BOOL,                    canSelect)
WMZTreePropSetFuncImplementation(WMZTreeParam, BOOL,                    isSelected)
WMZTreePropSetFuncImplementation(WMZTreeParam, BOOL,                    isExpand)
WMZTreePropSetFuncImplementation(WMZTreeParam, NSString*,               currentId)
WMZTreePropSetFuncImplementation(WMZTreeParam, NSString*,               parentId)
WMZTreePropSetFuncImplementation(WMZTreeParam, NSString*,               name)
WMZTreePropSetFuncImplementation(WMZTreeParam, id,                      data)
- (instancetype)init{
    if (self = [super init]) {
        _canSelect = YES;
    }
    return self;
}

WMZTreeParam * TreeParam(void){
    return  [WMZTreeParam new];
}

-(NSMutableArray<WMZTreeParam *> *)children{
    if (!_children) {
        _children =[NSMutableArray new];
    }
    return _children;
}

-  (NSString *)description{
    return [NSString stringWithFormat:@"currentID %@ parentId %@ isExpand %d isSelect %d isHalf %d ",self.currentId,self.parentId, self.isExpand,self.isSelected,self.halfSelect];
}
@end

//
//  WMZTreeParam.m
//  WMZTree
//
//  Created by wmz on 2019/10/17.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZTreeParam.h"

@implementation WMZTreeParam
@synthesize canSelect = _canSelect;
@synthesize isExpand = _isExpand;
@synthesize name = _name;
@synthesize data = _data;
@synthesize currentId = _currentId;
@synthesize parentId = _parentId;
@synthesize children = _children;
@synthesize depath = _depath;
@synthesize halfSelect = _halfSelect;
@synthesize isSelected = _isSelected;
@synthesize isTempSelected = _isTempSelected;
@synthesize tempHalfSelect = _tempHalfSelect;

- (instancetype)initWithName:(NSString*)name currentId:(NSString*)currentId parentId:(nullable NSString*)parentId{
  return [self initWithName:name currentId:currentId parentId:parentId canSelect:YES];
}

- (instancetype)initWithName:(NSString*)name currentId:(NSString*)currentId parentId:(nullable NSString*)parentId canSelect:(BOOL)canSelect{
    if(self = [super init]){
        self.name = name;
        self.currentId = currentId;
        self.parentId = parentId;
        self.canSelect = parentId;
    }
    return self;
}

+ (WMZTreeParam*)initWithName:(NSString*)name currentId:(NSString*)currentId parentId:(nullable NSString*)parentId{
    return [[self alloc] initWithName:name currentId:currentId parentId:parentId];
}

+ (WMZTreeParam *)initWithName:(NSString *)name currentId:(NSString *)currentId parentId:(NSString *)parentId canSelect:(BOOL)canSelect{
    return [[self alloc] initWithName:name currentId:currentId parentId:parentId canSelect:canSelect];
}

- (instancetype)init{
    if (self = [super init]) {
        _canSelect = YES;
    }
    return self;
}

WMZTreeParam * TreeParam(void){
    return  [WMZTreeParam new];
}

- (NSMutableArray<NSObject<WMZTreeProcotol> *> *)children{
    if (!_children) {
        _children = [NSMutableArray new];
    }
    return _children;
}

@end

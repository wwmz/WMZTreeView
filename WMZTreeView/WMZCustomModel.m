//
//  WMZCustomModel.m
//  WMZTreeView
//
//  Created by wmz on 2022/10/12.
//  Copyright © 2022 wmz. All rights reserved.
//

#import "WMZCustomModel.h"

@implementation WMZCustomModel
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
@end

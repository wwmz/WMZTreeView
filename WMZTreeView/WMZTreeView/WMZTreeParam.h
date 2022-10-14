//
//  WMZTreeParam.h
//  WMZTree
//
//  Created by wmz on 2019/10/17.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZTreeProcotol.h"
NS_ASSUME_NONNULL_BEGIN

@interface WMZTreeParam : NSObject<WMZTreeProcotol>

WMZTreeParam * TreeParam(void);
///初始化方法
- (instancetype)initWithName:(NSString*)name currentId:(NSString*)currentId parentId:(nullable NSString*)parentId;

- (instancetype)initWithName:(NSString*)name currentId:(NSString*)currentId parentId:(nullable NSString*)parentId canSelect:(BOOL)canSelect;

+ (WMZTreeParam*)initWithName:(NSString*)name currentId:(NSString*)currentId parentId:(nullable NSString*)parentId;

+ (WMZTreeParam*)initWithName:(NSString*)name currentId:(NSString*)currentId parentId:(nullable NSString*)parentId canSelect:(BOOL)canSelect;
@end

NS_ASSUME_NONNULL_END

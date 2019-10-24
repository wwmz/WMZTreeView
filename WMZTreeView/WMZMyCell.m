





//
//  WMZMyCell.m
//  WMZTree
//
//  Created by wmz on 2019/10/22.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZMyCell.h"
@interface WMZMyCell()
@property(nonatomic,strong)UIButton *add;
@property(nonatomic,strong)UIButton *delete;
@end
@implementation WMZMyCell

- (void)layoutSubviews{
    [super layoutSubviews];
    //布局
    CGFloat offset = 10;
    CGFloat height = self.contentView.frame.size.height;
    self.la.frame = CGRectMake(CGRectGetMaxX(self.icon.frame),offset , 80, height-offset*2);
    self.add.frame = CGRectMake(CGRectGetMaxX(self.la.frame)+offset, offset, 60, height-offset*2);
    self.delete.frame = CGRectMake(CGRectGetMaxX(self.add.frame)+offset, offset, 60, height-offset*2);
}

- (void)UI{
    //继承父类的UI
    [super UI];
    [self.contentView addSubview:self.add];
    [self.contentView addSubview:self.delete];
    [self.add setTitle:@"append" forState:UIControlStateNormal];
    [self.delete setTitle:@"delete" forState:UIControlStateNormal];
    self.add.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.delete.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.add setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.delete setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.add addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [self.delete addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addAction{
    //回调代理
    if (self.delagete&&[self.delagete respondsToSelector:@selector(userWithNode:param:cell:)]) {
        [self.delagete userWithNode:self.model param:@"add" cell:self];
    }
}

- (void)deleteAction{
    if (self.delagete&&[self.delagete respondsToSelector:@selector(userWithNode:param:cell:)]) {
        [self.delagete userWithNode:self.model param:@"delete" cell:self];
    }
}

- (UIButton *)add{
    if (!_add) {
        _add = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _add;
}

- (UIButton *)delete{
    if (!_delete) {
        _delete = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _delete;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

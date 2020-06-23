
//
//  WMZTreeCustomCell.m
//  WMZTree
//
//  Created by wmz on 2019/10/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZTreeCustomCell.h"
#define treeIconWidth 18
@interface WMZTreeCustomCell()
@end
@implementation WMZTreeCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier parentModel:(WMZTreeViewParam*)parentModel{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.parentModel = parentModel;
        [self UI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat offset = 10;
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = self.contentView.frame.size.height;
    
    CGRect rect = CGRectMake(self.model.depath<=1?offset:(offset*self.parentModel.wIndent*(self.model.depath-1)), (height-18)/2, [self.icon isHidden]?treeIconWidth:treeIconWidth, treeIconWidth);
    if (self.parentModel.wDraggable) {
        rect.origin.x-=38;
       self.icon.frame = rect;
    }else{
       self.icon.frame = rect;
    }
    self.la.frame = CGRectMake(CGRectGetMaxX(self.icon.frame),offset , width-CGRectGetMaxX(self.icon.frame)-offset*2, height-offset*2);
    CGFloat iconHeight = 17;
    self.check.frame = CGRectMake(width-iconHeight-offset, (height-iconHeight)/2, iconHeight, iconHeight);
}

- (void)UI{
    
    self.icon.userInteractionEnabled = NO;
    [self.icon setImage:[self bundleImage:self.parentModel.wExpandIcon] forState:UIControlStateNormal];
    [self.icon setImage:[self bundleImage:self.parentModel.wSelectExpandIcon] forState:UIControlStateSelected];
    [self.contentView addSubview:self.icon];
    
    [self.check setImage:[self bundleImage:self.parentModel.wCheckIcon] forState:UIControlStateNormal];
    if (!self.parentModel.wCheckStrictly) {
        [self.check setImage:[self bundleImage:self.parentModel.wSelectCheckIcon] forState:UIControlStateSelected];
    }
    [self.check addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.check];
    
    self.la.textColor = self.parentModel.wNodeTextColor;
    self.la.font = [UIFont systemFontOfSize:self.parentModel.wNodeTextFont];
    [self.contentView addSubview:self.la];

}

- (void)setModel:(WMZTreeParam *)model{
    _model = model;
    self.la.text = model.name;
    self.check.selected = model.isSelected;
    self.icon.hidden =  !model.children.count?YES:(self.parentModel.wHideExpanIcon);
    
    if (self.parentModel.wHighlightCurrent&&model.canSelect&&self.parentModel.wShowCheckbox) {
        if (self.model.isSelected||self.model.halfSelect) {
            self.la.textColor = self.parentModel.wHighlightCurrent;
        }else{
            self.la.textColor = self.parentModel.wNodeTextColor;
        }
    }
    if (self.parentModel.wShowCheckbox) {
        self.check.hidden = !model.canSelect;
    }else{
        self.check.hidden = YES;
    }
    if (!self.icon.hidden) {
        self.icon.selected = model.isExpand;
    }
    
    
    if (self.model.halfSelect) {
        [self.check setImage:[self bundleImage:self.parentModel.wHalfSelectCheckIcon] forState:UIControlStateNormal];
        [self.check setImage:[self bundleImage:self.parentModel.wSelectCheckIcon] forState:UIControlStateSelected];
    }else{
        [self.check setImage:[self bundleImage:self.parentModel.wCheckIcon] forState:UIControlStateNormal];
        [self.check setImage:[self bundleImage:self.parentModel.wSelectCheckIcon] forState:UIControlStateSelected];
    }

}

- (void)checkAction:(UIButton*)btn{
    
    self.model.isSelected = !self.model.isSelected;
    if (self.delagete&&[self.delagete respondsToSelector:@selector(selectNode:checkStrictly:)]) {
        [self.delagete selectNode:self.model checkStrictly:self.parentModel.wCheckStrictly];
    }
    
    if (self.model.isSelected) {
        self.model.halfSelect = NO;
    }
    
    if (self.model.halfSelect) {
        [self.check setImage:[self bundleImage:self.parentModel.wHalfSelectCheckIcon] forState:UIControlStateNormal];
        [self.check setImage:[self bundleImage:self.parentModel.wSelectCheckIcon] forState:UIControlStateSelected];
    }else{
        [self.check setImage:[self bundleImage:self.parentModel.wCheckIcon] forState:UIControlStateNormal];
        [self.check setImage:[self bundleImage:self.parentModel.wSelectCheckIcon] forState:UIControlStateSelected];
    }
    btn.selected = ![btn isSelected];
}

- (UIImage*)bundleImage:(NSString*)name{
    
    
    NSBundle *bundle =  [NSBundle bundleWithPath:[[NSBundle bundleForClass:[WMZTreeCustomCell class]] pathForResource:@"WMZTreeView" ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:name ofType:@"png"];
    
    if (!path) {
        return [UIImage imageNamed:name];
    }else{
        return [UIImage imageWithContentsOfFile:path];
    }
}

- (UIButton *)icon{
    if (!_icon) {
        _icon = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _icon;
}

- (UILabel *)la{
    if (!_la) {
        _la = [UILabel new];
    }
    return _la;
}

- (UIButton *)check{
    if (!_check) {
        _check = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _check;
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

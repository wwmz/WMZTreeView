
//
//  DemoVC.m
//  WMZTree
//
//  Created by wmz on 2019/10/23.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "DemoVC.h"
#import "ViewController.h"
#import "WMZTreeConfig.h"
@interface DemoVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *ta;
@property(nonatomic,strong)NSArray *taData;
@end

@implementation DemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *ta = [[UITableView alloc]initWithFrame:CGRectMake(0, 88, self.view.frame.size.width,self.view.frame.size.height-88) style:UITableViewStyleGrouped];
    [self.view addSubview:ta];
    if (@available(iOS 11.0, *)) {
        ta.estimatedRowHeight = 0.01;
        ta.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    ta.estimatedRowHeight = 0.01;
    ta.dataSource = self;
    ta.delegate = self;
    self.ta = ta;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.taData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = self.taData[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ViewController *vc = [ViewController new];
    vc.type = indexPath.row+1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)taData{
    if (!_taData) {
        _taData = @[@"正常多叉树显示",@"可选中树形+选中高亮显示",@"自定义节点内容+增删节点",@"手风琴效果+指定层级可勾选 ",@"勾选不关联父节点和子节点+默认选中+默认全部展开",@"开启拖拽 ",@"传字典数据",@"传实现协议的数据"];
    }
    return _taData;
}

@end


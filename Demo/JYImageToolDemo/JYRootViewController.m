//
//  JYRootViewController.m
//  JYImageToolDemo
//
//  Created by 杨权 on 16/3/25.
//  Copyright © 2016年 Job-Yang. All rights reserved.
//

#import "JYRootViewController.h"

@interface JYRootViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *classNames;

@end

@implementation JYRootViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JYImageTool";
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    [self addCell:@"提取主色" class:@"JYMainColourViewController"];
    [self addCell:@"提取指定点颜色" class:@"JYGetColourViewController"];
    [self addCell:@"相同判断" class:@"JYEqualImageViewController"];
    [self addCell:@"生成二维码" class:@"JYQRCodeViewController"];
    [self addCell:@"图像压缩" class:@"JYCompressViewController"];
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

#pragma mark - setup methods
- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYImageTool"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JYImageTool"];
    }
    cell.textLabel.font = [UIFont fontWithName:@"GillSans-Italic" size:16.f];
    cell.textLabel.textColor = RGB(58,63,83);
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = self.titles[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

@end

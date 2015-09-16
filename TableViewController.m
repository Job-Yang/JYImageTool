//
//  TableViewController.m
//  YTZImageComparisonDemo
//
//  Created by 杨权 on 15/9/16.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.Arr = [NSArray arrayWithObjects:
                @"----------------功能选项----------------",
                @"1.提取主色",
                @"2.提取指定点颜色",
                @"3.相同相似判断", nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.Arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    cell.textLabel.text = self.Arr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
       [self performSegueWithIdentifier:@"GoOne" sender:self];
    }
    else if (indexPath.row == 2) {
       [self performSegueWithIdentifier:@"GoTwo" sender:self];
    }
    else if (indexPath.row == 3) {
       [self performSegueWithIdentifier:@"GoThree" sender:self];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

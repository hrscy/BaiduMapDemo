//
//  YMTableViewController.m
//  BaiduMapDemo
//
//  Created by 杨蒙 on 16/6/18.
//  Copyright © 2016年 hrscy. All rights reserved.
//

#import "YMTableViewController.h"
#import "YMMapViewController.h"

@interface YMTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation YMTableViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = @"百度地图";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        YMMapViewController *mapVC = [[YMMapViewController alloc] init];
        mapVC.navigationItem.title = @"百度地图";
        [self.navigationController pushViewController:mapVC animated:YES];
    }
}

@end

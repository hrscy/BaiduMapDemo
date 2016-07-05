//
//  YMTableViewController.m
//  BaiduMapDemo
//
//  Created by 杨蒙 on 16/6/18.
//  Copyright © 2016年 hrscy. All rights reserved.
//

#import "YMTableViewController.h"
#import "YMMapViewController.h"
#import "YMAnnotationView.h"
#import "YMAnnotationViewController.h"
#import "YMAnnotationController.h"

@interface YMTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation YMTableViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"1.百度地图&路径规划";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"2.自定义标注的拖动";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"3.大头针的拖动";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        YMMapViewController *mapVC = [[YMMapViewController alloc] init];
        mapVC.navigationItem.title = @"1.百度地图&路径规划";
        [self.navigationController pushViewController:mapVC animated:YES];
    } else if (indexPath.row == 1) {
        YMAnnotationViewController *annotationVC = [[YMAnnotationViewController alloc] init];
        annotationVC.title = @"2.自定义标注的拖动";
        [self.navigationController pushViewController:annotationVC animated:YES];
    } else if (indexPath.row == 2) {
        YMAnnotationController *annotationVC = [[YMAnnotationController alloc] init];
        annotationVC.title = @"3.大头针的拖动";
        [self.navigationController pushViewController:annotationVC animated:YES];
    }
}

@end

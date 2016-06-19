//
//  YMPoiDetailViewController.m
//  BaiduMapDemo
//
//  Created by 杨蒙 on 16/6/19.
//  Copyright © 2016年 hrscy. All rights reserved.
//

#import "YMPoiDetailViewController.h"
#import "YMPoi.h"
#import "YMRouteAnnotationController.h"


@interface YMPoiDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *areaNameLabel;

@end

@implementation YMPoiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text = self.poi.name;
    self.areaNameLabel.text = self.poi.areaName;
    
}

- (IBAction)buttonClick:(UIButton *)sender {
    YMRouteAnnotationController *routationVC = [[YMRouteAnnotationController alloc] init];
    routationVC.poi = self.poi;
    routationVC.city = self.city;
    routationVC.userLocation = self.userLocation;
    [self presentViewController:routationVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

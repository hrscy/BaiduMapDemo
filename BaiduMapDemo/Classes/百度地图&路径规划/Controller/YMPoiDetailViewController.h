//
//  YMPoiDetailViewController.h
//  BaiduMapDemo
//
//  Created by 杨蒙 on 16/6/19.
//  Copyright © 2016年 hrscy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKUserLocation.h>
@class YMPoi;

@interface YMPoiDetailViewController : UIViewController

/** poi*/
@property (nonatomic, strong) YMPoi *poi;
/** 当前城市*/
@property (nonatomic, copy) NSString *city;
/** 用户当前位置*/
@property (nonatomic, strong) BMKUserLocation *userLocation;

@end

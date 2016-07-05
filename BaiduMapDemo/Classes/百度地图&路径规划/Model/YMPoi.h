//
//  YMPoi.h
//  BaiduMapDemo
//
//  Created by 杨蒙 on 16/6/19.
//  Copyright © 2016年 hrscy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMPoi : NSObject

/** 地区名称*/
@property (nonatomic, copy) NSString *areaName;
/** 平均价格*/
@property (nonatomic, copy) NSString *avgPrice;
/** 评分*/
@property (nonatomic, copy) NSString *avgScore;
/** 标签*/
@property (nonatomic, copy) NSString *campaignTag;
/** */
@property (nonatomic, copy) NSString *cateName;
/** */
@property (nonatomic, copy) NSString *channel;
/** */
@property (nonatomic, copy) NSString *frontImg;
/** 纬度*/
@property (nonatomic, assign) double lat;
/** 经度*/
@property (nonatomic, assign) double lng;
/** 店名*/
@property (nonatomic, copy) NSString *name;


@end

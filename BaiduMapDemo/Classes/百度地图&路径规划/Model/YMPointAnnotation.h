//
//  YMPointAnnotation.h
//  BaiduMapDemo
//
//  Created by 杨蒙 on 16/6/19.
//  Copyright © 2016年 hrscy. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
@class YMPoi;

@interface YMPointAnnotation : BMKPointAnnotation

/** poi*/
@property (nonatomic, strong) YMPoi *poi;
/** 标注点的protocol，提供了标注类的基本信息函数*/
@property (nonatomic, weak) id<BMKAnnotation> delegate;

@end

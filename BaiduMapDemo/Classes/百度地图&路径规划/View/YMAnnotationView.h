//
//  YMAnnotationView.h
//  BaiduMapDemo
//
//  Created by 杨蒙 on 16/6/19.
//  Copyright © 2016年 hrscy. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapView.h>

@interface YMAnnotationView : BMKAnnotationView

/** 泡泡*/
//@property (nonatomic, weak) HXDetailsView *calloutView;

//@property (nonatomic, strong)HXAnnotation *hxAnnotation;

/**
 *  创建方法
 *
 *  @param mapView 地图
 *
 *  @return 大头针
 */
+ (instancetype)annotationViewWithMap:(BMKMapView *)mapView withAnnotation:(id <BMKAnnotation>)annotation;

@end

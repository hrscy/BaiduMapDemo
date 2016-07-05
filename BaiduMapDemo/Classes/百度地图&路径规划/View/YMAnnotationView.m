//
//  YMAnnotationView.m
//  BaiduMapDemo
//
//  Created by 杨蒙 on 16/6/19.
//  Copyright © 2016年 hrscy. All rights reserved.
//

#import "YMAnnotationView.h"
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import "YMPointAnnotation.h"

@implementation YMAnnotationView

- (instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

+ (instancetype)annotationViewWithMap:(BMKMapView *)mapView withAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        static NSString *identifier = @"annotation";
        // 1.从缓存池中取
        YMAnnotationView *annoView = (YMAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        // 2.如果缓存池中没有, 创建一个新的
        if (annoView == nil) {
            annoView = [[YMAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        if ([annotation isKindOfClass:[YMPointAnnotation class]]) {
            annoView.annotation = (YMPointAnnotation *)annotation;
        }
        annoView.image = [UIImage imageNamed:@"annotion_icon"];
        return annoView;
    }
    return nil;
}

@end

//
//  YMAnnotationViewController.m
//  BaiduMapDemo
//
//  Created by 杨蒙 on 16/7/5.
//  Copyright © 2016年 hrscy. All rights reserved.
//

#import "YMAnnotationController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKAnnotationView.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import "YMPointAnnotation.h"
#import "YMAnnotationView.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface YMAnnotationController () <BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>{
    BMKMapView *_mapView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geoSearch;
}
/** 用户当前位置*/
@property(nonatomic , strong) BMKUserLocation *userLocation;

/** 大头针*/
@property (nonatomic, strong) BMKPointAnnotation *pointAnnotation;

@end

@implementation YMAnnotationController

-(void)viewDidLoad {
    [super viewDidLoad];
    /// 设置百度地图
    [self setupMapViewWithParam];
}

#pragma mark - 设置百度地图
-(void)setupMapViewWithParam {
    self.userLocation = [[BMKUserLocation alloc] init];
    _geoSearch = [[BMKGeoCodeSearch alloc] init];
    _locService = [[BMKLocationService alloc] init];
    _locService.distanceFilter = 200;//设定定位的最小更新距离，这里设置 200m 定位一次，频繁定位会增加耗电量
    _locService.desiredAccuracy = kCLLocationAccuracyHundredMeters;//设定定位精度
    //开启定位服务
    [_locService startUserLocationService];
    //初始化BMKMapView
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, SCREENH - 64)];
    _mapView.buildingsEnabled = YES;//设定地图是否现显示3D楼块效果
    _mapView.overlookEnabled = YES; //设定地图View能否支持俯仰角
    _mapView.showMapScaleBar = YES; // 设定是否显式比例尺
    _mapView.zoomLevel = 12;//设置放大级别
    [self.view addSubview:_mapView];
    
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    BMKLocationViewDisplayParam *userlocationStyle = [[BMKLocationViewDisplayParam alloc] init];
    userlocationStyle.isRotateAngleValid = YES;
    userlocationStyle.isAccuracyCircleShow = NO;
    
    [self setupAddButton];
}

#pragma mark 添加标注的按钮
-(void)setupAddButton {
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 80, 35)];
    [addButton setTitle:@"添加标注" forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor orangeColor];
    [addButton addTarget:self action:@selector(addPointAnnotation) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:addButton];
}

//添加标注
- (void)addPointAnnotation {
    if (self.pointAnnotation == nil) {
        self.pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = 39.915;
        coor.longitude = 116.404;
        self.pointAnnotation.coordinate = coor;
        self.pointAnnotation.title = @"test";
        self.pointAnnotation.subtitle = @"此Annotation可拖拽!";
        [_mapView addAnnotation:self.pointAnnotation];
    }
    self.pointAnnotation = self.pointAnnotation;
}

#pragma mark - BMKLocationServiceDelegate 用户位置更新后，会调用此函数
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [_mapView updateLocationData:userLocation];// 动态更新我的位置数据
    self.userLocation = userLocation;
    [_mapView setCenterCoordinate:userLocation.location.coordinate];// 当前地图的中心点
}

#pragma mark -BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
        // 创建大头针
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        // 设置颜色
        annotationView.pinColor = BMKPinAnnotationColorPurple;
        // 从天上掉下效果
        annotationView.animatesDrop = YES;
        // 设置可拖拽
        annotationView.draggable = YES;
        
        /**
         *  我打算在显示 annotationView 的时候，直接就可以实现拖动的效果，但是设置无效，所以改为选中的时候进行拖动，生效，见下面两个代理方法
         * - (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
         * - (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
         */
        //    annotationView.dragState = BMKAnnotationViewDragStateStarting; // 这句放到这里不起作用
        return annotationView;
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    // 当选中标注的之后，设置开始拖动状态
    view.dragState = BMKAnnotationViewDragStateStarting;
}

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)annotationView {
    // 取消选中标注后，停止拖动状态
    annotationView.dragState = BMKAnnotationViewDragStateEnding;
    // 设置转换的坐标会有一些偏差，具体可以再调节坐标的 (x, y) 值
    CGPoint dropPoint = CGPointMake(annotationView.center.x, CGRectGetMaxY(annotationView.frame));
    CLLocationCoordinate2D newCoordinate = [_mapView convertPoint:dropPoint toCoordinateFromView:annotationView.superview];
    [annotationView.annotation setCoordinate:newCoordinate];
    NSLog(@"新的坐标\n latitude = %f, longitude = %f", newCoordinate.latitude, newCoordinate.longitude);
    /// geo检索信息类,获取当前城市数据
    BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = newCoordinate;
    BOOL flag = [_geoSearch reverseGeoCode:reverseGeoCodeOption];
    if (flag) {
        NSLog(@"设置成功!");
    } else {
        NSLog(@"设置失败!");
    }
}

#pragma mark 根据坐标返回反地理编码搜索结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    BMKAddressComponent *addressComponent = result.addressDetail;
    NSString *title = [NSString stringWithFormat:@"%@%@%@%@%@", addressComponent.province, addressComponent.city, addressComponent.district, addressComponent.streetName, addressComponent.streetNumber];
    NSLog(@"%s -- %@", __func__, title);
}

/**
 *拖动annotation view时，若view的状态发生变化，会调用此函数。ios3.2以后支持
 *@param mapView 地图View
 *@param view annotation view
 *@param newState 新状态
 *@param oldState 旧状态
 */
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)annotationView didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState {
    // -------- 这个方法不起作用 -----------
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geoSearch.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geoSearch.delegate = self;
}

@end

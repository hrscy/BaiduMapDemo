//
//  YMAnnotationViewController.m
//  BaiduMapDemo
//
//  Created by 杨蒙 on 16/7/5.
//  Copyright © 2016年 hrscy. All rights reserved.
//

#import "YMAnnotationViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKAnnotationView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import "YMPointAnnotation.h"
#import "YMPaopaoView.h"
#import "SVProgressHUD.h"
#import "YMPoiDetailViewController.h"
#import "AFNetworking.h"
#import "YMPoi.h"
#import "MJExtension.h"
#import "YMAnnotationView.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface YMAnnotationViewController () <BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>{
    BMKMapView *_mapView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geoSearch;
}
/** 用户当前位置*/
@property(nonatomic , strong) BMKUserLocation *userLocation;

@end

@implementation YMAnnotationViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    /// 设置百度地图
    [self setupMapViewWithParam];
    
    [self loadMeituanData];
}

#pragma mark - 设置百度地图
-(void)setupMapViewWithParam {
    self.userLocation = [[BMKUserLocation alloc] init];
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
}

#pragma mark - 加载美图数据
-(void)loadMeituanData {
    NSString *urlString = @"http://api.meituan.com/meishi/filter/v4/deal/select/city/1/area/14/cate/1?__skua=58c45e3fe9ccacce6400c5a736b76480&userid=267752722&__vhost=api.meishi.meituan.com&movieBundleVersion=100&wifi-mac=8c%3Af2%3A28%3Afc%3A41%3A92&utm_term=6.5.1&limit=25&ci=1&__skcy=jyDTYwzfsbzflQbUtxRRR1RK2Ag%3D&__skts=1466298960.130064&sort=defaults&__skno=5210AD02-055C-47B7-BD23-A26EB36E2A20&wifi-name=MERCURY_4192&uuid=E158E8C43627D4B0B2BA94FC17DD78F08B7148D4A037A9933F3180FC1E550587&utm_content=E158E8C43627D4B0B2BA94FC17DD78F08B7148D4A037A9933F3180FC1E550587&utm_source=AppStore&version_name=6.5.1&mypos=38.300178%2C116.909954&utm_medium=iphone&wifi-strength=&wifi-cur=0&offset=0&poiFields=cityId%2Clng%2CfrontImg%2CavgPrice%2CavgScore%2Cname%2Clat%2CcateName%2CareaName%2CcampaignTag%2Cabstracts%2Crecommendation%2CpayInfo%2CpayAbstracts%2CqueueStatus&hasGroup=true&utm_campaign=AgroupBgroupD200Ghomepage_category1_1__a1&__skck=3c0cf64e4b039997339ed8fec4cddf05&msid=AE66B26D-47FB-4959-B3F3-FE25606FF0CB2016-06-19-09-1327";
    // 加载进度
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [[AFHTTPSessionManager manager] GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSArray *data = responseObject[@"data"];
        for (NSDictionary *dict in data) {
            NSDictionary *poiDict = dict[@"poi"];
            YMPoi *poi = [YMPoi mj_objectWithKeyValues:poiDict];
            YMPointAnnotation *annotation = [[YMPointAnnotation alloc] init];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(poi.lat, poi.lng);
            annotation.coordinate = coordinate;
            annotation.poi = poi;
            [_mapView addAnnotation:annotation];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
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
    YMAnnotationView *annotationView = [YMAnnotationView annotationViewWithMap:mapView withAnnotation:annotation];
    annotationView.draggable = YES;
    YMPaopaoView *paopaoView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YMPaopaoView class]) owner:nil options:nil] lastObject];
    YMPointAnnotation *anno = (YMPointAnnotation *)annotationView.annotation;
    paopaoView.poi = anno.poi;
    annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paopaoView];
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
    /// geo检索信息类,获取当前城市数据
    BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = newCoordinate;
    [_geoSearch reverseGeoCode:reverseGeoCodeOption];
}

#pragma mark 根据坐标返回反地理编码搜索结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    BMKAddressComponent *addressComponent = result.addressDetail;
    NSString *title = [NSString stringWithFormat:@"%@%@%@%@", addressComponent.city, addressComponent.district, addressComponent.streetName, addressComponent.streetNumber];
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

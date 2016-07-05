//
//  YMPaopaoView.h
//  BaiduMapDemo
//
//  Created by 杨蒙 on 16/6/19.
//  Copyright © 2016年 hrscy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMPoi, YMPaopaoView;

@protocol YMPaopaoViewDelagate <NSObject>

-(void)paopaoView:(YMPaopaoView *)paopapView coverButtonClickWithPoi:(YMPoi *)poi;

@end

@interface YMPaopaoView : UIView
/** poi*/
@property (nonatomic, strong) YMPoi *poi;

/** YMPaopaoViewDelagate*/
@property (nonatomic, weak) id<YMPaopaoViewDelagate> delegate;

@end

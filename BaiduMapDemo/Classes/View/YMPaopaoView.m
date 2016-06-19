//
//  YMPaopaoView.m
//  BaiduMapDemo
//
//  Created by 杨蒙 on 16/6/19.
//  Copyright © 2016年 hrscy. All rights reserved.
//

#import "YMPaopaoView.h"
#import "UIImageView+WebCache.h"
#import "YMPoi.h"

@interface YMPaopaoView ()

@property (weak, nonatomic) IBOutlet UIImageView *shopImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *areaNameLabel;

@end

@implementation YMPaopaoView

-(void)awakeFromNib {
    
}

-(void)setPoi:(YMPoi *)poi {
    _poi = poi;
    
    [self.shopImage sd_setImageWithURL:[NSURL URLWithString:poi.frontImg]];
    self.nameLabel.text = poi.name;
    self.areaNameLabel.text = poi.areaName;
}

- (IBAction)coverButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(paopaoView:coverButtonClickWithPoi:)]) {
        [self.delegate paopaoView:self coverButtonClickWithPoi:self.poi];
    }
}



@end

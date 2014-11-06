//
//  VORingProgressView.h
//  YCActivityIndicatorDemo
//
//  Created by Valo Lee on 14-11-6.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VORingProgressView : UIView
@property (nonatomic, copy  ) NSString        *centerText;
@property (nonatomic, strong) NSArray         *gradientColors;
@property (nonatomic, assign) CGFloat         progress;
@property (nonatomic, assign) CGFloat         animationDuration;

@property (nonatomic, strong) CAGradientLayer *ringMaskLayer;

+ (instancetype)ringProgressVIewWithFrame: (CGRect)frame
							 andLineColor: (UIColor *)lineColor
						   andLineBgColor: (UIColor *)bgColor;


@end

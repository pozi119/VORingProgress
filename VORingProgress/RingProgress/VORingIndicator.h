//
//  VORingIndicator.h
//  YCActivityIndicatorDemo
//
//  Created by Valo Lee on 14-11-6.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VORingIndicator : UIView
@property (nonatomic, copy)   NSString        *centerText;
@property (nonatomic, strong) UILabel		  *centerLabel;

+ (instancetype)ringIndicatorWithFrame: (CGRect)frame
						  andLineColor: (UIColor *)lineColor
						andLineBgColor: (UIColor *)bgColor;

- (void)startAnimation;
- (void)stopAnimation;

@end

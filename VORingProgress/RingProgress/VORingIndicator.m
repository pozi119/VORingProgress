//
//  VORingIndicator.m
//  YCActivityIndicatorDemo
//
//  Created by Valo Lee on 14-11-6.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import "VORingIndicator.h"

@interface VORingIndicator ()

@property (nonatomic, assign) CGFloat         lineWidth;
@property (nonatomic, strong) UIColor         *lineBgColor;
@property (nonatomic, strong) UIColor         *lineColor;

@property (nonatomic, strong) CAShapeLayer    *ringBgLayer;
@property (nonatomic, strong) CALayer         *ringLayer;
@property (nonatomic, strong) CAGradientLayer *ringMaskLayer;
@property (nonatomic, strong) CAShapeLayer    *ringAnimLayer;

@end

@implementation VORingIndicator

+ (instancetype)ringIndicatorWithFrame: (CGRect)frame
						  andLineColor: (UIColor *)lineColor
						andLineBgColor: (UIColor *)lineBgColor{
	return [[VORingIndicator alloc] initWithFrame:frame andLineColor:lineColor andLineBgColor:lineBgColor];
}

- (instancetype)init{
	return [self initWithFrame:CGRectMake(0, 0, 20, 20) andLineColor:[UIColor redColor] andLineBgColor:[UIColor lightGrayColor]];
}

- (instancetype)initWithFrame:(CGRect)frame{
	return [self initWithFrame:frame andLineColor:[UIColor redColor] andLineBgColor:[UIColor lightGrayColor]];
}

- (instancetype)initWithFrame: (CGRect)frame
				 andLineColor: (UIColor *)lineColor
				   andLineBgColor: (UIColor *)lineBgColor{
	self = [super initWithFrame:frame];
	if (self) {
        CGFloat diameter = MIN(frame.size.width, frame.size.height);
        self.lineWidth   = diameter / 10;
        self.lineColor   = lineColor;
        self.lineBgColor = lineBgColor;
        self.bounds      = CGRectMake(0, 0, diameter, diameter);
        self.center      = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
		UILabel *label   = [[UILabel alloc] initWithFrame:CGRectMake(diameter * 0.2, diameter * 0.2, diameter * 0.6, diameter * 0.6)];
		label.textAlignment = NSTextAlignmentCenter;
		label.textColor = lineColor;
		label.font = [UIFont systemFontOfSize:diameter * 0.4];
		label.text = @"V";
		label.lineBreakMode = NSLineBreakByCharWrapping;
		[self addSubview:label];
		self.centerLabel = label;
		[self setupBackgroudLayer];
		[self setupAnimationLayer];
		[self startAnimation];
	}
	return self;
}

- (void)setCenterText:(NSString *)centerText{
	_centerText = centerText;
	self.centerLabel.text = centerText;
}

#pragma mark - 创建各种Layer

#pragma mark 背景圆环
- (void)setupBackgroudLayer{
    CAShapeLayer *ringBgLayer = [[CAShapeLayer alloc] initWithLayer:self.layer];
    ringBgLayer.bounds        = self.layer.bounds;
    ringBgLayer.position      = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	ringBgLayer.fillColor     = [UIColor clearColor].CGColor;
	ringBgLayer.lineWidth     = self.lineWidth;
	ringBgLayer.strokeColor   = [self.lineBgColor colorWithAlphaComponent: 0.2].CGColor;
    ringBgLayer.path          = [self layoutPathWithScale:1.0].CGPath;
    self.ringBgLayer          = ringBgLayer;
	[self.layer addSublayer:self.ringBgLayer];

}

#pragma mark 进度圆弧
- (void)setupAnimationLayer{
    CAShapeLayer *arcLayer         = [[CAShapeLayer alloc] initWithLayer:self.layer];
    arcLayer.bounds                = self.layer.bounds;
    arcLayer.position              = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    arcLayer.fillColor             = [UIColor clearColor].CGColor;
    arcLayer.lineWidth             = self.lineWidth;
	arcLayer.lineCap               = @"round";
    arcLayer.strokeColor           = self.lineColor.CGColor;
    arcLayer.path                  = [self layoutPathWithScale:0.25].CGPath;
    self.ringAnimLayer              = arcLayer;

    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] initWithLayer:self.layer];
    gradientLayer.bounds           = self.layer.bounds;
    gradientLayer.position         = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    gradientLayer.colors           = [VORingIndicator gradientColorArrayWithColor:self.lineColor];
    gradientLayer.locations        = @[@(0), @(1)];
    gradientLayer.startPoint       = CGPointMake(0.5, 0);
    gradientLayer.endPoint         = CGPointMake(1, 0.5);
    self.ringMaskLayer             = gradientLayer;
	
    CALayer *ringLayer             = [[CALayer alloc] initWithLayer:self.layer];
    ringLayer.bounds               = self.layer.bounds;
    ringLayer.position             = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.ringLayer                 = ringLayer;
	
	[self.ringMaskLayer setMask:self.ringAnimLayer];
	[self.ringLayer addSublayer:self.ringMaskLayer];
	[self.layer addSublayer:self.ringLayer];
}

- (UIBezierPath *)layoutPathWithScale: (CGFloat)scale {
	const double TWO_M_PI   = 2.0 * M_PI;
	const double startAngle = 0.75 * TWO_M_PI;
	const double endAngle   = startAngle +scale * TWO_M_PI;
	CGFloat width           = self.frame.size.width;
	
	return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2, width / 2)
										  radius:width /2 - self.lineWidth
									  startAngle:startAngle
										endAngle:endAngle
									   clockwise:YES];
}

- (void)startAnimation {
	CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
	anim.keyPath = @"transform";
	NSValue *val1 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0 * M_PI, 0, 0, 1)];
	NSValue *val2 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.5 * M_PI, 0, 0, 1)];
	NSValue *val3 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1.0 * M_PI, 0, 0, 1)];
	NSValue *val4 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1.5 * M_PI, 0, 0, 1)];
	NSValue *val5 = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(2.0 * M_PI, 0, 0, 1)];
	anim.values = @[val1, val2, val3, val4, val5];
	anim.duration = 1.0;
	anim.removedOnCompletion = NO;
	anim.fillMode = kCAFillModeForwards;
	anim.repeatCount = MAXFLOAT;
	anim.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	[self.ringLayer addAnimation:anim forKey:@"ringLayerAnimation"];
}

- (void)stopAnimation{
	[self.ringLayer removeAnimationForKey:@"ringLayerAnimation"];
}

+ (NSArray *)gradientColorArrayWithColor: (UIColor *)color{
	if (!color) {
		return nil;
	}
	return @[(id)[color colorWithAlphaComponent:0.0].CGColor, (id)[color colorWithAlphaComponent:0.9].CGColor, (id)[color colorWithAlphaComponent:1.0].CGColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

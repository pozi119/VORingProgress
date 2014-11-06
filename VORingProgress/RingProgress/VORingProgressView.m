//
//  VORingProgressView.m
//  YCActivityIndicatorDemo
//
//  Created by Valo Lee on 14-11-6.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import "VORingProgressView.h"
#import <CoreText/CoreText.h>
NSString * const VORingProgressRingAnimationKey = @"VORingProgressRingAnimationKey";
NSString * const VORingProgressTextAnimationKey = @"VORingProgressTextAnimationKey";

@interface VORingProgressView ()
@property (nonatomic, assign) CGFloat         lineWidth;
@property (nonatomic, strong) UIColor         *lineBgColor;
@property (nonatomic, strong) UIColor         *lineColor;

@property (nonatomic, strong) CAShapeLayer    *ringBgLayer;
@property (nonatomic, strong) CALayer         *ringLayer;
@property (nonatomic, strong) CAShapeLayer    *ringAnimLayer;

@property (nonatomic, strong) CAShapeLayer    *textBgLayer;
@property (nonatomic, strong) CAShapeLayer    *textAnimLayer;

@end

@implementation VORingProgressView
+ (instancetype)ringProgressVIewWithFrame: (CGRect)frame
							 andLineColor: (UIColor *)lineColor
						   andLineBgColor: (UIColor *)lineBgColor{
	return [[VORingProgressView alloc] initWithFrame:frame andLineColor:lineColor andLineBgColor:lineBgColor];
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
		self.centerText  = @"V";
		self.bounds      = CGRectMake(0, 0, diameter, diameter);
		self.center      = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
		[self setupRingAnimationLayer];
		[self setupTextAnimationLayer];
		self. animationDuration = 0.2;
		[self updatePath:0.0];
	}
	return self;
}

#pragma mark - 创建各种Layer
#pragma mark 进度圆弧
- (void)setupRingAnimationLayer{
	UIBezierPath *path = [self layoutPath];
	
	CAShapeLayer *ringBgLayer = [[CAShapeLayer alloc] initWithLayer:self.layer];
	ringBgLayer.bounds        = self.layer.bounds;
	ringBgLayer.position      = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	ringBgLayer.fillColor     = [UIColor clearColor].CGColor;
	ringBgLayer.lineWidth     = self.lineWidth;
	ringBgLayer.strokeColor   = [self.lineBgColor colorWithAlphaComponent: 0.2].CGColor;
	ringBgLayer.path          = path.CGPath;
	self.ringBgLayer          = ringBgLayer;
	[self.layer addSublayer:self.ringBgLayer];

	CAShapeLayer *arcLayer         = [[CAShapeLayer alloc] initWithLayer:self.layer];
	arcLayer.bounds                = self.layer.bounds;
	arcLayer.position              = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	arcLayer.fillColor             = [UIColor clearColor].CGColor;
	arcLayer.lineWidth             = self.lineWidth;
	arcLayer.lineCap               = @"round";
	arcLayer.strokeColor           = self.lineColor.CGColor;
	arcLayer.path                  = path.CGPath;
	self.ringAnimLayer              = arcLayer;
	
	CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] initWithLayer:self.layer];
	gradientLayer.bounds           = self.layer.bounds;
	gradientLayer.position         = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	gradientLayer.colors           = [VORingProgressView gradientColorArrayWithColor:@[self.lineBgColor, self.lineColor, self.lineBgColor]];
	gradientLayer.locations        = @[@(0), @(0.5), @(1)];
	gradientLayer.startPoint       = CGPointMake(0, 0);
	gradientLayer.endPoint         = CGPointMake(1, 1);
	self.ringMaskLayer             = gradientLayer;
	
	CALayer *ringLayer             = [[CALayer alloc] initWithLayer:self.layer];
	ringLayer.bounds               = self.layer.bounds;
	ringLayer.position             = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	self.ringLayer                 = ringLayer;
	
	[self.ringMaskLayer setMask:self.ringAnimLayer];
	[self.ringLayer addSublayer:self.ringMaskLayer];
	[self.layer addSublayer:self.ringLayer];
}

#pragma mark 进度文字
- (void)setupTextAnimationLayer{
	NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.centerText];
	[text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.bounds.size.width * 0.4] range:NSMakeRange(0, text.length)];
	UIBezierPath *path = [VORingProgressView pathRefFromText: text reversed:YES];
	CGPoint position  = CGPointMake(CGRectGetMaxX(self.bounds) - CGRectGetMidX(path.bounds), CGRectGetMaxY(self.bounds)- CGRectGetMidY(path.bounds));
	
	CAShapeLayer *textBgLayer = [[CAShapeLayer alloc] initWithLayer:self.layer];
	textBgLayer.bounds        = self.layer.bounds;
	textBgLayer.position      = position;
	textBgLayer.fillColor     = [UIColor clearColor].CGColor;
	textBgLayer.lineWidth     = self.lineWidth / 6;
	textBgLayer.strokeColor   = self.lineBgColor.CGColor;
	textBgLayer.path          = path.CGPath;
	self.textBgLayer          = textBgLayer;
	[self.layer addSublayer:self.textBgLayer];

	CAShapeLayer *textAnimLayer = [[CAShapeLayer alloc] initWithLayer:self.layer];
    textAnimLayer.bounds        = self.layer.bounds;
    textAnimLayer.position      = position;
    textAnimLayer.fillColor     = [UIColor clearColor].CGColor;
    textAnimLayer.lineWidth     = self.lineWidth / 6;
    textAnimLayer.strokeColor   = self.lineColor.CGColor;
    textAnimLayer.path          = path.CGPath;
    self.textAnimLayer          = textAnimLayer;
	[self.layer addSublayer:self.textAnimLayer];
}

- (UIBezierPath *)layoutPath{
	const double TWO_M_PI   = 2.0 * M_PI;
	const double startAngle = 0.75 * TWO_M_PI;
	const double endAngle   = startAngle + TWO_M_PI;
	CGFloat width           = self.frame.size.width;
	
	return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2, width / 2)
										  radius:width / 2 - self.lineWidth
									  startAngle:startAngle
										endAngle:endAngle
									   clockwise:YES];
}

- (void)setProgress:(CGFloat)progress{
	progress = MAX(MIN(progress, 1.0), 0.0); // keep it between 0 and 1
	if (_progress == progress) {
		return;
	}
	[self animateToProgress:progress];
	[self updatePath:progress];
	_progress = progress;
}
- (void)setAnimationDuration:(CGFloat)animationDuration{
	animationDuration = MAX(animationDuration, 0.2);
	_animationDuration = animationDuration;
}

- (void)animateToProgress:(float)progress {
	[self stopAnimation];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration          = self.animationDuration;
    animation.fromValue         = @(self.progress);
    animation.toValue           = @(progress);
    animation.delegate          = self;
	[self.ringAnimLayer addAnimation:animation forKey:VORingProgressRingAnimationKey];
	[self.textAnimLayer addAnimation:animation forKey:VORingProgressTextAnimationKey];
	_progress = progress;
}

- (void)updatePath:(float)progress {
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	self.ringAnimLayer.strokeEnd = progress;
	self.textAnimLayer.strokeEnd = progress;
	[CATransaction commit];
}

- (void)stopAnimation {
	[self.ringAnimLayer removeAnimationForKey:VORingProgressRingAnimationKey];
	[self.textAnimLayer removeAnimationForKey:VORingProgressTextAnimationKey];
}

- (void)setGradientColors:(NSArray *)gradientColors{
	_gradientColors = gradientColors;
	self.ringMaskLayer.colors = [VORingProgressView gradientColorArrayWithColor:gradientColors];
}

+ (NSArray *)gradientColorArrayWithColor: (NSArray *)colors{
	if (!colors) {
		return nil;
	}
	NSMutableArray *array = [NSMutableArray array];
	for (UIColor *color in colors) {
		[array addObject:(id)color.CGColor];
	}
	return array;
}


+ (UIBezierPath *)pathRefFromText: (NSAttributedString *)text reversed: (BOOL)reversed
{
    CGMutablePathRef letters = CGPathCreateMutable();
    CTLineRef line           = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)text);
    CFArrayRef runArray      = CTLineGetGlyphRuns(line);
	for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++){
        CTRunRef run      = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
		
		for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++){
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
			CGGlyph glyph;
			CGPoint position;
			CTRunGetGlyphs(run, thisGlyphRange, &glyph);
			CTRunGetPositions(run, thisGlyphRange, &position);

            CGPathRef letter       = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t    = CGAffineTransformMakeTranslation(position.x, position.y);
			CGPathAddPath(letters, &t, letter);
			CGPathRelease(letter);
		}
	}
	
	UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letters];
	CGRect boundingBox = CGPathGetBoundingBox(letters);
	CGPathRelease(letters);
	CFRelease(line);
	
	[path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
	[path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
	
	if (reversed) {
		return [path bezierPathByReversingPath] ;
	}
	return path;
}

@end

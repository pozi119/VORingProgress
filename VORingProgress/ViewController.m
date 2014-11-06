//
//  ViewController.m
//  VORingProgress
//
//  Created by Valo Lee on 14-11-6.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import "ViewController.h"
#import "VORingIndicator.h"
#import "VORingProgressView.h"

@interface ViewController ()
@property (nonatomic, strong) VORingIndicator    *ringIndicator;
@property (nonatomic, strong) VORingProgressView *progressView;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.ringIndicator = [[VORingIndicator alloc] initWithFrame:CGRectMake(40, 100, 100, 100)];
	self.ringIndicator.centerText = @"音";
	[self.view addSubview:self.ringIndicator];
	
	self.progressView = [[VORingProgressView alloc] initWithFrame: CGRectMake(40, 300, 200, 200)];
	self.progressView.animationDuration = 0.5;
	self.progressView.gradientColors = @[[UIColor redColor], [UIColor yellowColor], [UIColor greenColor], [UIColor greenColor], [UIColor cyanColor], [UIColor blueColor], [UIColor magentaColor]];
	[self.view addSubview:self.progressView];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)startAnimation:(id)sender {
	
	static BOOL animating = YES;
	if (animating) {
		[self.ringIndicator stopAnimation];
		animating = NO;
	}
	else{
		[self.ringIndicator startAnimation];
		animating = YES;
	}
}

- (IBAction)changeProgress:(UISlider *)sender {
	self.progressView.progress = sender.value;
}

@end

//
//  MSCameraViewController.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSCameraViewController.h"
#import "MSWindow.h"

@interface MSCameraViewController ()

@end

@implementation MSCameraViewController

#pragma mark - Lifecycle

- (instancetype)init {
	if (self = [super initWithNode:[ASDisplayNode new]]) {

	}

	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

#pragma mark - Override

- (BOOL)prefersStatusBarHidden {
	BOOL shouldHide = NO;
	[(MSWindow *)([UIApplication sharedApplication].keyWindow) hideStatusBarOverlay:shouldHide];

	return shouldHide;
}

@end

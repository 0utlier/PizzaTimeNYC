//
//  GIFPage.m
//  Pizza Time NYC
//
//  Created by JD Leonard on 1/30/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "GIFPage.h"
#import "MethodManager.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import "DAO.h"

@interface GIFPage ()

@property CGAffineTransform transform;
@property (strong, nonatomic) MethodManager *methodManager;
@property (strong, nonatomic) DAO *dao;
@property int gifCount;

@end

@implementation GIFPage

- (void)viewDidLoad {
	[super viewDidLoad];
	self.methodManager = [MethodManager sharedManager];
	self.dao = [DAO sharedDAO];
	// set animated view to square in middle of view
	FLAnimatedImageView *animatedImageView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width)/2 , self.view.bounds.size.width, self.view.bounds.size.width)];
	[self.view addSubview:animatedImageView];

	// set the rotation of the GIF
	self.transform = CGAffineTransformMakeRotation(M_PI_2); // 90 degrees EAST
	//Obtaining the current device orientation
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	//	NSLog(@"orienation = %ld", (long)orientation);
	if (orientation == UIDeviceOrientationLandscapeRight)
	{// code for RIGHT orientation
		self.transform = CGAffineTransformMakeRotation(M_PI_2 *3); // 90 degrees WEST
	}
	animatedImageView.transform = self.transform;
	// add to the count and mod by amount of array
	NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
	self.gifCount = (int)timeInMiliseconds;
	if (!self.dao.gifArray.count == 0) {
		self.gifCount = self.gifCount % self.dao.gifArray.count;
		animatedImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:[self.dao.gifArray objectAtIndex:self.gifCount]];
	}
	else { // empty array of GIFs
		UIAlertView *noInternet = [[UIAlertView alloc] initWithTitle:@"No connection to internet found"
															 message:@"Gifs are not updated"
															delegate:self.dao
												   cancelButtonTitle:@"OK"
												   otherButtonTitles: @"Try Again",nil];
		[noInternet show];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end

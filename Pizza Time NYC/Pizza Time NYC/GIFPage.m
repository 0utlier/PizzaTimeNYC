//
//  GIFPage.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/30/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "GIFPage.h"
#import "MethodManager.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
//#import <Parse/Parse.h>
#import "DAO.h"

@interface GIFPage ()

@property CGAffineTransform transform;
@property (strong, nonatomic) MethodManager *methodManager;
@property (strong, nonatomic) DAO *dao;

@end

@implementation GIFPage

- (void)viewDidLoad {
	[super viewDidLoad];
	self.methodManager = [MethodManager sharedManager];
	self.dao = [DAO sharedDAO];
	// removed 2.13.16 since gif now working well other places
	/*
	if (self.methodManager.gifCount == 0.0) { // tilted screen forward
		NSString *kenPizzaMan = [[NSBundle mainBundle] pathForResource:@"KenPizzaMan" ofType:@"gif"];
		NSURL *imageURL = [NSURL fileURLWithPath: kenPizzaMan];
		NSString *htmlString = @"<html><body><img src='%@' margin='0' padding='0' width='965' height='965'></body></html>";
		NSString *imageHTML  = [[NSString alloc] initWithFormat:htmlString, imageURL];
		
		self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width)/2 , self.view.bounds.size.width, self.view.bounds.size.width)];
		// Load image in UIWebView
		self.webView.scalesPageToFit = YES;
		self.webView.userInteractionEnabled = NO;
		[self.webView loadHTMLString:imageHTML baseURL:nil];
		[self.view addSubview:self.webView];
		self.methodManager.gifCount += 1;
	}
	else {
	 */
	// set animated view to square in middle of view
	FLAnimatedImageView *animatedImageView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width)/2 , self.view.bounds.size.width, self.view.bounds.size.width)];
	[self.view addSubview:animatedImageView];

	// set the rotation of the GIF
	self.transform = CGAffineTransformMakeRotation(M_PI_2); // 90 degrees EAST
	//Obtaining the current device orientation
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	//	NSLog(@"orienation = %ld", (long)orientation);
	if (orientation == UIDeviceOrientationLandscapeRight)
	{		// code for RIGHT orientation
		self.transform = CGAffineTransformMakeRotation(M_PI_2 *3); // 90 degrees WEST
	}
	animatedImageView.transform = self.transform;
	// add to the count and mod by amount of array
	self.methodManager.gifCount += 1;
	self.methodManager.gifCount = self.methodManager.gifCount % self.dao.gifArray.count;
	animatedImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:[self.dao.gifArray objectAtIndex:self.methodManager.gifCount]];
//	}
}

-(void)viewWillAppear:(BOOL)animated {
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

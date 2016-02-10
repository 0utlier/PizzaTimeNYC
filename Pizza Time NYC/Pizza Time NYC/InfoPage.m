//
//  InfoPage.m
//  Pizza Time NYC
//
//  Created by SUGAR^2 on 12/28/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import "InfoPage.h"
#import "MethodManager.h"
//#import "FLAnimatedImage.h"
//#import "FLAnimatedImageView.h"

@interface InfoPage ()

@property CGAffineTransform transform;
@property (strong, nonatomic) MethodManager *methodManager;

@end

@implementation InfoPage
-(void)viewDidLoad {
	[super viewDidLoad];
	
	UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width/2)-22, 16, 45, 45)];
	// Add an action in current code file (i.e. target)
	[backButton addTarget:self
				   action:@selector(backButtonPressed:)
		 forControlEvents:UIControlEventTouchUpInside];
	
	[backButton setBackgroundImage:[UIImage imageNamed:@"MCQppiBACK.png"] forState:UIControlStateNormal];
	[self.view addSubview:backButton];
	[self assignGif];
}

- (void)assignGif {
	self.methodManager = [MethodManager sharedManager];
	
	NSString *kenPizzaMan = [[NSBundle mainBundle] pathForResource:@"KenPizzaMan" ofType:@"gif"];
	
	NSURL *imageURL = [NSURL fileURLWithPath: kenPizzaMan];
	NSString *htmlString = @"<html><body><img src='%@' margin='0' padding='0' width='1100' height='%f'></body></html>";
	NSString *imageHTML  = [[NSString alloc] initWithFormat:htmlString, imageURL, self.view.frame.size.height * 0.88];
	// Load image in UIWebView
	self.webView.scalesPageToFit = YES;
	self.webView.userInteractionEnabled = NO;
	[self.webView loadHTMLString:imageHTML baseURL:nil];
	[self.view addSubview:self.webView];
	/*
		self.webView.hidden = YES;
	 NSData *gifData = [NSData dataWithContentsOfFile: kenPizzaMan];
	 FLAnimatedImageView *animatedImageView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.view.frame.size.width, self.designLabel.frame.origin.y - self.webView.frame.origin.y - self.designLabel.frame.size.height*2)];
	 //		FLAnimatedImageView *animatedImageView = [[FLAnimatedImageView alloc]initWithFrame:self.webView.frame];
		[self.view addSubview:animatedImageView];
		animatedImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
	*/
}

-(void)backButtonPressed:(UIButton *)backButton {
	// return to optionsPage
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end

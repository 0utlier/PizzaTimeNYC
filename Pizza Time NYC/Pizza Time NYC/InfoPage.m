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
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

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
	self.methodManager = [MethodManager sharedManager]; // not necessary, unless move gif to method manager

	// animated images implement
	NSArray *imageNames = @[@"KenPizzaMan1.png", @"KenPizzaMan3.png", @"KenPizzaMan5.png", @"KenPizzaMan9.png", @"KenPizzaMan11.png", @"KenPizzaMan13.png", @"KenPizzaMan15.png", @"KenPizzaMan19.png"];
	
	NSMutableArray *images = [[NSMutableArray alloc] init];
	for (int i = 0; i < imageNames.count; i++) {
		[images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
	}
	
	// Normal Animation
	self.imageView.animationImages = images;
	self.imageView.animationDuration = 0.6;
	
	[self.imageView startAnimating];
}

-(void)backButtonPressed:(UIButton *)backButton {
	// return to optionsPage
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end

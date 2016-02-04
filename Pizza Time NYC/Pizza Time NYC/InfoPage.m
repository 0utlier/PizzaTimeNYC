//
//  InfoPage.m
//  Pizza Time NYC
//
//  Created by SUGAR^2 on 12/28/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import "InfoPage.h"

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
}

-(void)backButtonPressed:(UIButton *)backButton {
	// return to optionsPage
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end

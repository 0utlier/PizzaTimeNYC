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
	UIButton *optionsButtonTemp = [[UIButton alloc]initWithFrame:CGRectMake(16, 16, 100, 100)];
	self.optionsButtonTemp = optionsButtonTemp;
	[optionsButtonTemp addTarget:self
							   action:@selector(optionsPressed:)
	 forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:optionsButtonTemp];
}

-(void)optionsPressed:(UIButton *)optionsbutton {
// return to optionsPage
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end

//
//  AddNewPlace.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/21/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "AddNewPlace.h"

@interface AddNewPlace ()

@end

@implementation AddNewPlace

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	UIButton *optionsButtonTemp = [[UIButton alloc]initWithFrame:CGRectMake(16, 16, 100, 100)];
	self.optionsButtonTemp = optionsButtonTemp;
	[optionsButtonTemp addTarget:self
						  action:@selector(optionsPressed:)
				forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:optionsButtonTemp];
}

-(void)optionsPressed:(UIButton *)optionsbutton {
	// return to optionsPage
	[self.tabBarController setSelectedIndex:OPTIONSPAGE];
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

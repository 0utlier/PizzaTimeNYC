//
//  PizzaPlaceInfoViewController.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/6/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "PizzaPlaceInfoViewController.h"

@interface PizzaPlaceInfoViewController ()

@end

@implementation PizzaPlaceInfoViewController

- (void)viewDidLoad {
	[super viewDidLoad];
//	self.optionsButton = [[UIButton alloc]init];
	[self.optionsButton addTarget:self
					  action:@selector(optionsButtonPressed:)
			forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)setLabelValues:(PizzaPlace*)pizzaPlace {
	//	NSLog(@"The name passed through = %@", pizzaPlace.name);
	UILabel *nameLabel = (UILabel *)[self.view viewWithTag:200];
	nameLabel.text = pizzaPlace.name;
	
	//seperate the address into two lines
	UILabel *addressLabelTop = (UILabel *)[self.view viewWithTag:201];
	addressLabelTop.text = pizzaPlace.street;
	
	UILabel *addressLabelBottom = (UILabel *)[self.view viewWithTag:202];
	NSString *secondLineAddress = [pizzaPlace.city stringByAppendingString:[NSString stringWithFormat:@" %ld",(long)pizzaPlace.zip ]];
	addressLabelBottom.text = secondLineAddress;
	
	UILabel *distanceLabel = (UILabel *)[self.view viewWithTag:203];
	distanceLabel.text = [NSString stringWithFormat:@"%.2f mi away", pizzaPlace.distance];
}

#pragma mark - ACTIONS

// Main initial button press
-(void)optionsButtonPressed:(UIButton *)optionsButton {
	NSLog(@"optionsButton was pressed");
	// this should open the options page of Pizza Time
UIViewController *detailViewController = (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"OptionsPage"];
	[self.navigationController pushViewController:detailViewController animated:YES];

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

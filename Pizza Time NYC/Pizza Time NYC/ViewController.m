//
//  ViewController.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 12/23/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// Add an action in current code file (i.e. target)
	[self.pizzaTimeButton addTarget:self
							 action:@selector(pizzaTimeButtonPressed:)
				   forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - ACTIONS

// Main initial button press
-(void)pizzaTimeButtonPressed:(UIButton *)pizzaTimeButton {
	NSLog(@"button was pressed");
	// this should open the MAP VIEW of pizza
}

@end

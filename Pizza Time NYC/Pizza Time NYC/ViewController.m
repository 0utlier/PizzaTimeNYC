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
	[self checkInternet];
	
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - ACTIONS

// Main initial button press
-(void)pizzaTimeButtonPressed:(UIButton *)pizzaTimeButton {
	NSLog(@"PizzaTimebutton was pressed");
	// this should open the MAP VIEW of Pizza Time
}

#pragma mark - REACHABILITY

-(void)checkInternet {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object: nil];
	
		self.hostReachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
		[self.hostReachability startNotifier];
	
	self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
	
	self.wifiReachability = [Reachability reachabilityForLocalWiFi];
	[self.wifiReachability startNotifier];
	
	[self logReachability:self.hostReachability];
	[self logReachability:self.internetReachability];
	[self logReachability:self.wifiReachability];
}

- (void)reachabilityChanged:(NSNotification *)notification {
	Reachability *reachability = [notification object];
	[self logReachability: reachability];
}

- (void)logReachability:(Reachability *)reachability {
	NSString *whichReachabilityString = nil;
	
	if (reachability == self.hostReachability) {
		whichReachabilityString = @"www.apple.com";
	} else if (reachability == self.internetReachability) {
		whichReachabilityString = @"The Internet";
	} else if (reachability == self.wifiReachability) {
		whichReachabilityString = @"Local Wi-Fi";
	}
	
	NSString *howReachableString = nil;
	
	switch (reachability.currentReachabilityStatus) {
		case NotReachable: {
			howReachableString = @"not reachable";
			NSLog(@"Enter the alertView here to say connect");
//			[self connectionAlert];
			break;
		}
		case ReachableViaWWAN: {
			howReachableString = @"reachable by cellular data";
			break;
		}
		case ReachableViaWiFi: {
			howReachableString = @"reachable by Wi-Fi";
			break;
			
		}
	}
	
	NSLog(@"%@ %@", whichReachabilityString, howReachableString);

}
/*
-(void)connectionAlert {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Disabled"
													message:@"Are you brooding underground with Raphael?"
												   delegate:self
										  cancelButtonTitle:@"Battery"
										  otherButtonTitles:@"Settings", nil];
	[alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	//	NSLog(@"%ld", (long)buttonIndex);
	if (buttonIndex == 1) {
		NSLog(@"open the settings app to wifi or root");
	}
	else {
		NSLog(@"User does not want to share location");
		// enter audio BUMMMMMMMERRRRR
	}
}
*/
@end

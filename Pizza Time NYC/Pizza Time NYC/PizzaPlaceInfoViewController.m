//
//  PizzaPlaceInfoViewController.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/6/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "PizzaPlaceInfoViewController.h"
#import "MapKitViewController.h"
//#import <Parse/Parse.h>

@interface PizzaPlaceInfoViewController ()

// for use of the avAudioPlayer & Menu Button
@property (strong, nonatomic) MethodManager *methodManager;
@property (strong, nonatomic) DAO *dao;

@end

@implementation PizzaPlaceInfoViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.methodManager = [MethodManager sharedManager];
	self.dao = [DAO sharedDAO];
	[self.directionsButton addTarget:self
						   action:@selector(directionsButtonPressed:)
				 forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	[self assignLabels];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)assignLabels {// and buttons
	[self.view addSubview:[self.methodManager assignOptionsButton]];
	[self.view addSubview:[self.methodManager assignSpeakerButton]];
	
	UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(16, 16, 45, 45)];
	self.backButton = backButton;
	// Add an action in current code file (i.e. target)
	[self.backButton addTarget:self
						action:@selector(backButtonPressed:)
			  forControlEvents:UIControlEventTouchUpInside];
	
	[self.backButton setBackgroundImage:[UIImage imageNamed:@"MCQppiBACK.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.backButton];
	
	//	UIButton *closedButton = [UIButton alloc];
	//							  self.closedButton = closedButton;
	// Add an action in current code file (i.e. target)
	[self.closedButton addTarget:self
						  action:@selector(closedButtonPressed:)
				forControlEvents:UIControlEventTouchUpInside];
	
	[self.rateUpButton addTarget:self
						  action:@selector(ratingUpButtonPressed:)
				forControlEvents:UIControlEventTouchUpInside];
	
	[self.rateDownButton addTarget:self
							action:@selector(ratingDownButtonPressed:)
				  forControlEvents:UIControlEventTouchUpInside];
	
}


- (void)setLabelValues:(PizzaPlace*)pizzaPlace {
	//	NSLog(@"The name passed through = %@", pizzaPlace.name);
	UILabel *nameLabel = (UILabel *)[self.view viewWithTag:200];
	nameLabel.text = [pizzaPlace.name uppercaseString];
	
	//seperate the address into two lines
	UILabel *addressLabelTop = (UILabel *)[self.view viewWithTag:201];
	addressLabelTop.text = pizzaPlace.street;
	
	UILabel *addressLabelBottom = (UILabel *)[self.view viewWithTag:202];
	NSString *secondLineAddress = [pizzaPlace.city stringByAppendingString:[NSString stringWithFormat:@" %ld",(long)pizzaPlace.zip ]];
	addressLabelBottom.text = secondLineAddress;
	
	UILabel *distanceLabel = (UILabel *)[self.view viewWithTag:203];
	distanceLabel.text = [NSString stringWithFormat:@"%.2f mi away", pizzaPlace.distance];
	self.currentPizzaPlace = pizzaPlace;
	
	self.imageView.image = [UIImage imageNamed:pizzaPlace.image];
	
	self.rateUpLabel.text = [NSString stringWithFormat:@"%d", pizzaPlace.likes];
	self.rateDownLabel.text = [NSString stringWithFormat:@"%d", pizzaPlace.dislikes];
	
}

#pragma mark - ACTIONS

// Main initial button press
-(void)directionsButtonPressed:(UIButton *)directionsButton {
	//	NSLog(@"directionsButton was pressed");
	self.methodManager.directionsShow = YES;
	MapKitViewController *mapKitViewController = self.tabBarController.viewControllers[MAPPAGE];
	mapKitViewController.currentPizzaPlace = self.currentPizzaPlace;
	[self.tabBarController setSelectedIndex:MAPPAGE];
	
}

-(void)backButtonPressed:(UIButton *)backButton {
	//	NSLog(@"backButton was pressed");
	[self.tabBarController setSelectedIndex:MAPPAGE];
	
}

- (void)closedButtonPressed:(UIButton *)closedButton {
	UIAlertView *closedAlert = [[UIAlertView alloc] initWithTitle:@"Did this place permanently close?"
														  message:@""
														 delegate:self
												cancelButtonTitle:@"Cancel"
												otherButtonTitles: @"DUNZO",nil];
	[closedAlert show];
}

- (void)ratingUpButtonPressed:(UIButton *)upButton {
	[self.dao likePizzaPlaceWithName:self.currentPizzaPlace.name];
	
	if (self.currentPizzaPlace.rated == RATEDLIKE) {
		self.currentPizzaPlace.likes--;
		self.currentPizzaPlace.rated = RATEDNOT;
	}
	else if (self.currentPizzaPlace.rated == RATEDDISLIKE) {
		self.currentPizzaPlace.likes++;
		self.currentPizzaPlace.dislikes--;
		NSString *dislikesValue = [NSString stringWithFormat:@"%d", self.currentPizzaPlace.dislikes];
		self.rateDownLabel.text = dislikesValue;
		self.currentPizzaPlace.rated = RATEDLIKE;
	}
	else { // (self.currentPizzaPlace.rated == RATEDNOT)
		self.currentPizzaPlace.likes++;
		self.currentPizzaPlace.rated = RATEDLIKE;
	}
	NSString *likesValue = [NSString stringWithFormat:@"%d", self.currentPizzaPlace.likes];
	self.rateUpLabel.text = likesValue;
	NSLog(@"%@", self.rateUpLabel.text);
}

- (void)ratingDownButtonPressed:(UIButton *)downButton {
	[self.dao dislikePizzaPlaceWithName:self.currentPizzaPlace.name];
	
	if (self.currentPizzaPlace.rated == RATEDLIKE) {
		self.currentPizzaPlace.likes--;
		NSString *likesValue = [NSString stringWithFormat:@"%d", self.currentPizzaPlace.likes];
		self.rateDownLabel.text = likesValue;
		self.currentPizzaPlace.dislikes++;
		self.currentPizzaPlace.rated = RATEDDISLIKE;
	}
	else if (self.currentPizzaPlace.rated == RATEDDISLIKE) {
		self.currentPizzaPlace.dislikes--;
		self.currentPizzaPlace.rated = RATEDNOT;
	}
	else { // (self.currentPizzaPlace.rated == RATEDNOT)
		self.currentPizzaPlace.dislikes++;
				self.currentPizzaPlace.rated = RATEDDISLIKE;
	}
	NSString *dislikesValue = [NSString stringWithFormat:@"%d", self.currentPizzaPlace.dislikes];
	self.rateDownLabel.text = dislikesValue;
	NSLog(@"%@", self.rateDownLabel.text);
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UIAlertView

// bring user to settings of Pizza Time (stock settings)
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
#pragma mark 1 - Question Submission
	// 1 // are you sure it's closed?
	if ([alertView.title isEqualToString:@"Did this place permanently close?"]) {
		if (buttonIndex == 1) {
			// create a PFObject and parse it!
			[self.dao closedSubmission:self.currentPizzaPlace];

			/* // moved to DAO 2.10.16
			PFObject *feedbackParse = [PFObject objectWithClassName:@"FeedbackParse"];
			feedbackParse[@"feedbackString"] = self.currentPizzaPlace.name;
			feedbackParse[@"userEmail"] = self.currentPizzaPlace.address;
			feedbackParse[@"typeFeedback"] = @"CLOSED";
			
			[feedbackParse saveEventually];
			*/
			UIAlertView *confirmationAlert = [[UIAlertView alloc] initWithTitle:@"Thank You!"
																		message:@"We will look into it!"
																	   delegate:nil
															  cancelButtonTitle:@"OK"
															  otherButtonTitles: nil];
			
			[confirmationAlert show];
			
		}
	}
}


@end

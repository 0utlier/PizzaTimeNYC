//
//  PizzaPlaceInfoViewController.m
//  Pizza Time NYC
//
//  Created by JD Leonard on 1/6/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "PizzaPlaceInfoViewController.h"
#import "MapKitViewController.h"

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
	[self setPercentageLabels];
	[self setRatingButtons];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - ASSIGN VALUES

- (void)assignLabels {// and buttons
	[self.methodManager removeBothButtons];
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
	[self.rateUpButton setBackgroundImage:[UIImage imageNamed:@"MCQSliceGreen.png"] forState:UIControlStateNormal];
	[self.rateUpButton setBackgroundImage:[UIImage imageNamed:@"pizzaHappyRate.jpg"] forState:UIControlStateSelected];

	[self.rateDownButton addTarget:self
							action:@selector(ratingDownButtonPressed:)
				  forControlEvents:UIControlEventTouchUpInside];
	[self.rateDownButton setBackgroundImage:[UIImage imageNamed:@"MCQSliceRed.png"] forState:UIControlStateNormal];
	[self.rateDownButton setBackgroundImage:[UIImage imageNamed:@"pizzaSadRate.jpg"] forState:UIControlStateSelected];
}

- (void)setLabelValues:(PizzaPlace*)pizzaPlace { // called before page loads
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
}

- (void)setPercentageLabels {
	// now set the values
	if (self.currentPizzaPlace.likes + self.currentPizzaPlace.dislikes == 0) {
		self.rateUpLabel.text = [NSString stringWithFormat:@"%.0f%%", 0.0];
		self.rateDownLabel.text = [NSString stringWithFormat:@"%.0f%%", 0.0];
	}
	else {
		self.rateUpLabel.text = [NSString stringWithFormat:@"%.0f%%", self.currentPizzaPlace.percentageLikes];
		self.rateDownLabel.text = [NSString stringWithFormat:@"%.0f%%", self.currentPizzaPlace.percentageDislikes];
	}	NSLog(@"%d", self.currentPizzaPlace.likes);
	
}

- (void)setRatingButtons {
	if (self.currentPizzaPlace.rated == RATEDLIKE) {
		self.rateUpButton.selected = YES;
		self.rateDownButton.selected = NO;
	}
	else if (self.currentPizzaPlace.rated == RATEDDISLIKE) {
		self.rateUpButton.selected = NO;
		self.rateDownButton.selected = YES;
	}
	else { // (self.currentPizzaPlace.rated == RATEDNOT)
		self.rateUpButton.selected = NO;
		self.rateDownButton.selected = NO;
	}
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
	if (self.methodManager.mapPageBool == YES) {
		[self.tabBarController setSelectedIndex:MAPPAGE];
	}
	else {
		[self.tabBarController setSelectedIndex:LISTPAGE];
	}
	
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
		self.currentPizzaPlace.rated = RATEDLIKE;
	}
	else { // (self.currentPizzaPlace.rated == RATEDNOT)
		self.currentPizzaPlace.likes++;
		self.currentPizzaPlace.rated = RATEDLIKE;
	}
	// now set the values
	[self setPercentageLabels];
	[self setRatingButtons];
}

- (void)ratingDownButtonPressed:(UIButton *)downButton {
	[self.dao dislikePizzaPlaceWithName:self.currentPizzaPlace.name];
	
	if (self.currentPizzaPlace.rated == RATEDLIKE) {
		self.currentPizzaPlace.dislikes++;
		self.currentPizzaPlace.likes--;
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
	// now set the values
	[self setPercentageLabels];
	[self setRatingButtons];
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

//
//  PizzaPlaceInfoViewController.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/6/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "PizzaPlaceInfoViewController.h"
#import "MapKitViewController.h"

@interface PizzaPlaceInfoViewController ()

// for use of the avAudioPlayer & Menu Button
@property (strong, nonatomic) MethodManager *methodManager;

@end

@implementation PizzaPlaceInfoViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [[UIColor alloc]initWithRed:255.0/255.0 green:206.0/255.0 blue:98.0/255.0 alpha:1.0];
	self.methodManager = [MethodManager sharedManager];
//	self.directionsButton.imageView.image = [UIImage imageNamed:@"MCQgoButtonDirections.png"];
	[self.directionsButton addTarget:self
						   action:@selector(directionsButtonPressed:)
				 forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
//	[self.navigationController setNavigationBarHidden:NO];
	[self assignLabels];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(void)assignLabels {// and buttons
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
	
//	self.imageView.image = [UIImage imageNamed:pizzaPlace.image];
	self.imageView.image = [UIImage imageNamed:@"6thAve.png"];
}

#pragma mark - ACTIONS

// Main initial button press
-(void)directionsButtonPressed:(UIButton *)directionsButtonPressed {
	NSLog(@"directionsButton was pressed");
	self.methodManager.directionsShow = YES;
	MapKitViewController *mapKitViewController = self.tabBarController.viewControllers[MAPPAGE];
	mapKitViewController.currentPizzaPlace = self.currentPizzaPlace;
	[self.tabBarController setSelectedIndex:MAPPAGE];

}

-(void)backButtonPressed:(UIButton *)directionsButtonPressed {
	NSLog(@"backButton was pressed");
	[self.tabBarController setSelectedIndex:MAPPAGE];
	
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

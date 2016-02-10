//
//  ViewController.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 12/23/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import "ViewController.h"
#import "MapKitViewController.h"

@interface ViewController ()

// for use of the avAudioPlayer & Menu Button
@property (strong, nonatomic) MethodManager *methodManager;
@property (strong, nonatomic) DAO *dao;

@end

int countHomePage; // for the background Color at the front
BOOL firstTimeLoadedHomePage; // to stop refresh [of map] on initial load (NO = not the first time)
/*
 countHomePage 1.20.16
 created in ViewController
 VC VWA +=1
 VC assignColors SWITCH statement
 
 firstTimeLoadedHomePage 1.20.16
 created in ViewController
 [not initialized, but assumed YES]
 VC VWA if, set NO
 */

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.tabBarController.tabBar setHidden:YES];
	
	self.methodManager = [MethodManager sharedManager];
	self.methodManager.statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
	[self.methodManager createLocationManager];
	//	NSLog(@"location manager in VDL VC = %f", self.methodManager.locationManager.location.coordinate.latitude);
	[self.methodManager createEmpireStateBuilding];
	self.dao = [DAO sharedDAO];
	//	[self checkInternet]; //comment back in when ready to fix
	[self buildNumberInfo];
	UIImageView *pizzaTimeLogo = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/8, self.view.bounds.size.height/8, (self.view.bounds.size.width/4)*3, self.view.bounds.size.height/3)];
	pizzaTimeLogo.image = [UIImage imageNamed:@"MCQpizzaTimeLOGO.png"];
	[self.view addSubview:pizzaTimeLogo];
	
	[self assignSlices];
	
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//	[self.navigationController setNavigationBarHidden:YES]; // removed 1.26.16 no more nav bar to worry about
	[self assignLabels];
	countHomePage+=1;
	[self assignColors];
	if(firstTimeLoadedHomePage) {
		// do what occurs AFTER first time
	}
	else {
		NSLog(@"ViewHome LOADED first time = App Launched (called first and only once)");
		firstTimeLoadedHomePage = YES;
		// used to keep track if user wants to be reminded
		self.methodManager.userLocAuth = NO;
		self.methodManager.userLocRemind = YES;
		self.methodManager.firstTimeLoaded = YES;
		self.methodManager.closestPP = NO;
		self.methodManager.rotation = YES;
//		[self.dao downloadParsePP]; // 1.29.16 download first, pin and then call local data
		[self.dao fromLocalDataPP];
		//		[self.dao downloadParseGifs]; // 2.4.16 download first, pin and then call local gifs
		[self.dao fromLocalDataGifs];
		[self.methodManager createOrientation];
		[[UIDevice currentDevice] setValue:
		 [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
									forKey:@"orientation"];	}
	
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:YES];
	//	[self.pizzaTimeLogo removeFromSuperview];
}

/*
 // I do not think this is doing anything I want it to 1.30.16
 -(UIInterfaceOrientationMask)supportedInterfaceOrientations {
 
	// Return a bitmask of supported orientations. If you need more,
	// use bitwise or (see the commented return).
	return UIInterfaceOrientationMaskPortrait;
	// return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
 }
 
 - (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
	// Return the orientation you'd prefer - this is what it launches to. The
	// user can still rotate. You don't have to implement this method, in which
	// case it launches in the current orientation
	return UIInterfaceOrientationPortrait;
 }
 */

-(void)assignLabels {// and buttons
	
	[self.view addSubview:[self.methodManager assignSpeakerButton]];
	
	//	self.pizzaTimeLogo = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/8, self.view.bounds.size.height/8, (self.view.bounds.size.width/4)*3, self.view.bounds.size.height/3)];
	//	self.pizzaTimeLogo.image = [UIImage imageNamed:@"MCQpizzaTimeLOGO.png"];
	//	[self.view addSubview:self.pizzaTimeLogo];
	
	//	UIImage *pizzaButtonImage = [UIImage imageNamed:@"pizzaPepperoni300.png"];
	//	[self.pizzaTimeButton setBackgroundImage:pizzaButtonImage forState:UIControlStateNormal];
	//
	//	UIImage *pizzaButtonImagePressed = [UIImage imageNamed:@"pizzaFullSliceRemove.jpg"];
	//	[self.pizzaTimeButton setBackgroundImage:pizzaButtonImagePressed forState:UIControlStateHighlighted];
	
	//	if (self.methodManager.sound == YES) {
	//		[self.speakerButton setBackgroundImage:[self.methodManager playMusic] forState:UIControlStateNormal];
	//	}
	//	else {
	//		[self.speakerButton setBackgroundImage:[self.methodManager stopMusic] forState:UIControlStateNormal];
	//	}
	
	//remove the optionsButton, since we are on the options page
	//	[self.view addSubview:[self.methodManager assignOptionsButton]];
	
	// Add an action in current code file (i.e. target)
	//	[self.pizzaTimeButton addTarget:self
	//							 action:@selector(pizzaTimeButtonPressed:)
	//				   forControlEvents:UIControlEventTouchUpInside];
	// Add an action in current code file (i.e. target)
	//	[self.speakerButton addTarget:self
	//						   action:@selector(speakerButtonPressed:)
	//				 forControlEvents:UIControlEventTouchUpInside];
	
	//	UIImage *speakerButtonImagePressed = [UIImage imageNamed:@"speakerCross60.png"];
	//	[self.speakerButton setBackgroundImage:speakerButtonImagePressed forState:UIControlStateHighlighted];
	
	//	UILabel *pizzaLabel = (UILabel *)[self.view viewWithTag:1001];
	//	pizzaLabel.font = [UIFont fontWithName:@"couria" size:24];
	// [pizzaLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
	//	pizzaLabel.text = @"PIZZA";
	//
	//	UILabel *timeLabel = (UILabel *)[self.view viewWithTag:1002];
	//	timeLabel.font = [UIFont fontWithName:@"couria" size:24];
	//	timeLabel.text = @"TIME";
	
	// divide by 2 for center and minus 30 for center of png
	//	UIButton *optionsButtonMapPage = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 30, 80, 60, 60)];
	//	// Add an action in current code file (i.e. target)
	//	[optionsButtonMapPage addTarget:self
	//							 action:@selector(optionsButtonPressed:)
	//				   forControlEvents:UIControlEventTouchUpInside];
	//
	//	[optionsButtonMapPage setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
	//	[self.view addSubview:optionsButtonMapPage];
	//
	
}

-(void)assignSlices {
	self.screenSize = self.view.bounds.size;
	
	self.leftB = [[UIButton alloc]initWithFrame:CGRectMake((self.screenSize.width/6), (self.screenSize.height/4)*3, self.screenSize.width/3, self.screenSize.height/6)];
	// Add an action in current code file (i.e. target)
	[self.leftB addTarget:self
				   action:@selector(leftBPressed:)
		 forControlEvents:UIControlEventTouchUpInside];
	[self.leftB setBackgroundImage:[UIImage imageNamed:@"MCQSliceLEFTb.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.leftB];
	
	
	self.rightB = [[UIButton alloc]initWithFrame:CGRectMake((self.screenSize.width/2), (self.screenSize.height/4)*3, self.screenSize.width/3, self.screenSize.height/6)];
	// Add an action in current code file (i.e. target)
	[self.rightB addTarget:self
					action:@selector(rightBPressed:)
		  forControlEvents:UIControlEventTouchUpInside];
	[self.rightB setBackgroundImage:[UIImage imageNamed:@"MCQSliceRIGHTb.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.rightB];
	
	
	self.leftT = [[UIButton alloc]initWithFrame:CGRectMake((self.screenSize.width/6), (self.screenSize.height/4)*3 - (self.screenSize.height/6), self.screenSize.width/3, self.screenSize.height/6)];
	// Add an action in current code file (i.e. target)
	[self.leftT addTarget:self
				   action:@selector(leftTPressed:)
		 forControlEvents:UIControlEventTouchUpInside];
	[self.leftT setBackgroundImage:[UIImage imageNamed:@"MCQSliceLEFTt.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.leftT];
	
	
	self.rightT = [[UIButton alloc]initWithFrame:CGRectMake((self.screenSize.width/2), (self.screenSize.height/4)*3 - (self.screenSize.height/6), self.screenSize.width/3, self.screenSize.height/6)];
	// Add an action in current code file (i.e. target)
	[self.rightT addTarget:self
					action:@selector(rightTPressed:)
		  forControlEvents:UIControlEventTouchUpInside];
	[self.rightT setBackgroundImage:[UIImage imageNamed:@"MCQSliceRIGHTt.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.rightT];
	
	
	self.top = [[UIButton alloc]initWithFrame:CGRectMake(((self.screenSize.width/2) - (self.screenSize.width/6)), (7*(self.screenSize.height/12) - self.screenSize.height*0.026), self.screenSize.width/3, self.screenSize.height/6 + self.screenSize.height*0.026)];
	// Add an action in current code file (i.e. target)
	[self.top addTarget:self
				 action:@selector(topPressed:)
	   forControlEvents:UIControlEventTouchUpInside];
	[self.top setBackgroundImage:[UIImage imageNamed:@"MCQSliceTOP.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.top];
	
	
	self.bottom = [[UIButton alloc]initWithFrame:CGRectMake(((self.screenSize.width/2) - (self.screenSize.width/6)), ((self.screenSize.height/4)*3), self.screenSize.width/3, self.screenSize.height/6 + self.screenSize.height*0.026)];
	// Add an action in current code file (i.e. target)
	[self.bottom addTarget:self
					action:@selector(bottomPressed:)
		  forControlEvents:UIControlEventTouchUpInside];
	[self.bottom setBackgroundImage:[UIImage imageNamed:@"MCQSliceBOTTOM.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.bottom];
}


-(void)buildNumberInfo {
	NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
	NSString *appVersion = [infoDict objectForKey:@"CFBundleShortVersionString"]; // example: 1.0.0
	//	NSNumber *buildNumber = [infoDict objectForKey:@"CFBundleVersion"]; // example: 42
	//	NSLog(@"\nversion = %@\nbuild = %@", appVersion, buildNumber);
	UILabel *nameLabel = (UILabel *)[self.view viewWithTag:1000];
	nameLabel.text = [NSString stringWithFormat:@"ver %@",appVersion];
	self.methodManager.buildNumber = appVersion;
}

-(void)assignColors { // is it better to alloc ONLY inside of the case statement, or create all?
	/*
	 orange HEX = FFCE62
	 blue HEX = 00BCCC
	 red HEX = F16648
	 tan HEX = F8DB96
	 */
	UIColor *orangeMCQ = [[UIColor alloc]initWithRed:255.0/255.0 green:206.0/255.0 blue:98.0/255.0 alpha:1.0];
	UIColor *blueMCQ = [[UIColor alloc]initWithRed:0.0/255.0 green:188.0/255.0 blue:204.0/255.0 alpha:1.0];
	UIColor *purple = [[UIColor alloc]initWithRed:137.0/255.0 green:12.0/255.0 blue:208.0/255.0 alpha:1.0];
	//	UIColor *green = [[UIColor alloc]initWithRed:55.0/255.0 green:193.0/255.0 blue:0.0/255.0 alpha:1.0];
	// assign background color to change
	switch (countHomePage%3) {
		case 0:
			//					NSLog(@"count is 0 - set blue");
			self.view.backgroundColor = blueMCQ;
			countHomePage +=1;
			break;
		case 1:
			//					NSLog(@"Count is 1 - set orange");
			self.view.backgroundColor = orangeMCQ;
			countHomePage +=1;
			break;
		case 2:
			//					NSLog(@"Count is 2 - set green");
			self.view.backgroundColor = purple;
			countHomePage +=1;
			break;
		default:
			NSLog(@"CountHomePage is DEFAULT - decide what to do");
			self.view.backgroundColor = purple;
			countHomePage +=1;
			break;
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - ACTIONS
/*
 // Main initial button press
 -(void)pizzaTimeButtonPressed:(UIButton *)pizzaTimeButton {
	NSLog(@"PizzaTimebutton was pressed");
	// this should open the MAP VIEW of Pizza Time
 }
 */

// this should disable and enable the sound of the app
//-(void)speakerButtonPressed:(UIButton *)speakerButton {
//	if (self.appDelegate.sound) {
//		//		NSLog(@"sound disabled"); //disable sound
//		[self.speakerButton setBackgroundImage:[self.appDelegate stopMusic] forState:UIControlStateNormal];
//		//		self.appDelegate.audioPlayer.rate = 0.0;
//	}
//	else {
//		//		NSLog(@"sound enabled"); //enable sound
//		[self.speakerButton setBackgroundImage:[self.appDelegate playMusic] forState:UIControlStateNormal];
//		//		self.appDelegate.audioPlayer.rate = 1.0;
//	}
//}

/*
 // this should show the menu page
 -(void)optionsButtonPressed:(UIButton *)optionsButton {
	NSLog(@"optionsButton was pressed");
	// this should open the options page of Pizza Time
	UIViewController *detailViewController = (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"OptionsPage"];
	[self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

#pragma mark - ACTIONS Slices
/*
 nslog whats opening
 animate: set new location
 complete: open page
 set frame back to original
 */

-(void)leftBPressed:(UIButton *)leftBButton {
	//	NSLog(@"Open the LIST");
	[UIView animateWithDuration:0.66
					 animations:^{
						 // where is the button going?
						 self.leftB.frame = CGRectMake((self.screenSize.width/12)*-1, (self.screenSize.height/6)*5, self.screenSize.width/3, self.screenSize.height/6);
					 }completion:^(BOOL finished) { //when finished, load the page
						 [self.tabBarController setSelectedIndex:LISTPAGE];
						 self.leftB.frame = CGRectMake((self.screenSize.width/6), (self.screenSize.height/4)*3, self.screenSize.width/3, self.screenSize.height/6);
					 }];
}

-(void)rightBPressed:(UIButton *)rightBButton {
	NSLog(@"Open the FEEDBACK");
	UIViewController *detailViewController = (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"feedbackPage"];
	[UIView animateWithDuration:0.66
					 animations:^{
						 // where is the button going?
						 self.rightB.frame = CGRectMake((self.screenSize.width/4)*3, (self.screenSize.height/6)*5, self.screenSize.width/3, self.screenSize.height/6);
						 //						 self.rightB.alpha = 0.0;
					 }completion:^(BOOL finished) { //when finished, load the page
						 UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Profile Page Coming Soon"
																			   message:@"Leave feedback in the mean time"
																			  delegate:nil
																	 cancelButtonTitle:@"OK"
																	 otherButtonTitles: nil];
						 
						 [myAlertView show];
						 self.methodManager.rotation = NO;
						 [self presentViewController:detailViewController animated:YES completion:nil];
						 self.rightB.frame = CGRectMake((self.screenSize.width/2), (self.screenSize.height/4)*3, self.screenSize.width/3, self.screenSize.height/6);
					 }];
}

-(void)leftTPressed:(UIButton *)leftTButton {
	//	NSLog(@"Open the ABOUT");
	UIViewController *detailViewController = (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"aboutPage"];
	[UIView animateWithDuration:0.66
					 animations:^{
						 // where is the button going?
						 self.leftT.frame = CGRectMake((self.screenSize.width/12)*-1, (self.screenSize.height/3), self.screenSize.width/3, self.screenSize.height/6);
					 }completion:^(BOOL finished) { //when finished, load the page
						 [self presentViewController:detailViewController animated:YES completion:nil];
						 self.leftT.frame = CGRectMake((self.screenSize.width/6), (self.screenSize.height/4)*3 - (self.screenSize.height/6), self.screenSize.width/3, self.screenSize.height/6);
					 }];
}

-(void)rightTPressed:(UIButton *)rightTButton {
	NSLog(@"Open the CLOSEST");
	self.methodManager.directionsShow = YES;
	self.methodManager.closestPP = YES;
	[UIView animateWithDuration:0.66
					 animations:^{
						 // where is the button going?
						 self.rightT.frame = CGRectMake((self.screenSize.width/4)*3, (self.screenSize.height/3), self.screenSize.width/3, self.screenSize.height/6);
					 }completion:^(BOOL finished) { //when finished, load the page
						 [self.tabBarController setSelectedIndex:MAPPAGE];
						 self.rightT.frame = CGRectMake((self.screenSize.width/2), (self.screenSize.height/4)*3 - (self.screenSize.height/6), self.screenSize.width/3, self.screenSize.height/6);
					 }];
}

-(void)topPressed:(UIButton *)topButton {
	//	NSLog(@"Open the MAP");
	self.methodManager.directionsShow = NO;
	[UIView animateWithDuration:0.66
					 animations:^{
						 // where is the button going?
						 self.top.frame = CGRectMake(((self.screenSize.width/2) - (self.screenSize.width/6)), (4*(self.screenSize.height/12) - 15), self.screenSize.width/3, self.screenSize.height/6);
					 }completion:^(BOOL finished) { //when finished, load the page
						 [self.tabBarController setSelectedIndex:MAPPAGE];
						 self.top.frame = CGRectMake(((self.screenSize.width/2) - (self.screenSize.width/6)), (7*(self.screenSize.height/12) - self.screenSize.height*0.026), self.screenSize.width/3, self.screenSize.height/6 + self.screenSize.height*0.026);
					 }];
}

-(void)bottomPressed:(UIButton *)bottomButton {
	//	NSLog(@"Open the ADD");
	[UIView animateWithDuration:0.66
					 animations:^{
						 // where is the button going?
						 self.bottom.frame = CGRectMake(((self.screenSize.width/2) - (self.screenSize.width/6)), (4*(self.screenSize.height/4) + 15), self.screenSize.width/3, self.screenSize.height/6);
					 }completion:^(BOOL finished) { //when finished, load the page
						 [self.tabBarController setSelectedIndex:ADDPAGE];
						 self.bottom.frame = CGRectMake(((self.screenSize.width/2) - (self.screenSize.width/6)), ((self.screenSize.height/4)*3), self.screenSize.width/3, self.screenSize.height/6 + self.screenSize.height*0.026);
					 }];
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
	// use a counter, by returning 1 if triggered and 0 if not, use this to eliminate checking for other connections. maybe even a bool
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
			[self connectionAlert];
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
	
	//	NSLog(@"%@ %@", whichReachabilityString, howReachableString);
	
}

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

@end

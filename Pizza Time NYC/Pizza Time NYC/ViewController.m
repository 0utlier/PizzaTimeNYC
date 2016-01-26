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
	[self.methodManager createEmpireStateBuilding];
	//	[self checkInternet]; //comment back in when ready to fix
	[self buildNumberInfo];

	[self assignLabels];
	[self assignSounds];
	[self assignColors];
	[self assignSlices];
	
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES];
	countHomePage+=1;
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
	}
	
}

-(void)assignLabels {// and buttons
	
	UIImageView *pizzaTimeLogo = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/8, self.view.bounds.size.height/8, (self.view.bounds.size.width/4)*3, self.view.bounds.size.height/3)];
	pizzaTimeLogo.image = [UIImage imageNamed:@"MCQpizzaTimeLOGO.png"];
	[self.view addSubview:pizzaTimeLogo];
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
	[self.view addSubview:[self.methodManager assignSpeakerButton]];
	
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
	CGSize screenSize = self.view.bounds.size;
	
	UIButton *leftB = [[UIButton alloc]initWithFrame:CGRectMake((screenSize.width/6), (screenSize.height/4)*3, screenSize.width/3, screenSize.height/6)];
	// Add an action in current code file (i.e. target)
	[leftB addTarget:self
			  action:@selector(leftBPressed:)
	forControlEvents:UIControlEventTouchUpInside];
	[leftB setBackgroundImage:[UIImage imageNamed:@"MCQSliceLEFTb.png"] forState:UIControlStateNormal];
	[self.view addSubview:leftB];
	
	
	UIButton *rightB = [[UIButton alloc]initWithFrame:CGRectMake((screenSize.width/2), (screenSize.height/4)*3, screenSize.width/3, screenSize.height/6)];
	// Add an action in current code file (i.e. target)
	[rightB addTarget:self
			   action:@selector(rightBPressed:)
	 forControlEvents:UIControlEventTouchUpInside];
	[rightB setBackgroundImage:[UIImage imageNamed:@"MCQSliceRIGHTb.png"] forState:UIControlStateNormal];
	[self.view addSubview:rightB];
	
	
	UIButton *leftT = [[UIButton alloc]initWithFrame:CGRectMake((screenSize.width/6), (screenSize.height/4)*3 - (screenSize.height/6), screenSize.width/3, screenSize.height/6)];
	// Add an action in current code file (i.e. target)
	[leftT addTarget:self
			  action:@selector(leftTPressed:)
	forControlEvents:UIControlEventTouchUpInside];
	[leftT setBackgroundImage:[UIImage imageNamed:@"MCQSliceLEFTt.png"] forState:UIControlStateNormal];
	[self.view addSubview:leftT];
	
	
	UIButton *rightT = [[UIButton alloc]initWithFrame:CGRectMake((screenSize.width/2), (screenSize.height/4)*3 - (screenSize.height/6), screenSize.width/3, screenSize.height/6)];
	// Add an action in current code file (i.e. target)
	[rightT addTarget:self
			   action:@selector(rightTPressed:)
	 forControlEvents:UIControlEventTouchUpInside];
	[rightT setBackgroundImage:[UIImage imageNamed:@"MCQSliceRIGHTt.png"] forState:UIControlStateNormal];
	[self.view addSubview:rightT];
	
	
	UIButton *top = [[UIButton alloc]initWithFrame:CGRectMake(((screenSize.width/2) - (screenSize.width/6)), (7*(screenSize.height/12) - 15), screenSize.width/3, screenSize.height/6)];
	// Add an action in current code file (i.e. target)
	[top addTarget:self
			action:@selector(topPressed:)
	 forControlEvents:UIControlEventTouchUpInside];
	[top setBackgroundImage:[UIImage imageNamed:@"MCQSliceTOP.png"] forState:UIControlStateNormal];
	[self.view addSubview:top];
	
	
	UIButton *bottom = [[UIButton alloc]initWithFrame:CGRectMake(((screenSize.width/2) - (screenSize.width/6)), (3*(screenSize.height/4) + 15), screenSize.width/3, screenSize.height/6)];
	// Add an action in current code file (i.e. target)
	[bottom addTarget:self
			   action:@selector(bottomPressed:)
	 forControlEvents:UIControlEventTouchUpInside];
	[bottom setBackgroundImage:[UIImage imageNamed:@"MCQSliceBOTTOM.png"] forState:UIControlStateNormal];
	[self.view addSubview:bottom];
	
}

-(void)assignSounds {
	if (self.methodManager.audioPlayer.rate == 0.0) {
		NSString *backgroundMusicPath = [[NSBundle mainBundle]pathForResource:@"pizzaMusic" ofType:@"mp3"];
		if (!self.methodManager.audioPlayer) {
			self.methodManager.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:backgroundMusicPath] error:NULL];
		}
		self.methodManager.audioPlayer.numberOfLoops = -1; // -1 is infinite loops
	}
	else {
		//		NSLog(@"You've already created the player!");
	}
}

-(void)buildNumberInfo {
	NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
	NSString *appVersion = [infoDict objectForKey:@"CFBundleShortVersionString"]; // example: 1.0.0
	//	NSNumber *buildNumber = [infoDict objectForKey:@"CFBundleVersion"]; // example: 42
	//	NSLog(@"\nversion = %@\nbuild = %@", appVersion, buildNumber);
	UILabel *nameLabel = (UILabel *)[self.view viewWithTag:1000];
	nameLabel.text = [NSString stringWithFormat:@"ver %@",appVersion];
	
}

-(void)assignColors { // is it better to alloc ONLY inside of the case statement, or create all?
	UIColor *orangeMCQ = [[UIColor alloc]initWithRed:255.0/255.0 green:206.0/255.0 blue:98.0/255.0 alpha:1.0];
	UIColor *blueMCQ = [[UIColor alloc]initWithRed:0.0/255.0 green:188.0/255.0 blue:204.0/255.0 alpha:1.0];
	UIColor *green = [[UIColor alloc]initWithRed:55.0/255.0 green:193.0/255.0 blue:0.0/255.0 alpha:1.0];
	UIColor *purple = [[UIColor alloc]initWithRed:137.0/255.0 green:12.0/255.0 blue:208.0/255.0 alpha:1.0];
	// assign background color to change
	switch (countHomePage%3) {
		case 0:
			//					NSLog(@"count is 0 - set orange");
			self.view.backgroundColor = orangeMCQ;
			countHomePage +=1;
			break;
		case 1:
			//					NSLog(@"Count is 1 - set blue");
			self.view.backgroundColor = blueMCQ;
			countHomePage +=1;
			break;
		case 2:
			//					NSLog(@"Count is 2 - set green");
			self.view.backgroundColor = green;
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
-(void)leftBPressed:(UIButton *)leftBButton {
	//	NSLog(@"Open the LIST");
//	TableViewController *detailViewController = (TableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"listView"];
//	[self.navigationController pushViewController:detailViewController animated:YES];
	[self.tabBarController setSelectedIndex:LISTPAGE];
}

-(void)rightBPressed:(UIButton *)rightBButton {
	NSLog(@"Open the FEEDBACK");
//	[self.tabBarController setSelectedIndex:FEEDBACKPAGE];
}

-(void)leftTPressed:(UIButton *)leftTButton {
	//	NSLog(@"Open the ABOUT");
	UIViewController *detailViewController = (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"aboutPage"];
	[self presentViewController:detailViewController animated:YES completion:nil];

	//	[self.navigationController pushViewController:detailViewController animated:YES];
	//	[self.tabBarController setSelectedIndex:ABOUTPAGE];
}

-(void)rightTPressed:(UIButton *)rightTButton {
	NSLog(@"Open the CLOSEST");
	self.methodManager.directionsShow = YES;
	self.methodManager.closestPP = YES;
	[self.tabBarController setSelectedIndex:MAPPAGE];
}

-(void)topPressed:(UIButton *)topButton {
	//	NSLog(@"Open the MAP");
//	MapKitViewController *detailViewController = (MapKitViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"mapKit"];
//	[self.navigationController pushViewController:self.methodManager.mapKitViewController animated:YES];
	self.methodManager.directionsShow = NO;
	[self.tabBarController setSelectedIndex:MAPPAGE];
}

-(void)bottomPressed:(UIButton *)bottomButton {
//	NSLog(@"Open the ADD");
//	UIViewController *detailViewController = (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"addPage"];
//	[self.navigationController pushViewController:detailViewController animated:YES];
	[self.tabBarController setSelectedIndex:ADDPAGE];
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

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

int countHomePage; // for the image at the front
BOOL firstTimeLoadedHomePage; // to stop refresh [of map] on initial load
//BOOL soundHomePage; // silent or loud (NO = 0 = Silent)

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.methodManager = [MethodManager sharedManager];
//	[self checkInternet]; //comment back in when ready to fix
	[self assignLabels];
	[self assignSounds];
	[self buildNumberInfo];
	
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES];
	if(firstTimeLoadedHomePage) {
		// do what occurs first time
	}
	else {
		NSLog(@"ViewHome LOADED first time");
		firstTimeLoadedHomePage = YES;
	}
	
}

-(void)assignLabels {// and buttons
	UIImage *pizzaButtonImage = [UIImage imageNamed:@"pizzaPepperoni300.png"];
	[self.pizzaTimeButton setBackgroundImage:pizzaButtonImage forState:UIControlStateNormal];
	
	UIImage *pizzaButtonImagePressed = [UIImage imageNamed:@"pizzaFullSliceRemove.jpg"];
	[self.pizzaTimeButton setBackgroundImage:pizzaButtonImagePressed forState:UIControlStateHighlighted];
	
//	if (self.methodManager.sound == YES) {
//		[self.speakerButton setBackgroundImage:[self.methodManager playMusic] forState:UIControlStateNormal];
//	}
//	else {
//		[self.speakerButton setBackgroundImage:[self.methodManager stopMusic] forState:UIControlStateNormal];
//	}
	[self.view addSubview:[self.methodManager assignOptionsButton]];
	[self.view addSubview:[self.methodManager assignSpeakerButton]];
	
	// Add an action in current code file (i.e. target)
	[self.pizzaTimeButton addTarget:self
							 action:@selector(pizzaTimeButtonPressed:)
				   forControlEvents:UIControlEventTouchUpInside];
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

// this should show the menu page
-(void)optionsButtonPressed:(UIButton *)optionsButton {
	NSLog(@"optionsButton was pressed");
	// this should open the options page of Pizza Time
	UIViewController *detailViewController = (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"OptionsPage"];
	[self.navigationController pushViewController:detailViewController animated:YES];
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

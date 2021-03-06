//
//  ViewController.m
//  Pizza Time NYC
//
//  Created by JD Leonard on 12/23/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioServices.h>

@interface ViewController ()

// for use of the avAudioPlayer & Menu Button
@property (strong, nonatomic) MethodManager *methodManager;
@property (strong, nonatomic) DAO *dao;

@end

double countHomePage; // for the background Color at the front
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
	countHomePage +=1;

	[self assignSlices];
	[self.dao alertTheUser];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self assignLabels];
	self.methodManager.mapPageBool = NO;
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
		self.dao.hideProgressHud = NO;
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
- (void)assignGif {
//	self.methodManager = [MethodManager sharedManager]; // not necessary, unless move gif to method manager
	
	// animated images implement
	NSArray *imageNames = @[@"KenPizzaMan1.png", @"KenPizzaMan3.png", @"KenPizzaMan5.png", @"KenPizzaMan9.png", @"KenPizzaMan11.png", @"KenPizzaMan13.png", @"KenPizzaMan15.png", @"KenPizzaMan19.png"];
	
	NSMutableArray *images = [[NSMutableArray alloc] init];
	for (int i = 0; i < imageNames.count; i++) {
		[images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
	}
	
	// Normal Animation
	self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
	self.imageView.animationImages = images;
	self.imageView.animationDuration = 0.4;
	
	[self.imageView startAnimating];
	[self.view addSubview:self.imageView];
}
*/

-(void)assignLabels {// and buttons
	
	[self.view addSubview:[self.methodManager assignSpeakerButton]];
	[self.view addSubview:[self.methodManager assignSadPizza]];
	[self.view addSubview:[self.methodManager assignDancingGif]];

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
	 yellow HEX = FFB700
	 darkBlue HEX = 455CC7
	 */
	UIColor *orangeMCQ = [[UIColor alloc]initWithRed:255.0/255.0 green:206.0/255.0 blue:98.0/255.0 alpha:1.0];
	UIColor *greenMCQ = [[UIColor alloc]initWithRed:0/255.0 green:173.0/255.0 blue:104.0/255.0 alpha:1.0];
	UIColor *purpleMCQ = [[UIColor alloc]initWithRed:179/255.0 green:79/255.0 blue:197/255.0 alpha:1.0];
	UIColor *darkBlueMCQ = [[UIColor alloc]initWithRed:69.0/255.0 green:92.0/255.0 blue:199.0/255.0 alpha:1.0];
	// assign background color to change
	switch ((int)countHomePage%4) {
		case 0:
			//					NSLog(@"count is 0 - set blue");
			self.view.backgroundColor = darkBlueMCQ;
			countHomePage +=0.5;
			break;
		case 1://starts here
			//					NSLog(@"Count is 1 - set orange");
			self.view.backgroundColor = orangeMCQ;
			countHomePage +=0.5;
			break;
		case 2:
			//					NSLog(@"Count is 2 - set purple");
			self.view.backgroundColor = purpleMCQ;
			countHomePage +=0.5;
			break;
		case 3:
			//					NSLog(@"Count is 3 - set green");
			self.view.backgroundColor = greenMCQ;
			countHomePage +=0.5;
			break;
		default:
			NSLog(@"CountHomePage is DEFAULT - decide what to do");
			self.view.backgroundColor = darkBlueMCQ;
			countHomePage +=1;
			break;
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)makeNoise:(NSString *)sound ofType:(NSString *)type {
	//Retrieve audio file
//	NSString *path  = [[NSBundle mainBundle] pathForResource:@"cowabunga" ofType:@".m4a"];
//	NSURL *pathURL = [NSURL fileURLWithPath : path];
	NSURL *pathURL = [[NSBundle mainBundle] URLForResource:sound withExtension:type];
//NSLog(@"%@",[pathURL resourceSpecifier]);
	SystemSoundID audioEffect;
	AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
	AudioServicesPlaySystemSound(audioEffect);
	
	// call the following function when the sound is no longer used
	// (must be done AFTER the sound is done playing)
	// Using GCD, we can use a block to dispose of the audio effect without using a NSTimer or something else to figure out when it'll be finished playing.
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		AudioServicesDisposeSystemSoundID(audioEffect);
	});

}

#pragma mark - ACTIONS Slices
/*
 nslog whats opening
 animate: set new location
 complete: open page
 set frame back to original
 */

-(void)leftBPressed:(UIButton *)leftBButton {
//	NSLog(@"Open the FEEDBACK");
	UIViewController *detailViewController = (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"feedbackPage"];
	[self makeNoise:@"annoyedRick" ofType:@"mp3"];
	[UIView animateWithDuration:0.66
					 animations:^{
						 // where is the button going?
						 self.leftB.frame = CGRectMake((self.screenSize.width/12)*-1, (self.screenSize.height/6)*5, self.screenSize.width/3, self.screenSize.height/6);
					 }completion:^(BOOL finished) { //when finished, load the page
						 UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Profile Page Coming Soon"
																			   message:@"Leave feedback in the mean time"
																			  delegate:nil
																	 cancelButtonTitle:@"OK"
																	 otherButtonTitles: nil];
						 
						 [myAlertView show];
						 self.methodManager.rotation = NO;
						 [self presentViewController:detailViewController animated:YES completion:nil];
						 self.leftB.frame = CGRectMake((self.screenSize.width/6), (self.screenSize.height/4)*3, self.screenSize.width/3, self.screenSize.height/6);
					 }];
}

-(void)rightBPressed:(UIButton *)rightBButton {
	//	NSLog(@"Open the ABOUT");
	UIViewController *detailViewController = (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"aboutPage"];
	[self makeNoise:@"ATHFPizzaTime" ofType:@"m4a"];
	[UIView animateWithDuration:0.66
					 animations:^{
						 // where is the button going?
						 self.rightB.frame = CGRectMake((self.screenSize.width/4)*3, (self.screenSize.height/6)*5, self.screenSize.width/3, self.screenSize.height/6);
						 //						 self.rightB.alpha = 0.0;
					 }completion:^(BOOL finished) { //when finished, load the page
						 [self presentViewController:detailViewController animated:YES completion:nil];
						 self.rightB.frame = CGRectMake((self.screenSize.width/2), (self.screenSize.height/4)*3, self.screenSize.width/3, self.screenSize.height/6);
					 }];
}

-(void)leftTPressed:(UIButton *)leftTButton {
	//	NSLog(@"Open the LIST");
	[self makeNoise:@"adventureTimePizza" ofType:@"m4a"];
	if (self.dao.pizzaPlaceArray.count == 0) {
		[self.dao emptyAlert];
	}
	else {
	[UIView animateWithDuration:0.66
					 animations:^{
						 // where is the button going?
						 self.leftT.frame = CGRectMake((self.screenSize.width/12)*-1, (self.screenSize.height/3), self.screenSize.width/3, self.screenSize.height/6);
					 }completion:^(BOOL finished) { //when finished, load the page
						 [self.tabBarController setSelectedIndex:LISTPAGE];
						 self.leftT.frame = CGRectMake((self.screenSize.width/6), (self.screenSize.height/4)*3 - (self.screenSize.height/6), self.screenSize.width/3, self.screenSize.height/6);
					 }];
	}
}

-(void)rightTPressed:(UIButton *)rightTButton {
//	NSLog(@"Open the CLOSEST");
	[self makeNoise:@"krustyKrabPizza" ofType:@"m4a"];
	self.methodManager.directionsShow = YES;
	self.methodManager.closestPP = YES;
	if (self.dao.pizzaPlaceArray.count == 0) {
		[self.dao emptyAlert];
	}
	else {
	[UIView animateWithDuration:0.66
					 animations:^{
						 // where is the button going?
						 self.rightT.frame = CGRectMake((self.screenSize.width/4)*3, (self.screenSize.height/3), self.screenSize.width/3, self.screenSize.height/6);
					 }completion:^(BOOL finished) { //when finished, load the page
						 [self.tabBarController setSelectedIndex:MAPPAGE];
						 self.rightT.frame = CGRectMake((self.screenSize.width/2), (self.screenSize.height/4)*3 - (self.screenSize.height/6), self.screenSize.width/3, self.screenSize.height/6);
					 }];
	}
}

-(void)topPressed:(UIButton *)topButton {
	if (self.dao.pizzaPlaceArray.count == 0) {
		[self.dao emptyAlert];
	}
	else {
	//	NSLog(@"Open the MAP");
	[self makeNoise:@"rickBestPizza" ofType:@"m4a"];
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
}

-(void)bottomPressed:(UIButton *)bottomButton {
	//	NSLog(@"Open the ADD");
	[self makeNoise:@"excellent" ofType:@"m4a"];
	[UIView animateWithDuration:0.66
					 animations:^{
						 // where is the button going?
						 self.bottom.frame = CGRectMake(((self.screenSize.width/2) - (self.screenSize.width/6)), (4*(self.screenSize.height/4) + 15), self.screenSize.width/3, self.screenSize.height/6);
					 }completion:^(BOOL finished) { //when finished, load the page
						 [self.tabBarController setSelectedIndex:ADDPAGE];
						 self.bottom.frame = CGRectMake(((self.screenSize.width/2) - (self.screenSize.width/6)), ((self.screenSize.height/4)*3), self.screenSize.width/3, self.screenSize.height/6 + self.screenSize.height*0.026);
					 }];
}

@end

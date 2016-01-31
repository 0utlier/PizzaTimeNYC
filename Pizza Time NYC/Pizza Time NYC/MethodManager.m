//
//  MethodManager.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/12/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "MethodManager.h"
#import "MapKitViewController.h"
AppDelegate *appDelegate;


@implementation MethodManager

BOOL sound; // silent or loud (NO = 0 = Silent)
/*
 sound 1.20.16
 created in MM
 [not initialized, but assumed YES]
 VC VWA if, set NO
 */
#pragma mark - Singleton Methods

static AVAudioPlayer *p;

+ (id)sharedManager {
	static MethodManager *sharedMyManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedMyManager = [[self alloc] init];
	});
	return sharedMyManager;
}

- (id)init {
	if (self = [super init]) {
	}
	return self;
}

-(AVAudioPlayer*)audioPlayer{
	if(p==nil){
		[self createPlayer];
	}
	
	return p;
}

- (void)dealloc {
	// Should never be called, but just here for clarity really.
}

#pragma mark - CREATE

-(void)createPlayer {
	//	self.window = [[UIApplication sharedApplication] keyWindow];
	//	self.topView = self.window.rootViewController.view;
	
	//iPod playback will be paused with below statement. Comment out if you wish vibeSwitch to determine sound
	[[AVAudioSession sharedInstance]
	 setCategory: AVAudioSessionCategoryPlayback
	 error: nil];
	
	// set song to background
	NSString *backgroundMusic = [[NSBundle mainBundle]pathForResource:@"pizzaMusic" ofType:@"mp3"];
	p = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:backgroundMusic] error:NULL];
	p.numberOfLoops = -1; // -1 is infinite loops
	//	NSLog(@"%f", self.screenSize.width);
}

- (void)createLocationManager {
	self.locationManager = [[CLLocationManager alloc]init];
	if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
		//		NSLog(@"User is on ios 8 or 9");
		[self.locationManager requestWhenInUseAuthorization];
		[self.locationManager startUpdatingLocation];
	}
	else {
		NSLog(@"User's iOS < iOS 8 or 9");
	}
	[self.locationManager setDelegate:self];
	//	[self.locationManager setDistanceFilter:kCLDistanceFilterNone ]; //whenever we move
	[self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
}

- (void)createEmpireStateBuilding {
	// Use Empire State Building as current location
	self.empireStateBuilding = [[CLLocation alloc]initWithLatitude:40.7484 longitude:-73.9857];
}

- (void) createOrientation {
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(orientationChanged:)
	 name:UIDeviceOrientationDidChangeNotification
	 object:[UIDevice currentDevice]];
}



#pragma mark - Buttons

-(UIImage *)playMusic {
	[self.audioPlayer play];
	sound = YES;
	UIImage *speakerButtonImage = [UIImage imageNamed:@"MCQMapSOUND.png"];
	return speakerButtonImage;	// [maybe] set the image here
}

-(UIImage *)stopMusic {
	[self.audioPlayer stop];
	sound = NO;
	UIImage *speakerButtonImage = [UIImage imageNamed:@"MCQMapSOUNDNOT.png"];
	return speakerButtonImage;	// [maybe] set the image here
}

-(UIButton *)assignSpeakerButton {
	
	if(self.speakerButton)return self.speakerButton;
	
	UIButton *speakerButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width -76, 16, 45, 45)];
	// Add an action in current code file (i.e. target)
	[speakerButton addTarget:self
					  action:@selector(speakerButtonPressed:)
			forControlEvents:UIControlEventTouchUpInside];
	
	if (sound == YES) {
		[speakerButton setBackgroundImage:self.playMusic forState:UIControlStateNormal];
	}
	else {
		[speakerButton setBackgroundImage:self.stopMusic forState:UIControlStateNormal];
	}
	self.speakerButton = speakerButton;
	return self.speakerButton;
}

-(UIButton *)assignOptionsButton {
	
	
	if(self.optionsButton)return self.optionsButton;
	
	UIButton *optionsButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 30, 16, 45, 45)];
	// Add an action in current code file (i.e. target)
	[optionsButton addTarget:self
					  action:@selector(optionsButtonPressed:)
			forControlEvents:UIControlEventTouchUpInside];
	
	[optionsButton setBackgroundImage:[UIImage imageNamed:@"MCQMapOPTIONS.png"] forState:UIControlStateNormal];
	self.optionsButton = optionsButton;
	return self.optionsButton;
}

#pragma mark - Actions

// this should disable and enable the sound of the app
-(void)speakerButtonPressed:(UIButton *)speakerButton {
	if (sound) {
		//		NSLog(@"sound disabled"); //disable sound
		[speakerButton setBackgroundImage:self.stopMusic forState:UIControlStateNormal];
		//		self.appDelegate.audioPlayer.rate = 0.0;
	}
	else {
		//		NSLog(@"sound enabled"); //enable sound
		[speakerButton setBackgroundImage:self.playMusic forState:UIControlStateNormal];
		//		self.appDelegate.audioPlayer.rate = 1.0;
	}
}

// Main initial button press
-(void)optionsButtonPressed:(UIButton *)optionsButton {
	//	NSLog(@"optionsButton was pressed");
	self.directionsShow = NO;
	
	// this should open the options page of Pizza Time
	AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	UITabBarController *tabBarController = (UITabBarController *)delegate.window.rootViewController;
	[tabBarController setSelectedIndex:OPTIONSPAGE];
	
}

-(void)searchBarPresent {
	if (self.searching == YES) {
		self.speakerButton.alpha = 0.5;  // set this *after* adding it back
		self.optionsButton.alpha = 0.5;  // set this *after* adding it back
		[UIView animateWithDuration:0.66f animations:^ {
			// hide the buttons again, as bar appears
			self.speakerButton.alpha = 0.0;
			self.optionsButton.alpha = 0.0;
		}];
	}
	else { // searching == NO
		self.speakerButton.hidden = NO;
		self.optionsButton.hidden = NO;
		self.speakerButton.alpha = 1.0;
		self.optionsButton.alpha = 1.0;
	}
}

-(void)removeBothButtons {
	if(self.optionsButton)
		[self.optionsButton removeFromSuperview];
	if(self.speakerButton)
		[self.speakerButton removeFromSuperview];
}

- (void)gifPresent {
//	AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//	UITabBarController *tabBarController = (UITabBarController *)delegate.window.rootViewController;
//	[tabBarController setSelectedIndex:ADDPAGE];
	self.window = [[UIApplication sharedApplication] keyWindow];
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
															 bundle: nil];
	UIViewController *detailViewController = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"GIFPage"];
	[self.window.rootViewController presentViewController:detailViewController animated:YES completion:nil];
}

- (void)orientationChanged:(NSNotification *)note
{
	
	//Obtaining the current device orientation
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
//	NSLog(@"orienation = %ld", (long)orientation);
	if (orientation == UIDeviceOrientationLandscapeRight || orientation == UIDeviceOrientationLandscapeLeft) {
		NSLog(@"turned to side, GIF TIME [if statement]");
		[self performSelector:@selector(gifPresent) withObject:nil afterDelay:0];
					return;
	}
	else {
		NSLog(@"turned back to portrat, UNDO the GIF");
//		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(speakerButtonPressed:) object:nil];
		[self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

	}
//	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(speakerButtonPressed:) object:nil];
//	//Responding only to changes in landscape or portrait
//	currentOrientation = orientation;
//	[self performSelector:@selector(optionsButtonPressed:) withObject:nil afterDelay:0];

/*

	UIDevice * device = note.object;
	switch(device.orientation)
	{
		case UIDeviceOrientationFaceDown:
			// start special animation
			NSLog(@"The iPhone is being held FACE DOWN = scary music");
//			[self performSelector:@selector(gifPresent) withObject:nil afterDelay:0];
			break;
			
		case UIDeviceOrientationPortrait:
			// start special animation
			NSLog(@"The iPhone is returned to PORTRAIT, options page");
			[self performSelector:@selector(optionsButtonPressed:) withObject:nil afterDelay:0];
			break;
			
		case UIDeviceOrientationLandscapeRight:
			// start special animation
			NSLog(@"The iPhone is tilted to the RIGHT, GIF time");
			[self performSelector:@selector(gifPresent) withObject:nil afterDelay:0];
			// present page with GIF, and 1 to the count
			break;

		case UIDeviceOrientationLandscapeLeft:
			// start special animation
			NSLog(@"The iPhone is tilted to the LEFT, GIF time");
			[self performSelector:@selector(gifPresent) withObject:nil afterDelay:0];
			// present page with GIF, and 1 to the count
			break;

		default:
			break;
	};
*/
}


@end

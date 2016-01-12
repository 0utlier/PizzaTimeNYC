//
//  MethodManager.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/12/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "MethodManager.h"

@implementation MethodManager
//@synthesize someProperty;

#pragma mark Singleton Methods

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
//		someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
	}
	return self;
}

- (void)dealloc {
	// Should never be called, but just here for clarity really.
}

#pragma mark CREATE

-(void)createPlayer {
	//iPod playback will be paused with below statement. Comment out if you wish vibeSwitch to determine sound
	[[AVAudioSession sharedInstance]
	 setCategory: AVAudioSessionCategoryPlayback
	 error: nil];
	
	// set song to background
	NSString *backgroundMusic = [[NSBundle mainBundle]pathForResource:@"pizzaMusic" ofType:@"mp3"];
	self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:backgroundMusic] error:NULL];
	//	self.audioPlayer.delegate = self;// unsure of warning
	self.audioPlayer.numberOfLoops = -1; // -1 is infinite loops
	//	[self.audioPlayer play];
//	self.screenSize = [UIScreen mainScreen].bounds.size;
//	NSLog(@"%f", self.screenSize.width);
}
#pragma mark - Buttons & Actions
-(UIImage *)playMusic {
	[self.audioPlayer play];
	self.sound = YES;
	UIImage *speakerButtonImage = [UIImage imageNamed:@"speaker60.png"];
	return speakerButtonImage;	// [maybe] set the image here
}

-(UIImage *)stopMusic {
	[self.audioPlayer stop];
	self.sound = NO;
	UIImage *speakerButtonImage = [UIImage imageNamed:@"speakerCross60.png"];
	return speakerButtonImage;	// [maybe] set the image here
}

-(UIButton *)assignSpeakerButton {
	UIButton *speakerButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width -76, 16, 60, 60)];
	[speakerButton addTarget:self
					  action:@selector(speakerButtonPressed:)
			forControlEvents:UIControlEventTouchUpInside];
	
	if (self.sound == YES) {
		[speakerButton setBackgroundImage:self.playMusic forState:UIControlStateNormal];
	}
	else {
		[speakerButton setBackgroundImage:self.stopMusic forState:UIControlStateNormal];
	}
	self.speakerButton = speakerButton;
	return self.speakerButton;
}

-(UIButton *)assignOptionsButton {
	UIButton *optionsButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 30, 16, 60, 60)];
	// Add an action in current code file (i.e. target)
	[optionsButton addTarget:self
					  action:@selector(optionsButtonPressed:)
			forControlEvents:UIControlEventTouchUpInside];
	
	[optionsButton setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
	self.optionsButton = optionsButton;
	return self.optionsButton;
}

-(UIButton *)assignSearchButton {//incorrect assigning
	UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(16, 16, 60, 60)];
	// Add an action in current code file (i.e. target)
	[searchButton addTarget:self
					 action:@selector(searchButtonPressed:)
		   forControlEvents:UIControlEventTouchUpInside];
	
	[searchButton setBackgroundImage:[UIImage imageNamed:@"search60.png"] forState:UIControlStateNormal];		return searchButton;
}

// this should disable and enable the sound of the app
-(void)speakerButtonPressed:(UIButton *)speakerButton {
	if (self.sound) {
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
	NSLog(@"optionsButton was pressed");
	// this should open the options page of Pizza Time
	AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	UINavigationController *navigationController = (UINavigationController *)delegate.window.rootViewController;
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
	
	UIViewController *detailViewController = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"OptionsPage"];
	[navigationController pushViewController:detailViewController animated:YES];
}

// Main initial button press
-(void)searchButtonPressed:(UIButton *)searchButton {
	NSLog(@"searchButton was pressed");
	// this should hide the buttons and present the search bar of Pizza Time
	//	self.searchBar.hidden = NO;
	//	optionsButton.hidden = YES;
	searchButton.hidden = YES;
	
	
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	UIView *topView = window.rootViewController.view;
	//	NSLog(@"current view = %@", topView);
	
	[topView bringSubviewToFront:self.searchBar];
	self.searchBar.frame = CGRectMake(-320, 0, 320, 480);
	self.searchBar.hidden = NO;
	[UIView animateWithDuration:0.66
					 animations:^{
						 self.searchBar.frame = CGRectMake(0, 0, 320, 480);
					 }];
	[self.searchBar becomeFirstResponder];
	
}

-(void)searchBarPresent {
	self.optionsButton.hidden = YES;
	self.speakerButton.hidden = YES;}


@end

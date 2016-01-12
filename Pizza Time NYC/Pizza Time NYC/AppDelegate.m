//
//  AppDelegate.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 12/23/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+(AppDelegate*) sharedDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	//iPod playback will be paused with below statement. Comment out if you wish vibeSwitch to determine sound
//	[[AVAudioSession sharedInstance]
//	 setCategory: AVAudioSessionCategoryPlayback
//	 error: nil];
//	
//	// set song to background
//	NSString *backgroundMusic = [[NSBundle mainBundle]pathForResource:@"pizzaMusic" ofType:@"mp3"];
//	self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:backgroundMusic] error:NULL];
//	//	self.audioPlayer.delegate = self;// unsure of warning
//	self.audioPlayer.numberOfLoops = -1; // -1 is infinite loops
//	//	[self.audioPlayer play];
	MethodManager *methodManager = [[MethodManager alloc]init];
	[methodManager createPlayer];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	// Saves changes in the application's managed object context before the application terminates.
	[self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
	// The directory the application uses to store the Core Data store file. This code uses a directory named "com.comcom.Pizza_Time_NYC" in the application's documents directory.
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
	// The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
	if (_managedObjectModel != nil) {
		return _managedObjectModel;
	}
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Pizza_Time_NYC" withExtension:@"momd"];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	// The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}
	
	// Create the coordinator and store
	
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Pizza_Time_NYC.sqlite"];
	NSError *error = nil;
	NSString *failureReason = @"There was an error creating or loading the application's saved data.";
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		// Report any error we got.
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
		dict[NSLocalizedFailureReasonErrorKey] = failureReason;
		dict[NSUnderlyingErrorKey] = error;
		error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
		// Replace this with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
	// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
	if (_managedObjectContext != nil) {
		return _managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (!coordinator) {
		return nil;
	}
	_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	[_managedObjectContext setPersistentStoreCoordinator:coordinator];
	return _managedObjectContext;
}

//#pragma mark - Core Data Saving support

- (void)saveContext {
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
	if (managedObjectContext != nil) {
		NSError *error = nil;
		if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}

//#pragma mark - Buttons & Actions
//-(UIImage *)playMusic {
//	[self.audioPlayer play];
//	self.sound = YES;
//	UIImage *speakerButtonImage = [UIImage imageNamed:@"speaker60.png"];
//	return speakerButtonImage;	// [maybe] set the image here
//}
//
//-(UIImage *)stopMusic {
//	[self.audioPlayer stop];
//	self.sound = NO;
//	UIImage *speakerButtonImage = [UIImage imageNamed:@"speakerCross60.png"];
//	return speakerButtonImage;	// [maybe] set the image here
//}
//
//-(UIButton *)assignSpeakerButton {
//	UIButton *speakerButton = [[UIButton alloc]initWithFrame:CGRectMake(self.window.bounds.size.width -76, 16, 60, 60)];
//	[speakerButton addTarget:self
//					  action:@selector(speakerButtonPressed:)
//			forControlEvents:UIControlEventTouchUpInside];
//	
//	if (self.sound == YES) {
//		[speakerButton setBackgroundImage:self.playMusic forState:UIControlStateNormal];
//	}
//	else {
//		[speakerButton setBackgroundImage:self.stopMusic forState:UIControlStateNormal];
//	}
//	self.speakerButton = speakerButton;
//	return self.speakerButton;
//}
//
//-(UIButton *)assignOptionsButton {
//	UIButton *optionsButton = [[UIButton alloc]initWithFrame:CGRectMake(self.window.bounds.size.width/2 - 30, 16, 60, 60)];
//	// Add an action in current code file (i.e. target)
//	[optionsButton addTarget:self
//					  action:@selector(optionsButtonPressed:)
//			forControlEvents:UIControlEventTouchUpInside];
//	
//	[optionsButton setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
//	self.optionsButton = optionsButton;
//	return self.optionsButton;
//}
//
//-(UIButton *)assignSearchButton {//incorrect assigning
//	UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(16, 16, 60, 60)];
//	// Add an action in current code file (i.e. target)
//	[searchButton addTarget:self
//							action:@selector(searchButtonPressed:)
//				  forControlEvents:UIControlEventTouchUpInside];
//
//	[searchButton setBackgroundImage:[UIImage imageNamed:@"search60.png"] forState:UIControlStateNormal];		return searchButton;
//}
//
//// this should disable and enable the sound of the app
//-(void)speakerButtonPressed:(UIButton *)speakerButton {
//	if (self.sound) {
//		//		NSLog(@"sound disabled"); //disable sound
//		[speakerButton setBackgroundImage:self.stopMusic forState:UIControlStateNormal];
//		//		self.appDelegate.audioPlayer.rate = 0.0;
//	}
//	else {
//		//		NSLog(@"sound enabled"); //enable sound
//		[speakerButton setBackgroundImage:self.playMusic forState:UIControlStateNormal];
//		//		self.appDelegate.audioPlayer.rate = 1.0;
//	}
//}
//// Main initial button press
//-(void)optionsButtonPressed:(UIButton *)optionsButton {
//	NSLog(@"optionsButton was pressed");
//	// this should open the options page of Pizza Time
//	UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
//	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//	
//	UIViewController *detailViewController = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"OptionsPage"];
//	[navigationController pushViewController:detailViewController animated:YES];
//}
//
//// Main initial button press
//-(void)searchButtonPressed:(UIButton *)searchButton {
//	NSLog(@"searchButton was pressed");
//	// this should hide the buttons and present the search bar of Pizza Time
//	//	self.searchBar.hidden = NO;
//	//	optionsButton.hidden = YES;
//	searchButton.hidden = YES;
//	
//	
//	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//	UIView *topView = window.rootViewController.view;
////	NSLog(@"current view = %@", topView);
//
//	[topView bringSubviewToFront:self.searchBar];
//	self.searchBar.frame = CGRectMake(-320, 0, 320, 480);
//	self.searchBar.hidden = NO;
//	[UIView animateWithDuration:0.66
//					 animations:^{
//						 self.searchBar.frame = CGRectMake(0, 0, 320, 480);
//					 }];
//	[self.searchBar becomeFirstResponder];
//	
//}
//
//-(void)searchBarPresent {
//	self.optionsButton.hidden = YES;
//	self.speakerButton.hidden = YES;}
@end

//
//  AppDelegate.h
//  Pizza Time NYC
//
//  Created by JD Leonard on 12/23/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>
#import "MethodManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> 



@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(AppDelegate*) sharedDelegate;


@end


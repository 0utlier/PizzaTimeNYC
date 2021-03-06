//
//  MethodManager.h
//  Pizza Time NYC
//
//  Created by JD Leonard on 1/12/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
@class ViewController;

@interface MethodManager : NSObject <CLLocationManagerDelegate>

#define OPTIONSPAGE 0
#define MAPPAGE 1
#define LISTPAGE 2
#define PPINFOPAGE 3
#define ADDPAGE 4
//#define ABOUTPAGE 5 // removed 1.21.16 since tabBar only keeps 5 for company

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;


@property (nonatomic)BOOL searching; // searching or not (NO = 0 = Not)
@property (nonatomic)BOOL searchSubmit; // submitting search or not (NO = 0 = Not)
@property (nonatomic)BOOL directionsShow; // to load the map with or without directions (NO = 0 = not showing directions)
@property (nonatomic)BOOL firstTimeLoaded; // to stop refresh [of map] on initial load (NO = 0 = not the first time)
@property (nonatomic)BOOL userLocAuth; // use to prompt or not // allowed or disabled (YES = enabled or leave alone)
@property (nonatomic)BOOL userLocRemind; // use to prompt or not // remind or do not (NO = 0 = do not)
@property (nonatomic)BOOL closestPP; // use to find closest or not // (NO = 0 = not closest)
@property (nonatomic)BOOL rotation; // use to disable rotation // (NO = 0 = no rotation)
@property (nonatomic)BOOL mapPageBool; // use to remember where to go back // (NO = 0 = not map)
@property (nonatomic)BOOL orientationSet; // use to log if orientation has been set // (NO = 0 = not map)

/*
 searching 1.20.16
 created in MM
 MK & TV set YES (search)
 MK & TV set NO (cancel)
 MM searchBarPresent if, do
 
 searchSubmit 1.26.16
 created in MM
 TV searchSubmit YES for distance(checked), NO after
 MK searchSubmit YES for distance(checked), NO after
 
 directionsShow 1.21.16
 created in MM
 'Oy'
 MM options opened  NO
 PPI directions pressed YES
 VC map pressed NO
 VC closest pressed YES
 TV (distance) if YES, assign value of currentPizzaPlace
 MK (ALOT OF CHECKING ???)
 
 firstTimeLoaded 1.20.16
 created in MM
 VC initialized as YES
 MK check in VWA, set to NO at the end
 
 userLocAuth 1.20.16
 created in MM
 VC initialized as NO
 MK checkEnabled if NO, then alertview
 MK not autho NO
 MK alertView NO
 
 userLocRemind 1.20.16
 created in MM
 VC initialized as YES
 MK set when not found, and user doesn't want to be reminded
 
 closest 1.21.16
 created in MM
 VC init as NO
 MK use during and set NO after
 
 noRotation 2.3.16
 created in MM
 VC init as YES
 
 */
@property (nonatomic, strong) UIButton *optionsButton;
@property (nonatomic, strong) UIButton *speakerButton;
@property (nonatomic, strong) UIImageView *mapButton;
@property (nonatomic, strong) UIImageView *listButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *imageViewImage;

@property (nonatomic, strong) UIWindow *window;
//@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *empireStateBuilding;
@property CGSize statusBarSize;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *buildNumber;

+ (id)sharedManager;

- (void)createPlayer;
- (void)createOrientation;

- (void)createLocationManager;
//- (void)createMapViewController;
- (void)createEmpireStateBuilding;

-(UIImage *)stopMusic;
-(UIImage *)playMusic;

-(UIButton *)assignOptionsButton;
-(UIButton *)assignSpeakerButton;
//-(UIButton *)assignSearchButton;

-(UIImageView *)assignDancingGif;
-(UIImageView *)assignSadPizza;

-(void)removeBothButtons;

-(void)searchBarPresent;

//-(void)searchButtonPressed:(UIButton *)searchButton;

@end

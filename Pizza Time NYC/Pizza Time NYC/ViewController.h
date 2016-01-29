//
//  ViewController.h
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 12/23/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <AVFoundation/AVFoundation.h>
#import "MethodManager.h"
@class MapKitViewController;
#import "TableViewController.h"
#import "DAO.h"

@interface ViewController : UIViewController <AVAudioPlayerDelegate>


// to check the internet connection
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@property (nonatomic) CGSize screenSize;

// Buttons
@property (nonatomic, retain) UIButton *leftB;
@property (nonatomic, retain) UIButton *rightB;
@property (nonatomic, retain) UIButton *leftT;
@property (nonatomic, retain) UIButton *rightT;
@property (nonatomic, retain) UIButton *top;
@property (nonatomic, retain) UIButton *bottom;

//@property (nonatomic, retain) UIImageView *pizzaTimeLogo;
@end


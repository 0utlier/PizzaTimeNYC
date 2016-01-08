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
#import "AppDelegate.h"

@interface ViewController : UIViewController <AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *pizzaTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@property (strong, nonatomic) AppDelegate *appDelegate;


@end


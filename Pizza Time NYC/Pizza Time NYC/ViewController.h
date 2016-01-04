//
//  ViewController.h
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 12/23/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *pizzaTimeButton;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@end


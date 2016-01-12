//
//  MethodManager.h
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/12/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface MethodManager : NSObject

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
//@property CGSize screenSize;


@property (nonatomic)BOOL sound; // silent or loud (NO = 0 = Silent)

@property (nonatomic, strong) UIButton *optionsButton;
@property (nonatomic, strong) UIButton *speakerButton;
@property (nonatomic, strong) UIButton *searchBarButton;

@property (nonatomic, strong) UISearchBar *searchBar;


//@property (nonatomic, retain) NSString *someProperty;

+ (id)sharedManager;
- (void)createPlayer;

-(UIImage *)stopMusic;
-(UIImage *)playMusic;

-(UIButton *)assignOptionsButton;
-(UIButton *)assignSpeakerButton;
-(UIButton *)assignSearchButton;

-(void)searchBarPresent;

-(void)searchButtonPressed:(UIButton *)searchButton;


@end

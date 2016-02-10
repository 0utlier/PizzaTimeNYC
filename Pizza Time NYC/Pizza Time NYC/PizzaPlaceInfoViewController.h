//
//  PizzaPlaceInfoViewController.h
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/6/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PizzaPlace.h"
#import "MethodManager.h"
#import "DAO.h"
@class MapKitViewController;

@interface PizzaPlaceInfoViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) PizzaPlace *currentPizzaPlace;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *directionsButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

// ratings
@property (weak, nonatomic) IBOutlet UIButton *rateUpButton;
@property (weak, nonatomic) IBOutlet UIButton *rateDownButton;

@property (weak, nonatomic) IBOutlet UILabel *rateUpLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateDownLabel;

@property (weak, nonatomic) IBOutlet UIButton *closedButton;

- (void)setLabelValues:(PizzaPlace*)pizzaPlace;

@end

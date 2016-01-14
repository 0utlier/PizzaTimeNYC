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
#import "MapKitViewController.h"

@interface PizzaPlaceInfoViewController : UIViewController

// TAB BAR Properties
//@property (weak, nonatomic) IBOutlet UITabBar *infoTabBar;
@property (strong, nonatomic) MethodManager *methodManager;
//@property (strong, nonatomic) MapKitViewController *mapDirections;
@property (strong, nonatomic) PizzaPlace *currentPizzaPlace;
/*
//information on PizzaPlaceInfo
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *image;

//location of PizzaPlaceInfo
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *city;
@property (nonatomic) NSInteger zip;
@property float latitude;
@property float longitude;
@property float distance;
*/

@property (weak, nonatomic) IBOutlet UIButton *optionsButton;

@property (weak, nonatomic) IBOutlet UIButton *directionsButton;

- (void)setLabelValues:(PizzaPlace*)pizzaPlace;

@end

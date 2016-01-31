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
@class MapKitViewController;
@interface PizzaPlaceInfoViewController : UIViewController

// TAB BAR Properties
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

//@property (weak, nonatomic) IBOutlet UIButton *optionsButton; // removed for MM buttons

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *directionsButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


- (void)setLabelValues:(PizzaPlace*)pizzaPlace;

@end

//
//  PizzaPlaceDirectionsViewController.h
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/6/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PizzaPlace.h"
//#import "AppDelegate.h"
#import "MethodManager.h"

@interface PizzaPlaceDirectionsViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic) MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;

@property (nonatomic, retain) MKUserLocation *UserLocationProperty;

@property (nonatomic, retain) PizzaPlace *currentPizzaPlace;

// for use of the avAudioPlayer
//@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) MethodManager *methodManager;

@property (weak, nonatomic) IBOutlet UIButton *speakerButtonDirectPage;


-(void)setPizzaPlaceProperty:(PizzaPlace *)pizzaPlace;
- (void)setDirectionalValues:(PizzaPlace *)pizzaPlace;

@end

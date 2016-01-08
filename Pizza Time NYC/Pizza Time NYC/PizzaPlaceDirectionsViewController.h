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

@interface PizzaPlaceDirectionsViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic) MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;

@property (nonatomic, retain) MKUserLocation *UserLocationProperty;

@property (nonatomic, retain) PizzaPlace *currentPizzaPlace;

-(void)setPizzaPlaceProperty:(PizzaPlace *)pizzaPlace;
- (void)setDirectionalValues:(PizzaPlace *)pizzaPlace;

@end

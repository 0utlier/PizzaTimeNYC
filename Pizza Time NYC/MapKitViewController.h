//
//  MapKitViewController.h
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 12/23/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PizzaPlace.h"
#import "WebViewController.h"

@interface MapKitViewController : ViewController <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>// in case we want to search for address

@property (nonatomic) MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;

// TOOL BAR Properties
@property (weak, nonatomic) IBOutlet UIToolbar *mapToolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addPizzaPlaceButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchAddressButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *currentLocationButton;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

//@property (nonatomic,retain) PizzaPlace *pizzaPlace;// i do not believe I need this
@property(nonatomic, retain) NSMutableArray *pizzaPlaceArray;

@property (nonatomic, retain) MKUserLocation *UserLocationProperty;


@end

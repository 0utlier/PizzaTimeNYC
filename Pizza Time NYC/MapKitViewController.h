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
#import "DAO.h"
#import "PizzaPlace.h"
#import "WebViewController.h"
#import "PizzaPlaceInfoViewController.h"
#import "PizzaPlaceDirectionsViewController.h"
#import "MethodManager.h"


@interface MapKitViewController : ViewController <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UITabBarDelegate, UITabBarControllerDelegate, UIGestureRecognizerDelegate>// in case we want to search for address

@property (nonatomic) MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic, retain) MKUserLocation *UserLocationProperty;

// DAO info and methods
@property (nonatomic, strong) DAO *dao;
//@property (strong, nonatomic) MethodManager *methodManager;


// TOOL BAR Properties
@property (weak, nonatomic) IBOutlet UIToolbar *mapToolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addPizzaPlaceButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchAddressButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *currentLocationButton;

// search button
@property (weak, nonatomic) IBOutlet UIButton *searchButtonMapPage;

// TAB BAR Properties
//@property (weak, nonatomic) IBOutlet UITabBar *mapTabBar;


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

//@property (nonatomic,retain) PizzaPlace *pizzaPlace;// i do not believe I need this
//@property(nonatomic, retain) NSMutableArray *pizzaPlaceArray; //moved to DAO

@property CGSize statusBarSize;


// for directions given
@property (nonatomic, retain) PizzaPlace *currentPizzaPlace;

-(void)setPizzaPlaceProperty:(PizzaPlace *)pizzaPlace;
- (void)setDirectionalValues:(PizzaPlace *)pizzaPlace;

@end

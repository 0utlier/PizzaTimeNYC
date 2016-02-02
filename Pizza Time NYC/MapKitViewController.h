//
//  MapKitViewController.h
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 12/23/15.
//  Copyright © 2015 TTT. All rights reserved.
//

#import "ViewController.h"
#include <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DAO.h"
#import "PizzaPlace.h"
#import "PizzaPlaceInfoViewController.h"
#import "MethodManager.h"


@interface MapKitViewController : ViewController <MKMapViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate>

// here is the map
@property (nonatomic) MKMapView *mapView;

// current Location button
@property (weak, nonatomic) IBOutlet UIButton *searchButtonMapPage;
// search button
@property (weak, nonatomic) IBOutlet UIButton *currentLocationButtonMapPage;
// 'TabBar' Buttons on bottom of page
@property (weak, nonatomic) IBOutlet UIButton *mapButtonMapPage;
@property (weak, nonatomic) IBOutlet UIButton *listButtonMapPage;


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

// for directions given
@property (nonatomic, retain) PizzaPlace *currentPizzaPlace;
@property (nonatomic, retain) MKDirections *directions;


//-(void)currentLocationButtonPressed;
-(void)findDistance:(CLLocation *)userLocation; // called in sortByDistance
-(void)sortByDistanceForClosest;
@end

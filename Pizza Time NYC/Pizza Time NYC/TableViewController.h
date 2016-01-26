//
//  TableViewController.h
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/4/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DAO.h"
#import "PizzaPlaceInfoViewController.h"
#import "PizzaPlaceDirectionsViewController.h"
#import "MethodManager.h"
@class MapKitViewController;

@interface TableViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, retain) DAO *dao;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *searchButtonTableView;

@property (weak, nonatomic) IBOutlet UIButton *mapButtonListPage;
@property (weak, nonatomic) IBOutlet UIButton *listButtonListPage;

// for use of the avAudioPlayer & Menu Button
@property (strong, nonatomic) MethodManager *methodManager;

// refresh control
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIView *refreshLoadingView;
@property (strong, nonatomic) UIView *refreshColorView;
@property (strong, nonatomic) UIImageView *dollarImage;
@property (strong, nonatomic) UIImageView *pizzaImage;


@end

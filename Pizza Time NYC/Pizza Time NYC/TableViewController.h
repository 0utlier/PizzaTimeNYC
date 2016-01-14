//
//  TableViewController.h
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/4/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKitViewController.h"
#import "DAO.h"
#import "PizzaPlaceInfoViewController.h"
#import "PizzaPlaceDirectionsViewController.h"
//#import "AppDelegate.h"
#import "MethodManager.h"

@interface TableViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) DAO *dao;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *searchButtonTableView;

// added 1.13.16 attempt to load tabBar at bottom of page without map linking (currently no relationship)
@property (weak, nonatomic) IBOutlet UITabBar *mapTabBar;

// for use of the avAudioPlayer & Menu Button
//@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) MethodManager *methodManager;

@property CGSize statusBarSize;

@end
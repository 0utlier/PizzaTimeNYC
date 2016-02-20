//
//  TableViewController.h
//  Pizza Time NYC
//
//  Created by JD Leonard on 1/4/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"
#import "PizzaPlaceInfoViewController.h"
#import "MethodManager.h"

@interface TableViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//buttons
@property (weak, nonatomic) IBOutlet UIButton *searchButtonTableView;
@property (weak, nonatomic) IBOutlet UIButton *mapButtonListPage;
@property (weak, nonatomic) IBOutlet UIButton *listButtonListPage;

// refresh control
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIView *refreshLoadingView;
@property (strong, nonatomic) UIView *refreshColorView;
@property (strong, nonatomic) UIImageView *dollarImage;
@property (strong, nonatomic) UIImageView *pizzaImage;


@end

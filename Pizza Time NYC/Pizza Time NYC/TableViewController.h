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

@interface TableViewController : UITableViewController

@property (nonatomic, retain) MapKitViewController *mapKitViewController; // unsure if I need this
@property (nonatomic, retain) DAO *dao;

@end

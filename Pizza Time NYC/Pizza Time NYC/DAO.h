//
//  DAO.h
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 1/4/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PizzaPlace.h"
#import <Parse/Parse.h>

@interface DAO : NSObject

@property (nonatomic, retain) NSMutableArray *pizzaPlaceArray;
@property (nonatomic, retain) NSMutableArray *gifArray;

//Parse Methods
- (void)fromLocalDataPP;
- (void)downloadParsePP;
//- (void)saveParse;
- (void)fromLocalDataGifs;
- (void)downloadParseGifs;
+ (instancetype)sharedDAO;


@end

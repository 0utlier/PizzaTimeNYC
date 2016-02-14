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
#import "MBProgressHUD.h"

@interface DAO : NSObject

@property (nonatomic, retain) NSMutableArray *pizzaPlaceArray;
@property (nonatomic, retain) NSMutableArray *gifArray;
@property (nonatomic, retain) MBProgressHUD *hud;

+ (instancetype)sharedDAO;

#pragma mark - Parse Methods
//LOADING hud
- (MBProgressHUD *)progresshud:(NSString *)label;

//pizza places
- (void)fromLocalDataPP;
- (void)downloadParsePP;

//gifs
- (void)fromLocalDataGifs;
- (void)downloadParseGifs;

// ratings
- (void)likePizzaPlaceWithName:(NSString *)name;
- (void)dislikePizzaPlaceWithName:(NSString *)name;

// add new place
-(void)addNewPizzaPlace:(NSString *)name address:(NSString *)address location:(CLLocation *)location imageData:(NSData *)imageData block:(PFBooleanResultBlock)block;

//feedback submissions
- (void)feedbackSubmission:(NSString *)feedback build:(NSString *)build email:(NSString *)email type:(NSString *)type;
- (void)closedSubmission:(PizzaPlace *)pizzaPlace;
@end

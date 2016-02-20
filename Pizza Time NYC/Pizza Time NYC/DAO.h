//
//  DAO.h
//  Pizza Time NYC
//
//  Created by JD Leonard on 1/4/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PizzaPlace.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "TMReachability.h"

@interface DAO : NSObject <UIAlertViewDelegate>

@property (nonatomic, retain) NSMutableArray *pizzaPlaceArray;
@property (nonatomic, retain) NSMutableArray *gifArray;
@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, retain) PFObject *alertObject;

@property (nonatomic) BOOL hideProgressHud; // hide it or not (NO = 0 = Not)
/*
 hideProgressHud 2.20.16
 created in DAO
 VC set to NO
 MK & TV set YES (hide)
 where to reset?
*/

+ (instancetype)sharedDAO;

#pragma mark - Parse Methods
//LOADING hud
- (MBProgressHUD *)progresshud:(NSString *)label withColor:(UIColor *)color;// withSize:(CGRect)size;
- (MBProgressHUD *)textOnlyHud:(NSString *)label;


//pizza places
- (void)fromLocalDataPP;
//- (void)downloadParsePP; //not necessary outside of the DAO

//gifs
- (void)fromLocalDataGifs;
- (void)downloadParseGifs;

//ratings
- (void)likePizzaPlaceWithName:(NSString *)name;
- (void)dislikePizzaPlaceWithName:(NSString *)name;

//add new place
- (void)addNewPizzaPlace:(NSString *)name address:(NSString *)address location:(CLLocation *)location imageData:(NSData *)imageData block:(PFBooleanResultBlock)block;

//feedback submissions
- (void)feedbackSubmission:(NSString *)feedback build:(NSString *)build email:(NSString *)email type:(NSString *)type;
- (void)closedSubmission:(PizzaPlace *)pizzaPlace;

//user replys
- (void)alertTheUser;
- (void)emptyAlert;
@end

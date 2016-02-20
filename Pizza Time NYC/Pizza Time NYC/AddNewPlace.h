//
//  AddNewPlace.h
//  Pizza Time NYC
//
//  Created by JD Leonard on 1/21/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MethodManager.h"
#import "DAO.h"

@interface AddNewPlace : UIViewController <UIImagePickerControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

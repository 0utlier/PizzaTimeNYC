//
//  FeedbackPageViewController.h
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 2/2/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackPageViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *appVersion;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIImageView *pizzaTime;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)segmentedControl:(id)sender;

@end

//
//  FeedbackPageViewController.m
//  Pizza Time NYC
//
//  Created by Aditya Narayan on 2/2/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "FeedbackPageViewController.h"
#import <AudioToolbox/AudioServices.h>
#import "MethodManager.h"
#import "DAO.h"
//#import <Parse/Parse.h>

@interface FeedbackPageViewController ()
@property (strong, nonatomic) MethodManager *methodManager;
@property (strong, nonatomic) DAO *dao;
@property (strong, nonatomic) NSString *typeFeedback;
@end

@implementation FeedbackPageViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.methodManager = [MethodManager sharedManager];
	self.dao = [DAO sharedDAO];
	// Do any additional setup after loading the view.
	self.feedbackTextField.delegate = self;
	self.emailText.delegate = self;
	self.appVersion.text = self.methodManager.buildNumber;
	self.typeFeedback = @"Positive"; //default
	[self.submitButton addTarget:self
						  action:@selector(submitButtonPressed:)
				forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width/2)-22, 16, 45, 45)];
	// Add an action in current code file (i.e. target)
	[backButton addTarget:self
				   action:@selector(backButtonPressed:)
		 forControlEvents:UIControlEventTouchUpInside];
	
	[backButton setBackgroundImage:[UIImage imageNamed:@"MCQppiBACK.png"] forState:UIControlStateNormal];
	[self.view addSubview:backButton];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(IBAction)segmentedControl:(id)sender
{
	switch (self.segmentControl.selectedSegmentIndex)
	{
		case 0:
			self.typeFeedback = @"Positive";
			break;
		case 1:
			self.typeFeedback = @"Error";
			break;
		case 2:
			self.typeFeedback = @"Request";
			break;
		default:
			break;
	}
}

#pragma mark - ACTIONS

-(void)submitButtonPressed:(UIButton *)submitButton {
	if ([self.feedbackTextField.text isEqualToString:@"Send constructive and productive feedback!"]) {
		UIAlertView *noFeedbackAlert = [[UIAlertView alloc] initWithTitle:@"You didn't say anything?"
																  message:@""
																 delegate:self
														cancelButtonTitle:@"Edit"
														otherButtonTitles: @"Home Page",nil];
		[noFeedbackAlert show];

	}
	else {
	// create a PFObject and parse it!
		[self.dao feedbackSubmission:self.feedbackTextField.text build:self.methodManager.buildNumber email:self.emailText.text type:self.typeFeedback];
	/* // moved to DAO 2.10.16
	 PFObject *feedbackParse = [PFObject objectWithClassName:@"FeedbackParse"];
	feedbackParse[@"feedbackString"] = self.feedbackTextField.text;
	feedbackParse[@"build"] = [self buildNumberInfo];
	feedbackParse[@"userEmail"] = self.emailText.text;
	feedbackParse[@"typeFeedback"] = self.typeFeedback;
	feedbackParse[@"user"] = [PFUser currentUser];

	[feedbackParse saveEventually];
	//	NSLog(@"Submit pressed with:\n %@\n %@", feedbackInfo,[self buildNumberInfo]);
	*/
		
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Thank You!"
														  message:@"We will look at your feedback!"
														 delegate:nil
												cancelButtonTitle:@"OK"
												otherButtonTitles: nil];
	
	[myAlertView show];
	[self dismissViewControllerAnimated:YES completion:nil];
	}
}

-(void)backButtonPressed:(UIButton *)backButton {
	// return to optionsPage
	self.methodManager.rotation = YES;
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TextField Methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	// remove placeHolder text if that's what's there
	if ([self.emailText.text isEqualToString:@"Email (Optional)"]) {
		self.emailText.text = @"";
	}
	return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
	// remove placeHolder text if that's what's there
	if ([self.emailText.text isEqualToString:@""]) {
		self.emailText.text = @"Email (Optional)";
	}
	[self.view endEditing:YES];
	return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

#pragma mark - TextView Methods

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	// remove placeHolder text if that's what's there
	if ([self.feedbackTextField.text isEqualToString:@"Send constructive and productive feedback!"]) {
		self.feedbackTextField.text = @"";
	}
	return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
	// remove placeHolder text if that's what's there
	if ([self.feedbackTextField.text isEqualToString:@""]) {
		self.feedbackTextField.text = @"Send constructive and productive feedback!";
	}
	[self.view endEditing:YES];
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	if([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		return NO;
	}
	else if ([text isEqualToString:@"p"]) {
		NSLog(@"P was pressed");
		//Retrieve audio file
		NSString *path  = [[NSBundle mainBundle] pathForResource:@"annoyedRick" ofType:@"mp3"];
		NSURL *pathURL = [NSURL fileURLWithPath : path];
		
		SystemSoundID audioEffect;
		AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
		AudioServicesPlaySystemSound(audioEffect);
		
		// call the following function when the sound is no longer used
		// (must be done AFTER the sound is done playing)
		// Using GCD, we can use a block to dispose of the audio effect without using a NSTimer or something else to figure out when it'll be finished playing.
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			AudioServicesDisposeSystemSoundID(audioEffect);
		});
	}
	
	return YES;
}
- (void)keyboardDidShow:(NSNotification *)notification
{
	// Assign new frame to your view
	CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardRect = [self.view convertRect:keyboardRect fromView:nil]; //this is it!
	//	[self.view setFrame:CGRectMake(0,0 - keyboardRect.size.height,CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
	CGPoint scrollPoint = CGPointMake(0.0, self.feedbackTextField.frame.origin.y);// - keyboardRect.size.height + self.feedbackTextField.bounds.size.height);
	if ([self.emailText isEditing]) {
		scrollPoint = CGPointMake(0.0, self.submitButton.frame.origin.y - keyboardRect.size.height + self.submitButton.bounds.size.height);
	}
	[self.scrollView setContentOffset:scrollPoint animated:YES];
 
	
}

-(void)keyboardDidHide:(NSNotification *)notification
{
	//	[self.view setFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
	[self.scrollView setContentOffset:CGPointZero animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UIAlertView

// bring user to settings of Pizza Time (stock settings)
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
#pragma mark 1 - Blank Submission
	// 1 // text field is blank
	if ([alertView.title isEqualToString:@"You didn't say anything?"]) {
		if (buttonIndex == 1) {
			NSLog(@"user requested home");
			[self dismissViewControllerAnimated:YES completion:nil];
		}
	}
}
	



@end

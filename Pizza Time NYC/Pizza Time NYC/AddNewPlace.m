//
//  AddNewPlace.m
//  Pizza Time NYC
//
//  Created by JD Leonard on 1/21/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "AddNewPlace.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AddressBookUI/AddressBookUI.h>
@interface AddNewPlace ()

// for use of the avAudioPlayer & Menu Button
@property (strong, nonatomic) MethodManager *methodManager;
@property (strong, nonatomic) DAO *dao;
@property (nonatomic, strong) CLLocation *location;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewios7;

@property BOOL foundLocation;

/*
 foundLocation 2.3.16
 created AddNew
 set as NO
 check for updateLocation
 set during locButton pressed
 set during photo taken
 */

@end

@implementation AddNewPlace

- (void)viewDidLoad {
	[super viewDidLoad];
	self.methodManager = [MethodManager sharedManager];
	self.dao = [DAO sharedDAO];
	self.foundLocation = NO;
	self.addressTextField.delegate = self;
	self.nameTextField.delegate = self;
	self.methodManager.locationManager.delegate = self;
	self.location = [[CLLocation alloc]init];
	
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	[self assignLabels];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


-(void)assignLabels {// and buttons
	[self.methodManager removeBothButtons];
	[self.view addSubview:[self.methodManager assignOptionsButton]];
	[self.view addSubview:[self.methodManager assignSpeakerButton]];
	
	UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(16, 16, 45, 45)];
	self.backButton = backButton;
	// Add an action in current code file (i.e. target)
	[self.backButton addTarget:self
						action:@selector(backButtonPressed:)
			  forControlEvents:UIControlEventTouchUpInside];
	
	[self.backButton setBackgroundImage:[UIImage imageNamed:@"MCQppiBACK.png"] forState:UIControlStateNormal];
	[self.view addSubview:self.backButton];
	
	[self.locationButton addTarget:self
							action:@selector(locationButtonPressed:)
				  forControlEvents:UIControlEventTouchUpInside];
	
	[self.cameraButton addTarget:self
						  action:@selector(cameraButtonPressed:)
				forControlEvents:UIControlEventTouchUpInside];
	
	[self.addButton addTarget:self
					   action:@selector(addButtonPressed:)
			 forControlEvents:UIControlEventTouchUpInside];
	
}

#pragma mark - ACTIONS

-(void)backButtonPressed:(UIButton *)backButton {
	//	NSLog(@"backButton was pressed");
	if (self.methodManager.mapPageBool == YES) {
		[self.tabBarController setSelectedIndex:MAPPAGE];
	}
	else {
	[self.tabBarController setSelectedIndex:OPTIONSPAGE];
	}
}

- (void)locationButtonPressed:(UIButton *)locationButton {
	self.addressTextField.text = @"";
	self.foundLocation = NO;
	[self.methodManager.locationManager startUpdatingLocation];
	if (self.methodManager.locationManager.location.coordinate.latitude == 0.0 || self.methodManager.locationManager.location.coordinate.longitude == 0.0) {
		//		NSLog(@"Present an alert");
		UIAlertView *notFoundAlert = [[UIAlertView alloc] initWithTitle:@"Oops!"
																message:@"We could not find your location!"
															   delegate:nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles: nil];
		[notFoundAlert show];
	}
	[self addressLookUp:self.methodManager.locationManager.location];
}


-(void)cameraButtonPressed:(UIButton *)cameraButton {
	//	NSLog(@"camera button pressed, open camera or library");
	[self.addressTextField resignFirstResponder];
	[self.nameTextField resignFirstResponder];
	if (self.imageView.image == NULL) {
		
		UIActionSheet *photoChoice = [[UIActionSheet alloc]initWithTitle:nil
																delegate:self
													   cancelButtonTitle:@"Cancel"
												  destructiveButtonTitle:nil
													   otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
		[photoChoice showInView:self.view];
	}
	else { // picture exists
		UIActionSheet *photoChoice = [[UIActionSheet alloc]initWithTitle:nil
																delegate:self
													   cancelButtonTitle:@"Cancel"
												  destructiveButtonTitle:nil
													   otherButtonTitles: @"Take a new photo", @"Choose from existing", @"Remove Photo", nil];
		[photoChoice showInView:self.view];
	}
}

-(void)addButtonPressed:(UIButton *)addButton {
	[self.addressTextField resignFirstResponder];
	[self.nameTextField resignFirstResponder];

	NSString *submission = [NSString stringWithFormat:@"User has found %@, which is located: %@", self.nameTextField.text, self.addressTextField.text];
	NSLog(@"addButton was pressed - submit info to developer \n%@", submission);
	
	if ([self.nameTextField.text isEqual:@""] || [self.addressTextField.text isEqual:@""]) {
		UIAlertView *noNameAlert = [[UIAlertView alloc] initWithTitle:@"Is there a name/address?"
															  message:@"Pizza Places need a name AND address"
															 delegate:self
													cancelButtonTitle:@"Edit"
													otherButtonTitles: @"Its in the picture!",nil];
		[noNameAlert show];
	}
	else if (self.imageView.image == NULL) {
		UIAlertView *noImageAlert = [[UIAlertView alloc] initWithTitle:@"Is there a picture?"
																  message:@"Pizza Places like to have pictures"
																 delegate:self
														cancelButtonTitle:@"Edit"
														otherButtonTitles: @"I do not have one",nil];
		[noImageAlert show];
	}
	else {
		// create a PFObject and parse it!
		NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
		// Show progress
		UIColor *orangeMCQ = [[UIColor alloc]initWithRed:255.0/255.0 green:206.0/255.0 blue:98.0/255.0 alpha:1.0];
		MBProgressHUD *hud = [self.dao progresshud:@"Sending Pizza" withColor:orangeMCQ];
		self.cameraButton.hidden = YES;
		PFBooleanResultBlock block = ^(BOOL succeeded, NSError * _Nullable error) {
			[hud hideAnimated:YES];
			if (succeeded) {
				UIAlertView *submitAlert = [[UIAlertView alloc] initWithTitle:@"Thank You!"
																	  message:@"We will look into your Submission!"
																	 delegate:nil
															cancelButtonTitle:@"OK"
															otherButtonTitles: nil];
				[submitAlert show];
				[self resetFields];
				[self.tabBarController setSelectedIndex:OPTIONSPAGE];
			}
			else { //failed
				UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"We were unable to receive your submission!"
																	message:@"Please try again!"
																   delegate:nil
														  cancelButtonTitle:@"OK"
														  otherButtonTitles: nil];
				[failAlert show];
			}
			self.cameraButton.hidden = NO;
		};
		[self.dao addNewPizzaPlace:self.nameTextField.text address:self.addressTextField.text location:self.location imageData:imageData block:block];
	}
}

- (void)resetFields {
	self.nameTextField.text = @"";
	self.addressTextField.text = @"";
	self.imageView.image = NULL;
}

- (void)addressLookUp:(CLLocation *)location {
	self.location = location;
	// turn the latLong into an address
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	[geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error) {
		NSLog(@"Finding address");
		if (error) {
			NSLog(@"Error %@", error.description);
			UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
																  message:@"Cannot Find Address from given location"
																 delegate:nil
														cancelButtonTitle:@"OK"
														otherButtonTitles: nil];
			
			[myAlertView show];
			self.addressTextField.text = @"No connection";
		} else {
			CLPlacemark *placemark = [placemarks lastObject];
			self.addressTextField.text = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
			NSLog(@"address text = %@", self.addressTextField.text);
		}
	}];
}


#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
	[self.view endEditing:YES];
	return YES;
}

/* // none of these methods are necessary
 -(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	return YES;
 }
 
 - (void)keyboardDidShow:(NSNotification *)notification
 {
	
 }
 
 -(void)keyboardDidHide:(NSNotification *)notification
 {
	
 }
 */

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
	NSInteger nextTag = textField.tag + 1;
	// Try to find next responder
	UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
	if (nextResponder) {
		// Found next responder, so set it.
		[nextResponder becomeFirstResponder];
	} else {
		// Not found, so remove keyboard.
		[textField resignFirstResponder];
	}
	return NO; // We do not want UITextField to insert line-breaks.
}


#pragma mark - Camera Selection

- (BOOL)checkForCamera {
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
															  message:@"Device has no camera"
															 delegate:nil
													cancelButtonTitle:@"OK"
													otherButtonTitles: nil];
		
		[myAlertView show];
		return NO;
	}
	return YES;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	int i = (int) buttonIndex;
	
	switch(i) {
			
		case 0:
		{
			//Code for camera
			if ([self checkForCamera]) {
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
				picker.delegate = self;
				picker.allowsEditing = YES;
				picker.sourceType = UIImagePickerControllerSourceTypeCamera;
				
				[self presentViewController:picker animated:YES completion:NULL];
			}
		}
			break;
		case 1:
		{
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.delegate = self;
			picker.allowsEditing = YES;
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			
			[self presentViewController:picker animated:YES completion:NULL];
		}
			break;
		case 2:
		{
			self.imageView.image = NULL;
		}
			
		default:
			// Do Nothing.........
			break;
			
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	// NSLog(@"Picker returned successfully.");
	self.imageView.image = NULL;

	UIImage *selectedImage;
	
	NSURL *mediaUrl;
	
	mediaUrl = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
	
	if (mediaUrl == nil) {
		
		selectedImage = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
		if (selectedImage == nil) {
			
			selectedImage = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
			NSLog(@"Original image picked.");
			
		}
		else {
			
			NSLog(@"Edited image picked.");
			
		}
		
	}
	[self imageCoordinate:info];
	[self dismissViewControllerAnimated:YES completion:nil];
	
	if ([UIAlertController class]) {
		// user is above ios 7
		self.imageView.image = selectedImage;
		
	} else { // iOS 7 imageview remade
		NSLog(@"User's iOS < iOS 8 or 9");
		if (self.imageViewios7.image == NULL) {
			self.imageViewios7 = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2)];
			self.imageViewios7.image = selectedImage;
			self.imageViewios7.alpha = 0.5;
			[self.view addSubview:self.imageViewios7];
		}
		else {
			self.imageViewios7.image = nil;
			self.imageViewios7.image = selectedImage;
			
		}
	}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCoordinate:(NSDictionary *)info {
	NSURL *photoUrl = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
	ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
	[assetsLibrary assetForURL:photoUrl resultBlock:^(ALAsset *photoAsset) {
	 CLLocation *location = [photoAsset valueForProperty:ALAssetPropertyLocation];
		if (location.coordinate.latitude == 0.0 || location.coordinate.longitude == 0.0) { // if the latLong is not showing up, use current location
			//			NSLog(@"Present an alert");
			UIAlertView *notFoundAlert = [[UIAlertView alloc] initWithTitle:@"We could not find the location from the image!"
															  message:@"We will use your current location!"
																   delegate:nil
														  cancelButtonTitle:@"OK"
														  otherButtonTitles: nil];
			[notFoundAlert show];
			self.foundLocation = NO;
			[self.methodManager.locationManager startUpdatingLocation]; // unsure if I need this or not 2.1.16
			//			self.addressTextField.text = [NSString stringWithFormat:@"%f & %f", self.methodManager.locationManager.location.coordinate.latitude, self.methodManager.locationManager.location.coordinate.longitude];
			[self addressLookUp:self.methodManager.locationManager.location];
		}
		else {
			[self addressLookUp:location];
			//			NSString *latLong = [NSString stringWithFormat:@"%f & %f",location.coordinate.latitude, location.coordinate.longitude];
			//			self.addressTextField.text = latLong;
		}
		/* // not sure what this would do, if not setting the location to the image
		 NSMutableDictionary *exifDataDict = [[NSMutableDictionary alloc]init];
		 if (location!=nil) {
		 [exifDataDict setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"latitude"];
		 [exifDataDict setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"longitude"];
		 }
		 */
	} failureBlock:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	if (self.foundLocation){return;}
	//	NSLog(@"locations = %@",[locations lastObject]);
	[self.methodManager.locationManager stopUpdatingLocation];
	self.foundLocation = YES;
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
	if ([alertView.title isEqualToString:@"Is there a name/address?"]) {
		if (buttonIndex == 1) {
			NSLog(@"user submitted, hopefully with picture");
			// create a PFObject and parse it!
			if ([self.nameTextField.text isEqual:@""]) {
				self.nameTextField.text = @"In The Picture";
			}
			else {
				self.addressTextField.text = @"In The Picture";
			}
			[self addButtonPressed:self.addButton]; // go back and submit again
		}
		else {
			NSLog(@"user decided to edit the submission");
		}
	}
	
#pragma mark 2 - Blank Image
	// 2 // image is blank
	if ([alertView.title isEqualToString:@"Is there a picture?"]) {
		if (buttonIndex == 1) {
			NSLog(@"user submitted, without a picture");
			// set image as sad pizza
			UIImage *sadPizzaMan = [UIImage imageNamed:@"KenSadPizzaManAlpha.png"];
			self.imageView.image = sadPizzaMan;
			
			[self addButtonPressed:self.addButton]; // go back and submit again
		}
		else {
			NSLog(@"user decided to edit the submission");
		}
	}
}

@end

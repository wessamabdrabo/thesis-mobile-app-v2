//
//  RatingViewController.h
//  recSysAppV1
//
//  Created by Wessam Abdrabo on 7/26/15.
//  Copyright (c) 2015 tum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backToVideos;
@property (weak, nonatomic) IBOutlet UITextField *reviewTextField;

@end

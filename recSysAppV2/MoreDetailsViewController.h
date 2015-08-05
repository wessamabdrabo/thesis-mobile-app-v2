//
//  MoreDetailsViewController.h
//  recSysAppV1
//
//  Created by Wessam Abdrabo on 8/4/15.
//  Copyright (c) 2015 tum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *descrTextView;
- (IBAction)closeBtnClicked:(id)sender;
@property(nonatomic, strong) NSString* descrText;
@end

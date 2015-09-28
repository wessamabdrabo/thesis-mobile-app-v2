//
//  DetailsViewController.h
//  recSysAppV1
//
//  Created by Wessam Abdrabo on 7/26/15.
//  Copyright (c) 2015 tum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCast.h"
@interface DetailsViewController : UIViewController <UIAlertViewDelegate>
- (IBAction)watchVideoClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property (strong, nonatomic) NSString* videoID;
@property (weak, nonatomic) IBOutlet UILabel *postedOnLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoLongDescr;
@property (weak, nonatomic) IBOutlet UIImageView *playerImgView;
@property (weak, nonatomic) IBOutlet UIImageView *playerBgImgView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *footerViewLabel;

@end

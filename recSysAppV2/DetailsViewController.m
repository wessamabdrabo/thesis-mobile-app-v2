//
//  DetailsViewController.m
//  recSysAppV1
//
//  Created by Wessam Abdrabo on 7/26/15.
//  Copyright (c) 2015 tum. All rights reserved.
//

#import "DetailsViewController.h"
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RatingViewController.h"
#import "VideosDataManager.h"
#import "MoreDetailsViewController.h"
#import "CommManager.h"

@interface DetailsViewController (){
    MPMoviePlayerViewController *_moviePlayerController;
    VideoCast* _video;
}
@property(nonatomic) CGAffineTransform transform;   // default is CGAffineTransformIdentity. animatable
@property(strong,nonatomic)    UIDynamicAnimator* animator;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _video = [[VideosDataManager sharedManager] getVideobyID:self.videoID];
    self.videoTitle.text = _video.title;
    self.videoLongDescr.text = _video.longDescr;
    self.speakerLabel.text = _video.speaker;
    self.postedOnLabel.text = _video.posted_on;
    self.durationLabel.text = _video.duration;
    NSString *imageUrl = _video.imgName;
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        self.imageView.image = [UIImage imageWithData:data];
    }];
    
    UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.imageView addGestureRecognizer:pan];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"moreDescr"]) {
         MoreDetailsViewController* moreDetails = segue.destinationViewController;
         moreDetails.descrText = _video.longDescr;
     }
     
 }


#pragma mark - Video player

- (IBAction)watchVideoClicked:(id)sender {
//    NSURL *url = [NSURL URLWithString:_video.url];
//    
//    
//    _moviePlayerController =  [[MPMoviePlayerViewController alloc]
//                               initWithContentURL:url];
//    
//    [_moviePlayerController.moviePlayer prepareToPlay];
//    [_moviePlayerController.view setTranslatesAutoresizingMaskIntoConstraints:YES];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayBackDidFinish:)
//                                                 name:MPMoviePlayerDidExitFullscreenNotification
//                                               object:_moviePlayerController.moviePlayer];
//    
//    _moviePlayerController.moviePlayer.controlStyle = MPMovieControlStyleDefault;
//    _moviePlayerController.moviePlayer.shouldAutoplay = YES;
//    [self.view addSubview:_moviePlayerController.view];
//    [_moviePlayerController.moviePlayer setFullscreen:YES animated:YES];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)]){
        [player.view removeFromSuperview];
    }
    
    //Show rating
    [self performSegueWithIdentifier:@"showRating" sender:self];
}

#pragma mark - pan gesture
- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    static UIAttachmentBehavior *attachment;
    static CGPoint               startCenter;
    
    // variables for calculating angular velocity
    
    static CFAbsoluteTime        lastTime;
    static CGFloat               lastAngle;
    static CGFloat               angularVelocity;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.footerView setHidden:NO];
        [self.footerViewLabel setHidden:NO];
        
        [self.animator removeAllBehaviors];
        
        startCenter = gesture.view.center;
        
        // calculate the center offset and anchor point
        
        CGPoint pointWithinAnimatedView = [gesture locationInView:gesture.view];
        
        UIOffset offset = UIOffsetMake(pointWithinAnimatedView.x - gesture.view.bounds.size.width / 2.0,
                                       pointWithinAnimatedView.y - gesture.view.bounds.size.height / 2.0);
        
        CGPoint anchor = [gesture locationInView:gesture.view.superview];
        
        // create attachment behavior
        
        attachment = [[UIAttachmentBehavior alloc] initWithItem:gesture.view
                                               offsetFromCenter:offset
                                               attachedToAnchor:anchor];
        
        // code to calculate angular velocity (seems curious that I have to calculate this myself, but I can if I have to)
        
        lastTime = CFAbsoluteTimeGetCurrent();
        lastAngle = [self angleOfView:gesture.view];
        
        typeof(self) __weak weakSelf = self;
        
        attachment.action = ^{
            CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
            CGFloat angle = [weakSelf angleOfView:gesture.view];
            if (time > lastTime) {
                angularVelocity = (angle - lastAngle) / (time - lastTime);
                lastTime = time;
                lastAngle = angle;
            }
        };
        
        // add attachment behavior
        
        [self.animator addBehavior:attachment];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        // as user makes gesture, update attachment behavior's anchor point, achieving drag 'n' rotate
        
        CGPoint anchor = [gesture locationInView:gesture.view.superview];
        attachment.anchorPoint = anchor;
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.animator removeAllBehaviors];
        
        CGPoint velocity = [gesture velocityInView:gesture.view.superview];
        
        // if we aren't dragging it down, just snap it back and quit
        
        if (fabs(atan2(velocity.y, velocity.x) - M_PI_2) > M_PI_4) {
            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:gesture.view snapToPoint:startCenter];
            [self.animator addBehavior:snap];
            
            return;
        }
        
        // otherwise, create UIDynamicItemBehavior that carries on animation from where the gesture left off (notably linear and angular velocity)
        
        UIDynamicItemBehavior *dynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[gesture.view]];
        [dynamic addLinearVelocity:velocity forItem:gesture.view];
        [dynamic addAngularVelocity:angularVelocity forItem:gesture.view];
        [dynamic setAngularResistance:1.25];
        
        // when the view no longer intersects with its superview, go ahead and remove it
        
        typeof(self) __weak weakSelf = self;
        
        dynamic.action = ^{
            if (!CGRectIntersectsRect(gesture.view.superview.bounds, gesture.view.frame)) {
                
                [weakSelf.animator removeAllBehaviors];
                [gesture.view removeFromSuperview];
                [self.playerImgView setHidden:NO];
                NSString *imageUrl = _video.imgName;
                [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    self.playerBgImgView.image = [UIImage imageWithData:data];
                }];                
                [self.playerBgImgView setHidden:NO];
                [self.playBtn setHidden:YES];
                [self.footerView setHidden:YES];
                [self.footerViewLabel setHidden:YES];
                
                [[CommManager sharedManager] sendMessage:_video.url]; //start video on server

                [[[UIAlertView alloc] initWithTitle:nil message:@"Your video will now start on other display" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        };
        [self.animator addBehavior:dynamic];
        
        // add a little gravity so it accelerates off the screen (in case user gesture was slow)
        
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[gesture.view]];
        gravity.magnitude = 0.7;
        [self.animator addBehavior:gravity];
    }
}

- (CGFloat)angleOfView:(UIView *)view{
    // http://stackoverflow.com/a/2051861/1271826
    
    return atan2(view.transform.b, view.transform.a);
}

@end

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

@interface DetailsViewController (){
    MPMoviePlayerViewController *_moviePlayerController;
    VideoCast* _video;
}
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
    // NSString*path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    // NSURL*url = [NSURL fileURLWithPath:path];
    
    //http://download.ted.com/talks/YuvalNoahHarari_2015G-480p.mp4 //works!
    //http://download.ted.com/talks/IsmaelNazario_2014X-480p.mp4 //doesnt work
    //Only 2015 videos open ealier versions download!!
    
    NSURL *url = [NSURL URLWithString:_video.url];
    
    
    _moviePlayerController =  [[MPMoviePlayerViewController alloc]
                               initWithContentURL:url];
    
    [_moviePlayerController.moviePlayer prepareToPlay];
    [_moviePlayerController.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerDidExitFullscreenNotification
                                               object:_moviePlayerController.moviePlayer];
    
    _moviePlayerController.moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayerController.moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_moviePlayerController.view];
    [_moviePlayerController.moviePlayer setFullscreen:YES animated:YES];
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
- (IBAction)moreBtnClicked:(id)sender {
}
@end

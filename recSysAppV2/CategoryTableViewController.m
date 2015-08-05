//
//  CategoryTableViewController.m
//  recSysAppV1
//
//  Created by Wessam Abdrabo on 7/31/15.
//  Copyright (c) 2015 tum. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "VideosDataManager.h"
#import "VideoCast.h"
#import "DetailsViewController.h"
#import "HomeTableViewCell.h"

@interface CategoryTableViewController (){
    NSArray* _categoryVideos;
}
@end

@implementation CategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _categoryVideos = [[VideosDataManager sharedManager] getCategoryVideosName:[[self.categoryName lowercaseString]stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceCharacterSet]]];
    self.navigationItem.title = self.categoryName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_categoryVideos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
    static NSString *homeCellId = @"homeCustomCell";
    
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:homeCellId];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    VideoCast* vid = [_categoryVideos objectAtIndex:indexPath.row];

    cell.speakerLabel.text = vid.speaker;
    cell.descrLabel.text = vid.title;
    cell.durationLabel.text = vid.duration;
    cell.tag = indexPath.row;
    NSString *imageUrl = vid.imgName;
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        cell.img.image = [UIImage imageWithData:data];
        [cell setNeedsLayout];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"categoryVideoDetailSegue" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"categoryVideoDetailSegue"]){
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        VideoCast *vid = [_categoryVideos objectAtIndex:path.row];
        DetailsViewController* detailsViewController = [segue destinationViewController];
        detailsViewController.videoID = vid.title;
    }
}


@end

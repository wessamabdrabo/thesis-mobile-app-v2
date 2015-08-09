//
//  HomeTableViewController.m
//  recSysAppV1
//
//  Created by Wessam Abdrabo on 7/26/15.
//  Copyright (c) 2015 tum. All rights reserved.
//

#import "HomeTableViewController.h"
#import "VideoCast.h"
#import "DetailsViewController.h"
#import "VideosDataManager.h"
#import "HomeTableViewCell.h"
#import "CommManager.h"

@interface HomeTableViewController (){
    NSArray* sectionsHeaderTitles;
    NSArray* section1;
    NSArray* section2;
    NSArray* section3;
    NSArray* section4;
    NSArray* section5;
}
@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[CommManager sharedManager] sendMessage:@"open"]; //tell server to open home
    
    self.navigationItem.hidesBackButton = YES; //better to remove preferences and sign up from stack once sign up is done!
    
    sectionsHeaderTitles = @[@"Top picks for Wessam", @"Because you liked Creativity", @"You might also like", @"Most watched in Activism", @"Top rated in Business"];
    
    section1 = [[VideosDataManager sharedManager] getCategoryVideosName:@"photography"];
    section2 = [[VideosDataManager sharedManager] getCategoryVideosName:@"creativity"];
    section3 = [[VideosDataManager sharedManager] getCategoryVideosName:@"philosophy"];
    section4 = [[VideosDataManager sharedManager] getCategoryVideosName:@"activism"];
    section5 = [[VideosDataManager sharedManager] getCategoryVideosName:@"business"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionsHeaderTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(section == 0)
        return  [section1 count];
    if(section == 1)
        return  [section2 count];
    if(section == 2)
        return  [section3 count];
    if(section == 3)
        return  [section4 count];
    if(section == 4)
        return  [section5 count];

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
    static NSString *homeCellId = @"homeCustomCell";
    
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:homeCellId];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSArray* data = [[NSArray alloc]init];
    
    if(section == 0)
        data = section1;
    if(section == 1)
        data = section2;
    if(section == 2)
        data = section3;
    if(section == 3)
        data = section4;
    if(section == 4)
        data = section5;

    if(row < [data count]){
        VideoCast* vid = [data objectAtIndex:row];
        if(vid != nil){
            cell.speakerLabel.text = vid.speaker;
            cell.descrLabel.text = vid.title;
            cell.durationLabel.text = vid.duration;
            cell.tag = indexPath.row;
            NSString *imageUrl = vid.imgName;
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                cell.img.image = [UIImage imageWithData:data];
                [cell setNeedsLayout];
            }];
        }
    }
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [sectionsHeaderTitles objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"detailSegue"]){
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSInteger section = path.section;
        NSArray* data = [[NSArray alloc]init];
        
        if(section == 0)
            data = section1;
        if(section == 1)
            data = section2;
        if(section == 2)
            data = section3;
        if(section == 3)
            data = section4;
        if(section == 4)
            data = section5;
        VideoCast* video = [data objectAtIndex:path.row];
        DetailsViewController* detailsViewController = [segue destinationViewController];
        detailsViewController.videoID = video.title;
    }
}


@end

//
//  CategoryTableViewController.h
//  recSysAppV1
//
//  Created by Wessam Abdrabo on 7/31/15.
//  Copyright (c) 2015 tum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSString* categoryName;
@end

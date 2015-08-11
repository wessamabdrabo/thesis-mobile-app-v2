//
//  VideosDataManager.h
//  recSysAppV1
//
//  Created by Wessam Abdrabo on 7/30/15.
//  Copyright (c) 2015 tum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoCast.h"

@interface VideosDataManager : NSObject
+ (id)sharedManager;
@property (nonatomic, strong) NSArray* videosData;
-(NSMutableArray*) getCategoryVideosName:(NSString*)category;
-(VideoCast*) getVideobyID:(NSString*)vidID;
@end

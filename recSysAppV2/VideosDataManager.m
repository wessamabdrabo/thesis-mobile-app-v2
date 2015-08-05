//
//  VideosDataManager.m
//  recSysAppV1
//
//  Created by Wessam Abdrabo on 7/30/15.
//  Copyright (c) 2015 tum. All rights reserved.
//

#import "VideosDataManager.h"

#define DATA_FILE @"Videos"

@interface VideosDataManager()
@end

@implementation VideosDataManager
+ (id)sharedManager {
    static VideosDataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:DATA_FILE ofType:@"plist"];
        self.videosData = [NSArray arrayWithContentsOfFile:path];
    }
    return self;
}

-(NSArray*) getCategoryVideosName:(NSString*)category{
    NSMutableArray* categoryVids = [[NSMutableArray alloc] init];
    for (NSDictionary* vidDict in self.videosData) {
        if ([[vidDict objectForKey:@"category"] isEqualToString:category]) {
            VideoCast* video= [[VideoCast alloc] initWithDict:vidDict];
            [categoryVids addObject:video];
        }
    }
    return categoryVids;
}
-(VideoCast*) getVideobyID:(NSString*)vidID{
    VideoCast* video = nil;
    for(NSDictionary* vid_dict in self.videosData){
        if ([[vid_dict objectForKey:@"title"] isEqualToString:vidID]) {
            video = [[VideoCast alloc] initWithDict:vid_dict];
            return video;
        }
    }
    return video;
}

@end

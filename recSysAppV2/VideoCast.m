//
//  VideoCast.m
//  recSysAppV1
//
//  Created by Wessam Abdrabo on 7/27/15.
//  Copyright (c) 2015 tum. All rights reserved.
//

#import "VideoCast.h"

@implementation VideoCast
-(id) initWithDict:(NSDictionary*)data{
    self = [super init];
    if(self){
        self.vidID = [data objectForKey:@"id"];
        self.title = [data objectForKey:@"title"];
        self.longDescr = [data objectForKey:@"descr"];
        self.category = [data objectForKey:@"category"];
        self.duration = [data objectForKey:@"duration"];
        self.speaker = [data objectForKey:@"speaker"];
        self.imgName = [data objectForKey:@"imgUrl"];
        self.url = [data objectForKey:@"vidUrl"];
        self.posted_on = [data objectForKey:@"posted"];
    }
    return self;
}

@end

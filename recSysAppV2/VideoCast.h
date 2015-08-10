//
//  VideoCast.h
//  recSysAppV1
//
//  Created by Wessam Abdrabo on 7/27/15.
//  Copyright (c) 2015 tum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoCast : NSObject
-(id) initWithDict:(NSDictionary*)data;
@property(nonatomic,strong)  NSString* vidID;
@property(nonatomic,strong)  NSString* title;
@property(nonatomic, strong) NSString* longDescr;
@property(nonatomic, strong) NSString* imgName;
@property(nonatomic, strong) NSString* url;
@property(nonatomic, strong) NSString* category;
@property(nonatomic, strong) NSString* speaker;
@property(nonatomic, strong) NSString* posted_on;
@property(nonatomic, strong) NSString* duration;
@end

//
//  CommManager.h
//  recSysAppV2
//
//  Created by Wessam Abdrabo on 8/5/15.
//  Copyright (c) 2015 tum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommManager : NSObject <NSStreamDelegate>
+ (id)sharedManager;
-(void) sendMessage:(NSString*) msg;
@end

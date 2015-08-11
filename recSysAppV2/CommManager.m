//
//  CommManager.m
//  recSysAppV2
//
//  Created by Wessam Abdrabo on 8/5/15.
//  Copyright (c) 2015 tum. All rights reserved.
//

#import "CommManager.h"

#define TCP_SERVER_IP @"169.254.163.115"
#define TCP_PORT 8000

@interface CommManager(){
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}
@end

@implementation CommManager
+ (id)sharedManager {
    static CommManager *commManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        commManager = [[self alloc] init];
    });
    return commManager;
}

- (id)init {
    if (self = [super init]) {
        //init network stack
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)TCP_SERVER_IP, TCP_PORT, &readStream, &writeStream);
        inputStream = (__bridge NSInputStream *)readStream;
        outputStream = (__bridge NSOutputStream *)writeStream;
        [inputStream setDelegate:self];
        [outputStream setDelegate:self];
        [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [inputStream open];
        [outputStream open];
        NSLog(@"[CommManager] network initialized!");
    }
    return self;
}

#pragma mark - events handling
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    NSLog(@"[CommManager] stream event %i", streamEvent);
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"[CommManager] Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"[CommManager] Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            NSLog(@"[CommManager] end encountered!");

            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            theStream = nil;
            
            break;
        default:
            NSLog(@"[CommManager] Unknown event");
    }
    
}

-(void) sendMessage:(NSString*) msg{
    //NSString *response  = [NSString stringWithFormat:@"iam:%@", @"left"];
    NSString *response  = [NSString stringWithFormat:@"%@",msg];
    
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

@end

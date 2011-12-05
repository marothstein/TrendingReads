//
//  PullSyncObject.m
//  TweaderTabs
//
//  Created by Alex Garcia on 11/26/11.
//  Copyright (c) 2011 UMD HCI Lab. All rights reserved.
//

#import "PullSyncObject.h"

@implementation PullSyncObject

@synthesize syncObject,delegate;

-(id)init{
    
    self = [super init];
    
    self.syncObject = [[SyncObject alloc] init];
    [self.syncObject setDelegate:self];
    //self.syncObject.requestType = @"GET";
    
    return self;
}

-(void) pull:(NSString *)url{
    
    [self.syncObject syncData:url];
    
}

-(void) dataObatained:(NSMutableData *)data{
    
    NSLog(@"PullSyncObject: data obtained");
    [self.delegate pullComplete:data];
    
}

@end

//
//  PushSyncObject.m
//  TweaderTabs
//
//  Created by Alex Garcia on 12/1/11.
//  Copyright (c) 2011 UMD HCI Lab. All rights reserved.
//

#import "PushSyncObject.h"

@implementation PushSyncObject

@synthesize delegate,syncObject;

-(id)init{
    
    self = [super init];
    
    self.syncObject = [[SyncObject alloc] init];
    [self.syncObject setDelegate:self];
    
    return self;
}

-(void) push:(NSString *)url WithData:(NSData *)data AndHeaders:(NSMutableDictionary *)headers{
    
    //[self.syncObject syncData:url];
    NSString * formattedURL = [NSString stringWithString:url];
    formattedURL = [formattedURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest * request = [NSMutableURLRequest 
                                     requestWithURL:[NSURL URLWithString:formattedURL]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:20.0];
    [request setHTTPBody:data];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPMethod:@"POST"];
    [syncObject connectWithRequest:request];
}

-(void) dataObatained:(NSMutableData *)data{
    
    NSLog(@"PushSyncObject: data obtained");
    [self.delegate pushComplete:data];
    
}


@end

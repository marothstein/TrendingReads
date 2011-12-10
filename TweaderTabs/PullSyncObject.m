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
    
    //NSLog(@"PullSyncObject: data obtained");
    [self.delegate pullComplete:data];
    
}


-(void) pullFromUrl:(NSString *)url WithHeaders:(NSMutableDictionary *)headers{
    
    NSString * formattedURL = [NSString stringWithString:url];
    formattedURL = [formattedURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest * request = [NSMutableURLRequest 
                                     requestWithURL:[NSURL URLWithString:formattedURL]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:20.0];
    
    //NSLog(@"request string: %@",request.URL);
    if(headers){
        [request setAllHTTPHeaderFields:headers];
        //NSLog(@"request headers1: %@",[request valueForHTTPHeaderField:@"q"]);
        //NSLog(@"request headers2: %@",[request valueForHTTPHeaderField:@"rpp"]);
    }
    [request setHTTPMethod:@"GET"];
    [syncObject connectWithRequest:request];
}

@end

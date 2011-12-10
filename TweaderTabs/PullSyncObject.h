//
//  PullSyncObject.h
//  TweaderTabs
//
//  Created by Alex Garcia on 11/26/11.
//  Copyright (c) 2011 UMD HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncObject.h"

@protocol PullProtocol <NSObject>

-(void) pullComplete:(NSData*)data;

@end

@interface PullSyncObject : NSObject<SyncObjectDelegate>{

}

-(void) pullFromUrl:(NSString *)url WithHeaders:(NSMutableDictionary *)headers;

@property (nonatomic,retain) SyncObject * syncObject;
@property (nonatomic,assign) id <PullProtocol> delegate;

-(void) pull:(NSString*) url;

@end

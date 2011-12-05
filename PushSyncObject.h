//
//  PushSyncObject.h
//  TweaderTabs
//
//  Created by Alex Garcia on 12/1/11.
//  Copyright (c) 2011 UMD HCI Lab. All rights reserved.
//

#import "SyncObject.h"

@protocol PushProtocol <NSObject>

-(void) pushComplete:(NSData*)data;

@end


@interface PushSyncObject : NSObject<SyncObjectDelegate>



-(void) push:(NSString*) url WithData: (NSData *) data AndHeaders : (NSMutableDictionary*)headers;

@property (nonatomic,retain) SyncObject * syncObject;
@property (nonatomic,assign) id <PushProtocol> delegate;



@end
//
//  SyncObject.h
//  TweaderTabs
//
//  Created by Alex Garcia on 11/21/11.
//  Copyright (c) 2011 UMD HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SyncObjectDelegate <NSObject>

-(void) dataObatained:(NSMutableData *) data;

@end


@interface SyncObject : NSObject{
    
    //id <SyncObjectDelegate> delegate;
    
}
-(void) syncData:(NSString *) extension;
-(void) connectWithRequest:(NSURLRequest *) request;

@property (nonatomic, retain) NSMutableData * requestedData;
@property (nonatomic, assign) id <SyncObjectDelegate> delegate;
//@property (nonatomic, copy)   NSString * requestType;
//@property (nonatomic, retain) NSData   * postData;

@end


/*

pull sync:
pull down the data (JSON - votes)
compare to all articles

push sync:


*/
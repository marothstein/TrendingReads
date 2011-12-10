//
//  ArticleCellProtocol.h
//  TweaderTabs
//
//  Created by Alex Garcia on 12/9/11.
//  Copyright (c) 2011 UMD HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ArticleCellProtocol <NSObject>

-(void) accessoryButtonPressed : (NSString *) urlToLoad;

@end

@protocol TapToHideProtocol <NSObject>

-(void) hideBar;
-(void) showBar;

@end

@protocol IPDelegate <NSObject>

-(void) pushToInstapaper : (NSString *)url;

@end
//
//  myArticle.h
//  TweaderTabs
//
//  Created by Alex Garcia on 11/10/11.
//  Copyright 2011 UMD HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myArticle : NSObject{
    
}

//properties that go in the dictionary representation
@property (nonatomic, retain)  NSString *articleTitle;
@property (nonatomic, retain)  NSString *tweeterName;
@property (nonatomic, retain)  NSString *articleUrl;
@property (nonatomic, copy  )  NSString *articleID;
//end of properties that go in the dictionary representation

@property (nonatomic, retain) UIImage  *tweeterImage;
@property (nonatomic, retain) NSDate   *tweetDate;

@property (nonatomic, assign) int num_votes;
@property (nonatomic, assign) bool state;

-(NSDictionary*) asDictionary;


@end

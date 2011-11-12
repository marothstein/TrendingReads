//
//  myArticle.m
//  TweaderTabs
//
//  Created by Alex Garcia on 11/10/11.
//  Copyright 2011 UMD HCI Lab. All rights reserved.
//

#import "myArticle.h"

@implementation myArticle

@synthesize tweeterName,tweeterImage,articleUrl,articleTitle,tweetDate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    tweeterName = @"tweeter not set";
    articleUrl = @"url not set";
    articleTitle = @"title not set";
    tweetDate = [[NSDate alloc] init];
    //NSLog(@"hurf: %@", tweetDate);
    tweeterImage = [UIImage imageNamed:@"Aa Icon"];
    
    return self;
}

- (void) dealloc{
    
    [tweeterName release];
    [tweeterImage release];
    [articleUrl release];
    [articleTitle release];

}

/*+(NSInteger)articleCompare:(id)firstID against:(id)secondID withContext:(id)contect{
    
    //cast firstID and secondID appropriately, get the dates they were posted
    NSDate * date1 = ((myArticle*)firstID).tweetDate;
    NSDate * date2 = ((myArticle*)secondID).tweetDate;
    
    //compare the dates
    if (date1 < date2){
        return NSOrderedAscending;
    }
    else if (date1 > date2){
        return NSOrderedDescending;
    }
    else{
        return NSOrderedSame;
    }
    
}*/


@end

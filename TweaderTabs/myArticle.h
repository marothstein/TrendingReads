//
//  myArticle.h
//  TweaderTabs
//
//  Created by Alex Garcia on 11/10/11.
//  Copyright 2011 UMD HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myArticle : NSObject


@property (nonatomic, retain) NSString *articleTitle;
@property (nonatomic, retain) NSString *tweeterName;
@property (nonatomic, retain) NSString *articleUrl;
@property (nonatomic, retain) UIImage  *tweeterImage;
@property (nonatomic, retain) NSDate   *tweetDate;




@end

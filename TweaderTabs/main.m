
//
//  main.m
//  TweaderTabs
//
//  Created by Alex Garcia on 9/20/11.
//  Copyright 2011 UMD HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweaderTabsAppDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    //int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([TweaderTabsAppDelegate class]));
    [pool release];
    return retVal;
}

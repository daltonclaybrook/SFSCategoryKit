//
//  UIViewController+SFSAdditions.h
//  SFSCategoryKit
//
//  Created by Dalton Claybrook on 4/6/15.
//  Copyright (c) 2015 Dalton Claybrook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SFSAdditions)

- (void)executeBlockWhenLoaded:(void(^)())block;
- (void)executeBlockWhenVisible:(void(^)())block;

@end

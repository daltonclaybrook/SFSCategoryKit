//
//  UIViewController+SFSAdditions.m
//  SFSCategoryKit
//
//  Created by Dalton Claybrook on 4/6/15.
//  Copyright (c) 2015 Dalton Claybrook, LLC. All rights reserved.
//

#import "UIViewController+SFSAdditions.h"
#import <objc/runtime.h>
#import <objc/message.h>

static const void * SFSAdditionsViewDidLoadKey = &SFSAdditionsViewDidLoadKey;
static const void * SFSAdditionsViewDidAppearKey = &SFSAdditionsViewDidAppearKey;

@implementation UIViewController (SFSAdditions)

+ (void)load
{
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewDidLoad)), class_getInstanceMethod(self, @selector(sfs_viewDidLoad)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewDidAppear:)), class_getInstanceMethod(self, @selector(sfs_viewDidAppear:)));
}

- (void)executeBlockWhenLoaded:(void(^)())block
{
    if (!block)
    {
        NSAssert(NO, @"Must use a block: %@", NSStringFromSelector(_cmd));
        return;
    }
    
    if (self.isViewLoaded)
    {
        block();
    }
    else
    {
        NSMutableArray *array = [self arrayForKey:SFSAdditionsViewDidLoadKey];
        [array addObject:[block copy]];
    }
}

- (void)executeBlockWhenVisible:(void(^)())block
{
    if (!block)
    {
        NSAssert(NO, @"Must use a block: %@", NSStringFromSelector(_cmd));
        return;
    }
    
    if (self.view.window)
    {
        block();
    }
    else
    {
        NSMutableArray *array = [self arrayForKey:SFSAdditionsViewDidAppearKey];
        [array addObject:[block copy]];
    }
}

#pragma mark - Private

- (void)sfs_viewDidLoad
{
    [self sfs_viewDidLoad];
    
    [self executeBlocksForKey:SFSAdditionsViewDidLoadKey];
}

- (void)sfs_viewDidAppear:(BOOL)animated
{
    [self sfs_viewDidAppear:animated];
    
    [self executeBlocksForKey:SFSAdditionsViewDidAppearKey];
}

- (void)executeBlocksForKey:(const void *)key
{
    NSArray *blocks = objc_getAssociatedObject(self, key);
    for (id blockObj in blocks)
    {
        void (^voidBlock)(void) = blockObj;
        voidBlock();
    }
    objc_setAssociatedObject(self, key, nil, 0);
}

- (NSMutableArray *)arrayForKey:(const void *)key
{
    NSMutableArray *array = objc_getAssociatedObject(self, key);
    if (!array)
    {
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, key, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return array;
}

@end

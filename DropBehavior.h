//
//  DropBehavior.h
//  Card Matching
//
//  Created by Baris.
//  Copyright (c) 2016 Baris. All rights reserved.
//

#import<UIKit/UIKit.h>

@interface DropBehavior : UIDynamicBehavior

-(void)addItem:(id <UIDynamicItem>)item;

-(void)removeItem:(id <UIDynamicItem>)item;


@end

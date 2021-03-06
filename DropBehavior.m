//
//  DropBehavior.m
//  Card Matching
//
//  Created by Baris.
//  Copyright (c) 2016 Baris. All rights reserved.
//

#import "DropBehavior.h"

@interface DropBehavior()
@property(strong, nonatomic)UIGravityBehavior *gravity;
@property(strong, nonatomic)UICollisionBehavior *collider;
@property(strong, nonatomic)UIDynamicBehavior *dinamo;
@end

@implementation DropBehavior

-(instancetype)init{
    self = [super init];
    [self addChildBehavior:self.gravity];
    [self addChildBehavior:self.collider];
    [self addChildBehavior:self.dinamo];
    return self;
}


-(UIDynamicBehavior *)dinamo{
    if(!_dinamo){
        _dinamo = [[UIDynamicBehavior alloc]init];
    }
    return _dinamo;
}



-(UIGravityBehavior *)gravity{
    if(!_gravity){
        _gravity = [[UIGravityBehavior alloc]init];
        _gravity.magnitude = 0.9;
    }
    return _gravity;
}


-(UICollisionBehavior *)collider{
    if(!_collider){
        _collider = [[UICollisionBehavior alloc]init];
        _collider.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collider;
}


-(void)addItem:(id<UIDynamicItem>)item{
    [self.gravity addItem:item];
    [self.collider addItem:item];
}

-(void)removeItem:(id<UIDynamicItem>)item{
    [self.gravity removeItem:item];
    [self.collider removeItem:item];
}

@end

//
//  PlayingCardView.h
//  Card Matching
//
//  Created by Baris.
//  Copyright (c) 2016 Baris. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property(nonatomic)NSUInteger rank;
@property(strong, nonatomic)NSString * suit;
@property(nonatomic)BOOL faceUp;

-(void)drawCorners;

@end

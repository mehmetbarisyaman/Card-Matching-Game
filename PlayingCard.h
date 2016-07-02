//
//  PlayingCard.h
//  Card Matching
//
//  Created by Baris on 6/19/16.
//  Copyright © 2016 Baris. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property(strong,nonatomic)NSString *suit;
@property(nonatomic) NSUInteger rank;

+(NSArray *)validSuits;
+(NSUInteger) maxRank;


@end

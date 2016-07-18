//
//  Card.m
//  Card Matching
//
//  Created by Baris on 6/19/16.
//  Copyright © 2016 Baris. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

-(int)match: (NSArray *)otherCards{
    int score = 0;
    for (Card *card in otherCards){
        if([card.contents isEqualToString:self.contents]){
            score=1;
        }
    }
    return score;
}


+(NSArray *)validSuits{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

-(NSString *)suit{
    return _suit ? _suit: @"?";
}


+(NSArray *)rankStrings{
    return @[@"?", @"A", @"2", @"3",@"4",@"5",@"6",@"7", @"8", @"9" ,@"10", @"J", @"Q", @"K"];
}

+(NSUInteger)maxRank{
    return [[self rankStrings] count]-1;
}

-(void) setRank:(NSUInteger)rank{
        _rank = rank;
}


@end


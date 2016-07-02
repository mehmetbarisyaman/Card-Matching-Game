//
//  CardMatchingGame.h
//  Card Matching
//
//  Created by Baris.
//  Copyright (c) 2016 Baris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"



@interface CardMatchingGame : NSObject


//designated initializer
-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

-(NSString *)chooseCardAtIndex:(NSUInteger)index;

-(Card *)cardAtIndex:(NSUInteger)index;

@property(nonatomic)NSUInteger sayac;

@property(nonatomic, readonly)NSInteger score;

-(NSString *)chooseMultipleCards:(NSUInteger)index;

-(NSString *)threeTypeCheck:(NSMutableArray *)response;

@end

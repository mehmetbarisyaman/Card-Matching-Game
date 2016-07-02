//
//  Deck.h
//  Card Matching
//
//  Created by Baris on 6/19/16.
//  Copyright © 2016 Baris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck: NSObject

-(void) addCard:(Card *)card atTop:(BOOL)atTop;

-(void)addCard:(Card *)card;
-(Card *)drawRandomCard;


@end


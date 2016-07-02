//
//  Header.h
//  Card Matching
//
//  Created by Baris on 6/19/16.
//  Copyright © 2016 Baris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property(strong, nonatomic) NSString *contents;

@property(nonatomic, getter = isChosen) BOOL chosen;

@property(nonatomic, getter = isMatched) BOOL matched;

-(int) match:(NSArray *)otherCards;


@end

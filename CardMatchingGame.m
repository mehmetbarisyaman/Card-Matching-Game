//
//  CardMatchingGame.m
//  Card Matching
//
//  Created by Baris.
//  Copyright (c) 2016 Baris. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property(nonatomic, readwrite) NSInteger score;
@property(nonatomic, strong)NSMutableArray *cards; //of Card
@property(nonatomic, strong)NSMutableArray *ucluCards;
@property(nonatomic)NSInteger currentIndex;
@end

@implementation CardMatchingGame

-(NSMutableArray *)cards{
    if(!_cards)_cards = [[NSMutableArray alloc]init];
    return _cards;
}



-(NSMutableArray *)ucluCards{
    if(!_ucluCards){
        _ucluCards = [[NSMutableArray alloc]init];
    }
    return _ucluCards;
}


-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck{
    self = [super init];
    if(self){
        for(int i=0; i< count; i++){
            Card *card = [deck drawRandomCard];
            if(card)
                [self.cards addObject:card];
            else{
                self = nil;
                break;
            }
        }
    }
    return self;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

-(Card *)cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count]) ? self.cards[index]: nil;
}


-(NSUInteger)chooseCardForSecondViewController:(NSUInteger)index{
    
    Card *card = [self cardAtIndex: index];
    if(card.chosen == YES){
        card.chosen =NO;
        self.currentIndex--;
        [self.ucluCards removeObject:card];
    }
    else{
        card.chosen = YES;
        self.currentIndex++;
        [self.ucluCards addObject:card];
        if(self.currentIndex ==3){
            NSInteger x =[self decideScore:self.ucluCards];
            _currentIndex=0;
            return x;
        }
    }
    return 0;
}

-(NSUInteger)decideScore:(NSMutableArray *)testArray{
    Card *testCard1 = [testArray objectAtIndex:0];
    Card *testCard2 = [testArray objectAtIndex:1];
    Card *testCard3 = [testArray objectAtIndex:2];
    if(testCard1.rank == testCard2.rank && testCard2.rank == testCard3.rank && testCard1.rank == testCard3.rank){
        testCard1.matched = YES;
        testCard2.matched = YES;
        testCard3.matched = YES;
        [testArray removeAllObjects];
        self.result = [ NSMutableString stringWithFormat:@"Rank match happens!"];
        return 10;
    }
    
    else if(testCard1.suit == testCard2.suit && testCard2.suit == testCard3.suit && testCard1.suit == testCard3.suit){
        testCard1.matched = YES;
        testCard2.matched = YES;
        testCard3.matched = YES;
        [testArray removeAllObjects];
        self.result = [ NSMutableString stringWithFormat:@"Suit match happens!"];
        return 5;
    }
    testCard1.chosen=NO;
    testCard2.chosen=NO;
    testCard3.chosen=NO;
    [testArray removeAllObjects];
    self.result = [ NSMutableString stringWithFormat:@"Mismatch happens!"];
    return -3;
}


-(NSString *)chooseCardAtIndex:(NSUInteger)index{
    Card *card = [self cardAtIndex:index];
    if(!card.isMatched){
        if(card.isChosen){
            card.chosen = NO;
            _sayac++;
            return [NSString stringWithFormat:@"%@", card.contents];
        }
        else{
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
            if(_sayac==2){
                _sayac--;
                return [NSString stringWithFormat:@"%@", card.contents];
            }
            else{
                for(Card *otherCard in self.cards){
                    if(otherCard.isChosen && !otherCard.isMatched && otherCard!=card){
                        _sayac=2;
                        int matchScore = [card match:@[otherCard]];
                        if(matchScore){
                            self.score += matchScore * MATCH_BONUS;
                            otherCard.matched = YES;
                            card.matched = YES;
                            return [NSString stringWithFormat:@"%@ and %@ matches", card.contents, otherCard.contents];
                            
                        }
                        else{
                            self.score -= MISMATCH_PENALTY;
                            otherCard.chosen = NO;
                            card.chosen =NO;
                            return [NSString stringWithFormat:@"%@ and %@ dont match", card.contents, otherCard.contents];
                        }
                    }
                }
            }
            return [NSString stringWithFormat:@" "];
        }
    }
    return [NSString stringWithFormat:@"You cant choose a matched card"];
}

/*
-(NSString *)threeTypeCheck:(NSMutableArray *)response{
    Card *haci = [response objectAtIndex:2];
    NSString *sonuc = [[NSString alloc]init];
    BOOL oluk = false;
    for(int i=0; i<=1; i++){
        Card *otherCard = [response objectAtIndex:i];
        int matchScore = [haci match:@[otherCard]];
        if(matchScore){
            oluk = true;
            sonuc = [NSString stringWithFormat:@"%@ and %@ matches", haci.contents, otherCard.contents];
        }
    }
    if(!oluk){
        haci = [response objectAtIndex:1];
        Card *otherCard = [response objectAtIndex:0];
        int matchScore = [haci match:@[otherCard]];
        if(matchScore){
            for(Card *kart in self.ucluCards)
                kart.matched = YES;
            self.score += matchScore * MATCH_BONUS;
            return [NSString stringWithFormat:@"%@ and %@ matches", haci.contents, otherCard.contents];
        }
        else{
            for(Card *kart in self.ucluCards)
                kart.chosen = NO;
            self.score -= MISMATCH_PENALTY*2;
            return [NSString stringWithFormat:@"Match does not happens"];
        }
    }
    else{
        self.score += MATCH_BONUS;
        for(Card *kart in self.ucluCards)
            kart.matched = YES;
        return sonuc;
    }

}


-(NSString *)chooseMultipleCards:(NSUInteger)index{
    Card *card = [self cardAtIndex:index];
    NSString *sonuc = [[NSString alloc]init];
    if(!card.isMatched){
        if([self.ucluCards containsObject:card]){
            card.chosen =NO;
            _sayac++;
            [self.ucluCards removeObject:card];
            return [NSString stringWithFormat:@"%@", card.contents];
        }
        else{
            card.chosen =YES;
            self.score -= COST_TO_CHOOSE;
            if(_sayac==3 || _sayac==2){
                _sayac--;
                [self.ucluCards addObject:card];
                return [NSString stringWithFormat:@"%@", card.contents];
            }
            else{
                [self.ucluCards addObject:card];
                _sayac = 3;
                sonuc = [self threeTypeCheck:self.ucluCards];
                [self.ucluCards removeAllObjects];
                return sonuc;
            }
            
        }
    }
    return [NSString stringWithFormat:@" "];
}
*/
 
@end

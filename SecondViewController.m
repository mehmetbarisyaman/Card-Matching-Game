//
//  SecondViewController.m
//  Card Matching
//
//  Created by Baris.
//  Copyright (c) 2016 Baris. All rights reserved.
//

#import "SecondViewController.h"
#import "HistoryViewController.h"
#import "PlayingCardView.h"


@interface SecondViewController()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(strong,nonatomic)NSMutableAttributedString* scoreString;
@property(nonatomic)NSInteger score;
@property(nonatomic)NSInteger lastCardNumber;
@property (weak, nonatomic) IBOutlet UILabel *gameText;
@property (weak, nonatomic) IBOutlet UIView *genericView;
@property(strong, nonatomic)NSMutableArray *genericArray;
@property(nonatomic)BOOL with3Cards;

@end

@implementation SecondViewController


-(void)viewDidLoad{
    [self arrangeCards];
    _with3Cards=false;
}


-(NSMutableArray *)genericArray{
    if(!_genericArray) _genericArray = [[NSMutableArray alloc]init];
    return _genericArray;
}

- (IBAction)threeCardsMore:(id)sender {
    if(!_with3Cards){
        float xFloor = self.genericView.frame.size.width/5;
        float yFloor = self.genericView.frame.size.height/5;
        float firstXFloor = xFloor;
        float firstYFloor = yFloor;
        float width = 9*xFloor/10;
        float height = 9*yFloor/10;
        float xBegin = xFloor - width/2;
        float yBegin = yFloor - height/2;
        int cardIndex = 13;
        for(int i=0; i<=_lastCardNumber+3; i++){
            if(i>_lastCardNumber){
                CGRect anyRect = CGRectMake(xBegin, yBegin, width, height);
                PlayingCardView * newView = [[PlayingCardView alloc]initWithFrame:anyRect];
                Card *anyCard = [self.game cardAtIndex:cardIndex];
                newView.suit = anyCard.suit;
                newView.rank = anyCard.rank;
                [newView setNeedsDisplay];
                [self.genericView addSubview: newView];
                [self.genericArray addObject:newView];
                cardIndex++;
            }
            xFloor = xFloor + firstXFloor;
            if((i+1)%4==0){
                yFloor = yFloor + firstYFloor;
                yBegin = yFloor - height/2;
                xFloor = firstXFloor;
            }
            xBegin = xFloor - width/2;
        }
        self.gameText.text = [NSString stringWithFormat:@"3 new cards are added!"];
        [self.historicArray addObject:self.gameText.text];
        _lastCardNumber = _lastCardNumber+3;
        _with3Cards = true;
    }
}

-(void)arrangeCards{
    float xFloor = self.genericView.frame.size.width/5;
    float yFloor = self.genericView.frame.size.height/5;
    float firstXFloor = xFloor;
    float firstYFloor = yFloor;
    float width = 9*xFloor/10;
    float height = 9*yFloor/10;
    float xBegin = xFloor - width/2;
    float yBegin = yFloor - height/2;
    if(!_game)
        _game = [[CardMatchingGame alloc]initWithCardCount:16 usingDeck:[self createDeck]];
    for(int i=0; i<=12; i++){
        CGRect anyRect = CGRectMake(xBegin, yBegin, width, height);
        PlayingCardView * newView = [[PlayingCardView alloc]initWithFrame:anyRect];
        Card *anyCard = [self.game cardAtIndex:i];
        newView.suit = anyCard.suit;
        newView.rank = anyCard.rank;
        [newView setNeedsDisplay];
        [self.genericView addSubview: newView];
        [self.genericArray addObject:newView];
        xFloor = xFloor + firstXFloor;
        if((i+1)%4==0){
            yFloor = yFloor + firstYFloor;
            yBegin = yFloor - height/2;
            xFloor = firstXFloor;
        }
        xBegin = xFloor - width/2;
    }
    self.gameText.text = [NSString stringWithFormat:@"New Game Starts!"];
    [self.historicArray addObject:self.gameText.text];
    _lastCardNumber = 12;
}


-(NSMutableArray *)historicArray{
    if(!_historicArray2) _historicArray2 = [[NSMutableArray alloc]init];
    return _historicArray2;
}

-(NSMutableAttributedString *)scoreString{
    if(!_scoreString)_scoreString = [[NSMutableAttributedString alloc]init];
    return _scoreString;
}

- (IBAction)dealButton:(UIButton *)sender {
    _game = [[CardMatchingGame alloc]initWithCardCount:16 usingDeck:[self createDeck]];
    self.gameText.text = [NSString stringWithFormat:@"New Game Starts!"];
    [self.historicArray addObject:self.gameText.text];
    _score=0;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %li", (long)_score];
    for(PlayingCardView *anyView in self.genericArray)
        [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{[anyView removeFromSuperview];} completion:nil];
    [self.genericArray removeAllObjects];
    [self arrangeCards];
    _with3Cards = false;
    
}

-(CardMatchingGame *)game{
    if(!_game){
        _game = [[CardMatchingGame alloc]initWithCardCount:16 usingDeck:[self createDeck]];
        _score=0;
    }
    return _game;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    for(PlayingCardView *anyView in self.genericArray)
        [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{[anyView removeFromSuperview];} completion:nil];
    [self arrangeCards];
}

-(Deck *)createDeck{
    return [[PlayingCardDeck alloc]init];
}


-(NSInteger)findCard:(NSUInteger)xPoint using:(NSUInteger)yPoint{
    CGPoint aPoint = CGPointMake(xPoint, yPoint);
    for(PlayingCardView *cardView in self.genericArray){
        if([cardView isDescendantOfView:self.genericView]){
            CGRect anyRect = CGRectMake(cardView.frame.origin.x, cardView.frame.origin.y, cardView.frame.size.width, cardView.frame.size.height);
            if(CGRectContainsPoint(anyRect, aPoint)){
                return [self.genericArray indexOfObject:cardView]+1;
            }
        }
    }
    return 0;
}



- (IBAction)tapView:(UITapGestureRecognizer *)sender {
    
    CGPoint location = [sender locationInView:self.genericView];
    NSInteger xPoint = location.x;
    NSInteger yPoint = location.y;
    NSInteger chosenButtonIndex = [self findCard:xPoint using:yPoint]-1;
    if(chosenButtonIndex >=0){
        NSInteger result = [self.game chooseCardForSecondViewController:chosenButtonIndex];
        _score +=result;
        Card *anyCard = [self.game cardAtIndex:chosenButtonIndex];
        if(result==0)
            self.gameText.text = [NSString stringWithFormat:@"%@",anyCard.contents];
        else
            self.gameText.text = [NSString stringWithFormat:@"%@",self.game.result];
    }
    [self updateScreen];
    [self.historicArray addObject:self.gameText.text];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %li", (long)_score];
    
    
}


-(NSAttributedString *)titleForCard:(Card *)sentCard{
    self.scoreString = [[NSMutableAttributedString alloc]initWithString:sentCard.contents];
    if([sentCard.suit  isEqual: @"♣"]|| [sentCard.suit isEqual: @"♠"])
        [self.scoreString addAttribute: NSStrokeColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 1)];
    else if([sentCard.suit  isEqual: @"♦"]|| [sentCard.suit isEqual: @"♥"])
        [self.scoreString addAttribute: NSStrokeColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    return self.scoreString;
}

-(void)updateScreen{
    for(PlayingCardView *cardView in self.genericArray){
        if(![cardView isDescendantOfView:self.genericView] )
            continue;
        NSUInteger  cardViewIndex = [self.genericArray indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardViewIndex];
        if(card.isMatched){
            [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{[cardView removeFromSuperview];} completion:nil];
            _lastCardNumber = _lastCardNumber-1;
        }
    }
    [self makeNoHolesInTheView];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

-(void)makeNoHolesInTheView{
    float xFloor = self.genericView.frame.size.width/5;
    float yFloor = self.genericView.frame.size.height/5;
    float firstXFloor = xFloor;
    float firstYFloor = yFloor;
    float width = 9*xFloor/10;
    float height = 9*yFloor/10;
    float xBegin = xFloor - width/2;
    float yBegin = yFloor - height/2;
    int counter = -1;
    for(int i=0; i<=15; i++){
        if(!_with3Cards && i>12){
            break;
        }
        PlayingCardView *cardView = [self.genericArray objectAtIndex:i];
        if([cardView isDescendantOfView:self.genericView]){
            cardView.frame = CGRectMake(xBegin, yBegin, width, height);
        }
        else
            continue;
        counter++;
        xFloor = xFloor + firstXFloor;
        if((counter+1)%4==0){
            yFloor = yFloor + firstYFloor;
            yBegin = yFloor - height/2;
            xFloor = firstXFloor;
        }
        xBegin = xFloor - width/2;
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"setGameSegue"]){
        HistoryViewController *hVC = [segue destinationViewController];
        hVC.dataPassed = self.historicArray;
    }
}

@end

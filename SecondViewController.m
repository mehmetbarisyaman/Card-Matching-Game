//
//  SecondViewController.m
//  Card Matching
//
//  Created by Baris.
//  Copyright (c) 2016 Baris. All rights reserved.
//

#import "SecondViewController.h"
#import "HistoryViewController.h"


@interface SecondViewController()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *Card;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(strong,nonatomic)NSMutableAttributedString* scoreString;
@property(nonatomic)NSInteger score;
@property (weak, nonatomic) IBOutlet UILabel *gameText;

@end

@implementation SecondViewController



-(NSMutableArray *)historicArray{
    if(!_historicArray2) _historicArray2 = [[NSMutableArray alloc]init];
    return _historicArray2;
}

-(NSMutableAttributedString *)scoreString{
    if(!_scoreString)_scoreString = [[NSMutableAttributedString alloc]init];
    return _scoreString;
}

- (IBAction)dealButton:(UIButton *)sender {
    _game = [[CardMatchingGame alloc]initWithCardCount:[self.Card count] usingDeck:[self createDeck]];
    for(UIButton *selectedButton in self.Card)
        [selectedButton setTitle:[NSString stringWithFormat:@"Start!"] forState:UIControlStateNormal];
    self.gameText.text = [NSString stringWithFormat:@"New Game Starts!"];
    [self.historicArray addObject:self.gameText.text];
    _score=0;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %li", (long)_score];
}

-(CardMatchingGame *)game{
    if(!_game){
        _game = [[CardMatchingGame alloc]initWithCardCount:[self.Card count] usingDeck:[self createDeck]];
        _score=0;
    }
    return _game;
}


-(Deck *)createDeck{
    return [[PlayingCardDeck alloc]init];
}

- (IBAction)cardSelection:(UIButton *)sender {
    NSUInteger chosedIndex = [self.Card indexOfObject:sender];
    Card *anyCard = [self.game cardAtIndex:chosedIndex];
    NSInteger result = [self.game chooseCardForSecondViewController:chosedIndex];
    _score +=result;
    if(result==0)
        self.gameText.text = [NSString stringWithFormat:@"%@",anyCard.contents];
    else
        self.gameText.text = [NSString stringWithFormat:@"%@",self.game.result];
    [self.historicArray addObject:self.gameText.text];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %li", (long)_score];
    [self updateScreen];
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
    for(UIButton *selectedButton in self.Card){
        NSUInteger cardButtonIndex = [self.Card indexOfObject:selectedButton];
        Card *anyCard = [self.game cardAtIndex:cardButtonIndex];
        [selectedButton setAttributedTitle:[self titleForCard:anyCard] forState:UIControlStateNormal];
        selectedButton.enabled = !anyCard.isMatched;
        }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"setGameSegue"]){
        HistoryViewController *hVC = [segue destinationViewController];
        hVC.dataPassed = self.historicArray;
    }
}

@end

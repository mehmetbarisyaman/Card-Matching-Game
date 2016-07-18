//
//  ViewController.m
//  Card Matching
//
//  Created by Baris on 6/19/16.
//  Copyright © 2016 Baris. All rights reserved.
//

#import "ViewController.h"
#import "HistoryViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *switchCase;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property(nonatomic) NSUInteger matchType;
@property (weak, nonatomic) IBOutlet UILabel *GameText;
@property(strong, nonatomic) CardMatchingGame *game;

@end

@implementation ViewController

-(NSMutableArray *)historicArray{
    if(!_historicArray) _historicArray = [[NSMutableArray alloc]init];
    return _historicArray;
}



-(CardMatchingGame *)game{
    if(!_game){
        _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
        self.GameText.text = [NSString stringWithFormat:@"Game Starts!"];
        [self.historicArray addObject:self.GameText.text];
       // [self.game setSayac:_matchType];
    }
    return _game;
}



-(Deck *)createDeck{
    return [[PlayingCardDeck alloc]init];
}


- (IBAction)touchCardButton:(UIButton *)sender {
    NSInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
/*    if(_matchType==3)
        self.GameText.text = [NSString stringWithFormat:@"%@",[self.game chooseMultipleCards:chosenButtonIndex]];
    else
 */
        self.GameText.text = [NSString stringWithFormat:@"%@",[self.game chooseCardAtIndex:chosenButtonIndex]];
    [self.historicArray addObject:self.GameText.text];
    [self updateUI];
}


-(NSString *)titleForCard:(Card *)card{
    return card.isChosen ? card.contents : @"";
}

-(UIImage *)backgroundImageForCard:(Card *)card{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (IBAction)touchResetButton:(UIButton *)sender {
    _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    self.GameText.text = [NSString stringWithFormat:@"New Game Starts!"];
    [self.historicArray addObject:self.GameText.text];
    [self.game setSayac:_matchType];
    [self updateUI];
}

-(void)updateUI{
    
    for(UIButton *cardButton in self.cardButtons){
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"cardMatchingGameSegue"]){
        HistoryViewController *hVC = [segue destinationViewController];
        hVC.dataPassed = self.historicArray;
    }
}



@end

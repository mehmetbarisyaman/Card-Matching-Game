//
//  ViewController.m
//  Card Matching
//
//  Created by Baris on 6/19/16.
//  Copyright © 2016 Baris. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardView.h"
#import "HistoryViewController.h"
#import "DropBehavior.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(strong, nonatomic)UIDynamicAnimator *animator;
@property(strong, nonatomic) NSMutableArray *genericArray;
@property(strong, nonatomic)DropBehavior *dropitBehavior;
@property (weak, nonatomic) IBOutlet UIView *genericView;
@property (weak, nonatomic) IBOutlet UILabel *GameText;
@property(strong, nonatomic) CardMatchingGame *game;

@end

@implementation ViewController




-(UIDynamicAnimator *)animator{
    if(!_animator){
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.genericView];
    }
    return _animator;
}


-(DropBehavior *)dropitBehavior{
    if(!_dropitBehavior){
        _dropitBehavior = [[DropBehavior alloc]init];
        [self.animator addBehavior:_dropitBehavior];
    }
    return _dropitBehavior;
}

-(NSMutableArray *)historicArray{
    if(!_historicArray) _historicArray = [[NSMutableArray alloc]init];
    return _historicArray;
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


- (IBAction)allowedPinch:(UIPinchGestureRecognizer *)sender {
    CGFloat factor = [(UIPinchGestureRecognizer *)sender scale];
    if(factor<1)
        for(PlayingCardView *cardView in self.genericArray){
            for(PlayingCardView *anotherView in self.genericArray){
                if(!(cardView ==anotherView)){
                    UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc]initWithItem:cardView attachedToItem:anotherView];
                    [self.animator addBehavior:attachment];
                    [self.dropitBehavior addItem:cardView];
                    [self.dropitBehavior addItem:anotherView];
                }
            }
    }
}


- (IBAction)allowedPan:(UIPanGestureRecognizer *)sender {
    CGPoint gesturePoint = [sender locationInView:self.genericView];
    NSInteger chosedIndex = [self findCard:gesturePoint.x using:gesturePoint.y];
    if(1<=chosedIndex && chosedIndex<=16){
            PlayingCardView *cardView = [self.genericArray objectAtIndex:chosedIndex-1];
            CGPoint netTranslation;
            CGPoint translation = [(UIPanGestureRecognizer *)sender translationInView:cardView];
            cardView.transform = CGAffineTransformMakeTranslation(netTranslation.x + translation.x, netTranslation.y + translation.y);
            if(sender.state == UIGestureRecognizerStateEnded){
                netTranslation.x +=translation.x ;
                netTranslation.y += translation.y;
        }
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
    
    for(int i=0; i<=15; i++){
        CGRect anyRect = CGRectMake(xBegin, yBegin, width, height);
        PlayingCardView * newView = [[PlayingCardView alloc]initWithFrame:anyRect];
        UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cardback"]];
        backImage.frame = newView.bounds;
        [newView addSubview:backImage];
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
    self.GameText.text = [NSString stringWithFormat:@"New Game Starts!"];
    [self.historicArray addObject:self.GameText.text];
    _game = [[CardMatchingGame alloc] initWithCardCount:[self.genericArray count] usingDeck:[self createDeck]];
    
}



- (IBAction)tapCards:(UITapGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.genericView];
    NSInteger xPoint = location.x;
    NSInteger yPoint = location.y;
    NSInteger chosenButtonIndex = [self findCard:xPoint using:yPoint]-1;
    if(chosenButtonIndex >=0){
        self.GameText.text = [NSString stringWithFormat:@"%@",[self.game chooseCardAtIndex:chosenButtonIndex]];
        [self.historicArray addObject:self.GameText.text];
    }
    [self updateUI];
}


-(CardMatchingGame *)game{
    if(!_game)
        _game = [[CardMatchingGame alloc]initWithCardCount:[self.genericArray count] usingDeck:[self createDeck]];
    return _game;
}

-(Deck *)createDeck{
    return [[PlayingCardDeck alloc]init];
}


-(NSString *)titleForCard:(Card *)card{
    return card.isChosen ? card.contents : @"";
}

-(UIImageView *)backgroundImageForCard:(Card *)card{
    UIImage *resultImage = [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
    UIImageView * resultView = [[UIImageView alloc]initWithImage:resultImage];
    return resultView;
}

- (void)listSubviewsOfView:(UIView *)view {
    NSArray *subviews = [view subviews];
    if ([subviews count] == 0) return;
    NSLog(@"Subview counts: %lu", (unsigned long)[subviews count]);
    for (UIView *subview in subviews) {
        NSLog(@"%@", subview);
    }
}

- (IBAction)touchResetButton:(UIButton *)sender {
    for(PlayingCardView *anyView in self.genericArray)
        [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{[anyView removeFromSuperview];} completion:nil];
    [self.genericArray removeAllObjects];
    [self arrangeCards];
}

-(NSMutableArray *)genericArray{
    if(!_genericArray) _genericArray = [[NSMutableArray alloc]init];
    return _genericArray;
}

-(void)updateUI{
    for(PlayingCardView *cardView in self.genericArray){
        if(![cardView isDescendantOfView:self.genericView] )
            continue;
        NSUInteger  cardViewIndex = [self.genericArray indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardViewIndex];
        [cardView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if(card.isChosen){
            [cardView setSuit:card.suit];
            [cardView setRank:card.rank];
            [cardView setNeedsDisplay];
        }
        else{
            UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cardback"]];
            backImage.frame = cardView.bounds;
            [cardView addSubview:backImage];
        }
        if(card.isMatched){

            [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{[cardView removeFromSuperview];} completion:nil];
            [self makeNoHolesInTheView:cardView];
            
        }
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"cardMatchingGameSegue"]){
        HistoryViewController *hVC = [segue destinationViewController];
        hVC.dataPassed = self.historicArray;
    }
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    for(PlayingCardView *anyView in self.genericArray)
        [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{[anyView removeFromSuperview];} completion:nil];
    [self arrangeCards];
}


-(void)makeNoHolesInTheView:(PlayingCardView *)removedCard{
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


-(void)viewDidLoad{
    [super viewDidLoad];
    [self arrangeCards];
}

@end

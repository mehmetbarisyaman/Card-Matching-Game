//
//  SecondViewController.h
//  Card Matching
//
//  Created by Baris.
//  Copyright (c) 2016 Baris. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCard.h"
#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property(strong, nonatomic) CardMatchingGame *game;

@property(strong, nonatomic)NSMutableArray *historicArray2;


@end

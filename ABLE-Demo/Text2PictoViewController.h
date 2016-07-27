//
//  UIViewController+Text2PictoViewController.h
//  ABLE Services
//
//  Created by ariadna on 09/02/15.
//  Copyright (c) 2015 Ariadna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Text2PictoViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSMutableArray *pictogramas;
@property (weak, nonatomic) IBOutlet UILabel *inputTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageTypeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageTextLabel;

@end
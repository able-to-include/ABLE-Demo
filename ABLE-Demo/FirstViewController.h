//
//  FirstViewController.h
//  ABLE Services
//
//  Created by ariadna on 06/02/15.
//  Copyright (c) 2015 Ariadna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UITextViewDelegate>

//@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) IBOutlet UITextView *inputText;
@property (retain, nonatomic) IBOutlet UITextView *simplifiedText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedLanguage;
@property (nonatomic, retain) NSString *language;
@property (weak, nonatomic) IBOutlet UILabel *inputTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *simpTextLabel;

- (IBAction)simplificar:(id)sender;
- (IBAction)languageChanged:(id)sender;

@end


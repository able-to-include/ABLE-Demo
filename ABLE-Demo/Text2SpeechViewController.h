//
//  SecondViewController.h
//  ABLE Services
//
//  Created by ariadna on 06/02/15.
//  Copyright (c) 2015 Ariadna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface Text2SpeechViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *inputText;
@property (nonatomic, retain) NSString *mp4Url;
@property (weak, nonatomic) IBOutlet UITextField *inputText2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *languageSegmented;
@property (nonatomic, retain) NSString *language;
@property (weak, nonatomic) IBOutlet UILabel *inputTextLabel;

@property (nonatomic,strong) MPMoviePlayerController *Reproductor;

- (IBAction)toSpeech:(id)sender;
- (IBAction)languageChanged:(id)sender;

@end


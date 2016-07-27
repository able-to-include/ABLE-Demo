//
//  UIViewController+Credits.h
//  
//
//  Created by ariadna on 6/5/15.
//
//

#import <UIKit/UIKit.h>

@interface Credits : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UILabel *contact;
@property (weak, nonatomic) IBOutlet UILabel *developed;
@property (weak, nonatomic) IBOutlet UILabel *descApp;
@property (weak, nonatomic) IBOutlet UILabel *eSpeak;

@end

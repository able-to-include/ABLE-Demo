//
//  UIViewController+Credits.m
//  
//
//  Created by ariadna on 6/5/15.
//
//

#import "Credits.h"

@implementation Credits
@synthesize version, contact, developed, descApp, eSpeak;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    version.text = NSLocalizedString(@"version_label", @"Mensaje");
    contact.text = NSLocalizedString(@"contact_label", @"Mensaje");
    developed.text = NSLocalizedString(@"developed_by_label", @"Mensaje");
    descApp.text = NSLocalizedString(@"definition", @"Mensaje");
    eSpeak.text = NSLocalizedString(@"definition_eSpeak", @"Mensaje");
    self.title = NSLocalizedString(@"title_activity_credits", @"Mensaje");
}

@end

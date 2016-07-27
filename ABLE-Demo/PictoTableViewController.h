//
//  UITableViewController+Picto.h
//  ABLE Services
//
//  Created by ariadna on 17/02/15.
//  Copyright (c) 2015 Ariadna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictoTableViewController: UIViewController {

    NSMutableArray *pictogramas;

}

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@property (nonatomic, retain) NSMutableArray *pictogramas;

@end

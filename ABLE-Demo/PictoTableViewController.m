//
//  UITableViewController+Picto.m
//  ABLE Services
//
//  Created by ariadna on 17/02/15.
//  Copyright (c) 2015 Ariadna. All rights reserved.
//

#import "PictoTableViewController.h"
#import "PictoCellP.h"
#import "Text2PictoViewController.h"

@implementation PictoTableViewController

@synthesize pictogramas;

// Método para ir a la pantalla anterior al hacer el gesto en el dispositivo
- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeRight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [item setTintColor:[UIColor whiteColor]];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = item;
    
    for (int i=0; i<pictogramas.count;i++){
        NSLog(@"%@", [pictogramas objectAtIndex:i]);
    }
}

-(void)back {
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [UIView animateWithDuration:0.75
                         animations:^{
                             [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                             [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                         }];
        [self.navigationController popViewControllerAnimated:NO];

    }
}

// Número de secciones de la tabla
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
    
// Número de filas en la sección contando los valores inicializados anteriormente
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pictogramas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
    
// Personalizamos la tabla, añadiendo la imagen
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idCell = @"pictoCell";
    
    PictoCellP *Pcell = (PictoCellP*)[tableView dequeueReusableCellWithIdentifier:idCell];
    if (Pcell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"pictoCell" owner:self options:nil];
        Pcell = [nib objectAtIndex:0];
    }
    
    if ([[pictogramas objectAtIndex:indexPath.row] hasPrefix:@"http://"] || [[pictogramas objectAtIndex:indexPath.row] hasPrefix:@"https://"]) {
        Pcell.pictoImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[pictogramas objectAtIndex:indexPath.row]]]];
        Pcell.pictoText.text = @"";
    }
    else{
        Pcell.pictoText.text = [pictogramas objectAtIndex:indexPath.row];
        Pcell.pictoImage.image = Nil;
    }
    
    
    
    return Pcell;
}
    
@end

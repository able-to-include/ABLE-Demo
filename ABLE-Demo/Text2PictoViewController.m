//
//  UIViewController+Text2PictoViewController.m
//  ABLE Services
//
//  Created by Roberto on 09/02/15.
//  Copyright (c) 2015 Ariadna. All rights reserved.
//


/*
 *
 * ViewController de Text2Picto para mostrar el texto en pictogramas
 *
 */

#import "Text2PictoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AbleDatos.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "PictoTableViewController.h"

// URL Base a la que nos conectamos
static NSString * const BaseURLString = @"http://5.56.57.123:8080/ABLE_Webservice/ABLE_API/";

@interface Text2PictoViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmented;
@property (weak, nonatomic) IBOutlet UISegmentedControl *languageSegmented;
@property (weak, nonatomic) IBOutlet UITextView *inputText;
@property(strong) NSDictionary *datosAble;

@end

@implementation Text2PictoViewController

@synthesize inputText, languageSegmented, typeSegmented, language, type, pictogramas, inputTextLabel, imageTypeTextLabel, languageTextLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Inicializamos el lenguaje y el tipo de pictograma
    language=@"english";
    type=@"beta";
    
    
    [languageSegmented setTitle:NSLocalizedString(@"english", @"Mensaje") forSegmentAtIndex:0];
    [languageSegmented setTitle:NSLocalizedString(@"spanish", @"Mensaje") forSegmentAtIndex:1];
    [languageSegmented setTitle:NSLocalizedString(@"dutch", @"Mensaje") forSegmentAtIndex:2];
    
    
    
    inputTextLabel.text = NSLocalizedString(@"input_text", @"Mensaje");
    imageTypeTextLabel.text = NSLocalizedString(@"imageType", @"Mensaje");
    languageTextLabel.text = NSLocalizedString(@"language", @"Mensaje");
    
    // Input text
    [[self.inputText layer] setBorderColor:[[UIColor colorWithRed:152.0/255.0 green:25.0/255.0 blue:184/255.0 alpha:1]CGColor]];
    [[self.inputText layer] setBorderWidth:2.3];
    [[self.inputText layer] setCornerRadius:15];
    inputText.text = NSLocalizedString(@"input_hint", @"Mensaje");
    inputText.textColor = [UIColor lightGrayColor];
    inputText.delegate = self;
    
    // Botón para ocultar teclado
    [self addDoneToolBarToKeyboard:self.inputText];
}

// Se añade el botón Done al teclado
-(void)addDoneToolBarToKeyboard:(UITextView *)textView
{
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleDefault;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"done", @"Mensaje") style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
                         nil];
    [doneToolbar sizeToFit];
    textView.inputAccessoryView = doneToolbar;
}

// Quitamos el teclado al pulsar Done
-(void)doneButtonClickedDismissKeyboard
{
    [inputText resignFirstResponder];
}

// Método para simular Placeholder en el textView
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    inputText.text = @"";
    inputText.textColor = [UIColor blackColor];
    return YES;
}

// Método para simular Placeholder en el textView
-(void) textViewDidChange:(UITextView *)textView
{
    if(inputText.text.length == 0){
        inputText.textColor = [UIColor lightGrayColor];
        inputText.text = NSLocalizedString(@"input_hint", @"Mensaje");
        [inputText resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Controlar el segmento del tipo de pictograma
- (IBAction)typeAction:(UISegmentedControl *)sender {
    switch (self.typeSegmented.selectedSegmentIndex)
    {
        case 0:
            type = @"beta";
            break;
        case 1:
            type = @"sclera";
            break;
        default:
            break;
    }
}

// Controlar el segmento del lenguaje
- (IBAction)languageAction:(UISegmentedControl *)sender {
    switch (self.languageSegmented.selectedSegmentIndex)
    {
        case 0:
            language = @"english";
            break;
        case 1:
            language = @"spanish";
            break;
        case 2:
            language = @"cornetto";
            break;
        default:
            break;
    }
}


// Muestra los pictogramas al pulsar el botón
- (IBAction)text2Picto:(id)sender {
    
    // Evitamos que intenten enviar una cadena vacía
    NSString *auxInput=inputText.text;
    NSString *trimmedString = [auxInput stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (trimmedString.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"wait", @"Alerta") message:NSLocalizedString(@"input_text_cannot_be_empty", @"Mensaje que se le muestra al usuario") delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    else {
        [SVProgressHUD showWithStatus:@"Loading"];
    
        [self downloadDataWithBlock:^(BOOL entrar) {
            if (entrar) {
                [SVProgressHUD dismiss];
                PictoTableViewController *pictoTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"picto"];
                pictoTableViewController.pictogramas = pictogramas;
                [UIView animateWithDuration:0.75
                                 animations:^{
                                     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                     [self.navigationController pushViewController:pictoTableViewController animated:NO];
                                     [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                                 }];
            }
        }];
    }
}

- (void)downloadDataWithBlock:(void (^)(BOOL entrar))block
{
    // 1 Definimos la URL y los parámetros
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    NSDictionary *parameters = @{@"text": inputText.text,@"type":type,@"language":language};
    // 2 Inicializamos el manager de la petición con la URL
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //3 Realizamos la petición a Text2Picto con los parámetros necesarios
    [manager GET:@"Text2Picto" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        self.datosAble = (NSDictionary *)responseObject;
        pictogramas = [self.datosAble pictos];
        if (block) {
            if (pictogramas!=NULL) {
                block(YES);
                
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *mensaje = NSLocalizedString(@"service_error", @"Mensaje que se le muestra al usuario");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:mensaje
                                                            message:NSLocalizedString(@"service_error", @"Mensaje que se le muestra al usuario")
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [SVProgressHUD dismiss];
        [alertView show];
        if (block) {
            if (pictogramas!=NULL) {
                block(YES);
            }
            else
                block(NO);
        }
        
    }];

    
}

@end
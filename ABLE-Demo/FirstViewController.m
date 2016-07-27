//
//  FirstViewController.m
//  ABLE Services
//
//  Created by Roberto on 06/02/15.
//  Copyright (c) 2015 Ariadna. All rights reserved.
//


/*
 *
 * ViewController de Simplext para mostrar el texto simplificado
 *
 */

#import "FirstViewController.h"
#import "AbleDatos.h"
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"

// URL Base a la que nos conectamos
static NSString * const BaseURLString = @"http://5.56.57.123:8080/ABLE_Webservice/ABLE_API/";

@interface FirstViewController ()
@property(strong) NSDictionary *datosAble;

@end

@implementation FirstViewController
@synthesize inputText, simplifiedText, segmentedLanguage, language, inputTextLabel, simpTextLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Inicializamos el lenguaje al inglés
    language=@"english";
    
    inputTextLabel.text = NSLocalizedString(@"input_text", @"Mensaje");
    simpTextLabel.text = NSLocalizedString(@"simpText", @"Mensaje");
    
    [segmentedLanguage setTitle:NSLocalizedString(@"english", @"Mensaje") forSegmentAtIndex:0];
    [segmentedLanguage setTitle:NSLocalizedString(@"spanish", @"Mensaje") forSegmentAtIndex:1];
    
    // Input text
    [[self.inputText layer] setBorderColor:[[UIColor colorWithRed:152.0/255.0 green:25.0/255.0 blue:184/255.0 alpha:1]CGColor]];
    [[self.inputText layer] setBorderWidth:2.3];
    [[self.inputText layer] setCornerRadius:15];
    inputText.text = NSLocalizedString(@"input_hint", @"Mensaje");
    inputText.textColor = [UIColor lightGrayColor];
    inputText.delegate = self;
    
    // Botón para ocultar teclado
    [self addDoneToolBarToKeyboard:self.inputText];
    
    // Simplified Text
    [[self.simplifiedText layer] setBorderColor:[[UIColor grayColor]CGColor]];
    
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

// Simplifica el texto de entrada al pulsar el botón
- (IBAction)simplificar:(id)sender {
    
    
    // Evitamos que intenten enviar una cadena vacía
    NSString *auxInput=inputText.text;
    
    NSString *trimmedString = [auxInput stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (trimmedString.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"wait", @"Alerta") message:NSLocalizedString(@"input_text_cannot_be_empty", @"Mensaje que se le muestra al usuario") delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    else {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading", @"Mensaje de status")];
        
        [self downloadDataWithBlock:^(BOOL entrar) {
            if (entrar) {

                if ([simplifiedText.text isEqualToString:@"Error"] && ![inputText.text isEqualToString:@"Error"]) {
                    
                    NSString *mensaje = NSLocalizedString(@"service_error", @"Mensaje que se le muestra al usuario");
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:mensaje
                                                                    message:NSLocalizedString(@"service_error", @"Mensaje que se le muestra al usuario")
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [alertView show];
                }
                else {
                    simplifiedText.text = [self.datosAble textSimplified];
                }
                [SVProgressHUD dismiss];
            }
        }];
        
    }
}

// Se descarga los datos con los parámetros necesarios. Hasta que no se reciban los datos no se reproduce el vídeo (block).
- (void)downloadDataWithBlock:(void (^)(BOOL entrar))block
{
    // 1 Definimos la URL y los parámetros
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    NSDictionary *parameters = @{@"text": inputText.text,@"language":language};
    simplifiedText.text=NULL;
    // 2 Inicializamos el manager de la petición con la URL
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //3 Realizamos la petición a Text2Speech con los parámetros necesarios
    [manager GET:@"Simplext" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        self.datosAble = (NSDictionary *)responseObject;
        simplifiedText.text = [self.datosAble textSimplified];
        if (block) {
            if (simplifiedText.text!=NULL) {
                block(YES);
                
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *mensaje = NSLocalizedString(@"service_error", @"Mensaje que se le muestra al usuario");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:mensaje
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [SVProgressHUD dismiss];
        [alertView show];
        if (block) {
            if (simplifiedText.text!=NULL) {
                block(YES);
            }
            else
                block(NO);
        }
        
    }];
    
}

// Controlar el segmento del lenguaje
- (IBAction)languageChanged:(UISegmentedControl *)sender {
    switch (self.segmentedLanguage.selectedSegmentIndex)
    {
        case 0:
            language = @"english";
            break;
        case 1:
            language = @"spanish";
            break;
        default: 
            break; 
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

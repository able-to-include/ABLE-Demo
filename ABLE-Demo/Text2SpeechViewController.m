//
//  SecondViewController.m
//  ABLE Services
//
//  Created by Roberto on 06/02/15.
//  Copyright (c) 2015 Ariadna. All rights reserved.
//


/*
 *
 * ViewController de Text2Speech para mostrar el texto en audio
 *
 */

#import "Text2SpeechViewController.h"
#import "AbleDatos.h"
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"

// URL Base a la que nos conectamos
static NSString * const BaseURLString = @"http://5.56.57.123:8080/ABLE_Webservice/ABLE_API/";

@interface Text2SpeechViewController ()
@property(strong) NSDictionary *datosAble;
@end

@implementation Text2SpeechViewController

@synthesize inputText, mp4Url, Reproductor, inputText2, language, languageSegmented, inputTextLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    inputTextLabel.text = NSLocalizedString(@"input_text", @"Mensaje");
    
    // Inicializamos el lenguaje al inglés
    language=@"english";
    
    
    [languageSegmented setTitle:NSLocalizedString(@"english", @"Mensaje") forSegmentAtIndex:0];
    [languageSegmented setTitle:NSLocalizedString(@"spanish", @"Mensaje") forSegmentAtIndex:1];
    [languageSegmented setTitle:NSLocalizedString(@"french", @"Mensaje") forSegmentAtIndex:2];
    [languageSegmented setTitle:NSLocalizedString(@"dutch", @"Mensaje") forSegmentAtIndex:3];
    
    // Input text
    [[self.inputText layer] setBorderColor:[[UIColor colorWithRed:152.0/255.0 green:25.0/255.0 blue:184/255.0 alpha:1]CGColor]];
    [[self.inputText layer] setBorderWidth:2.3];
    [[self.inputText layer] setCornerRadius:15];
    inputText.text = NSLocalizedString(@"input_hint", @"Mensaje");
    inputText.textColor = [UIColor lightGrayColor];
    inputText.delegate = self;
    // Botón para ocultar teclado
    [self addDoneToolBarToKeyboard:self.inputText];
    
    CGRect frameRect = inputText2.frame;
    frameRect.size.height = 53;
    inputText2.frame = frameRect;
    
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

// Reproduce el audio al pulsar el botón
- (IBAction)toSpeech:(id)sender {
    
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
                // Initialize the movie player view controller with a video URL string
                MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:mp4Url]];
                
                // Remove the movie player view controller from the "playback did finish" notification observers
                [[NSNotificationCenter defaultCenter] removeObserver:playerVC
                                                                name:MPMoviePlayerPlaybackDidFinishNotification
                                                              object:playerVC.moviePlayer];
                
                // Register this class as an observer instead
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(movieFinishedCallback:)
                                                             name:MPMoviePlayerPlaybackDidFinishNotification
                                                           object:playerVC.moviePlayer];
                
                // Set the modal transition style of your choice
                playerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                
                // Present the movie player view controller
                [self presentViewController:playerVC animated:YES completion:nil];
                
                // Start playback
                [playerVC.moviePlayer prepareToPlay];
                [playerVC.moviePlayer play];

                [SVProgressHUD dismiss];
            }
        }];

    }
}


// Se notifica que se ha terminado de reproducir el audio
- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        // Dismiss the view controller
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// Se descarga los datos con los parámetros necesarios. Hasta que no se reciban los datos no se reproduce el vídeo (block).
- (void)downloadDataWithBlock:(void (^)(BOOL entrar))block
{
    // 1 Definimos la URL y los parámetros
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    NSDictionary *parameters = @{@"text": inputText.text,@"language":language};
    mp4Url=NULL;
    // 2 Inicializamos el manager de la petición con la URL
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //3 Realizamos la petición a Text2Speech con los parámetros necesarios
    [manager GET:@"Text2Speech" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        self.datosAble = (NSDictionary *)responseObject;
        mp4Url = [self.datosAble audioSpeech];
        if (block) {
            if (mp4Url!=NULL) {
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
            if (mp4Url!=NULL) {
                block(YES);
            }
            else
                block(NO);
        }
        
    }];
    
}

// Controlar el segmento del lenguaje
- (IBAction)languageChanged:(UISegmentedControl *)sender {
    switch (self.languageSegmented.selectedSegmentIndex)
    {
        case 0:
            language = @"english";
            break;
        case 1:
            language = @"spanish";
            break;
        case 2:
            language = @"french";
            break;
        case 3:
            language = @"dutch";
            break;
        default:
            break;
    }
}

@end

//
//  NSObject+AbleDatos.m
//  ABLE Services
//
//  Created by Roberto on 12/02/15.
//  Copyright (c) 2015 Ariadna. All rights reserved.
//

/*
 *
 * Clase del objeto JSON recibido
 *
 */

#import "AbleDatos.h"

@implementation NSDictionary (AbleDatos)


-(NSString *)textInput
{
    return self[@"textInput"];
}

-(void) setTextInput:(NSString *)textInput
{
    
}

-(NSString *)textSimplified
{
    return self[@"textSimplified"];
}

-(void) setTextSimplified:(NSString *)textSimplified {

}

-(NSMutableArray *)pictos
{
    return self[@"pictos"];
}

-(void) setPictos:(NSMutableArray *)pictos {

}

-(NSString *)audioSpeech
{
    return self[@"audioSpeech"];
}

-(void) setAudioSpeech:(NSString *)audioSpeech {

}




@end

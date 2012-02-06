//
//  Constants.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 10.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString* const errorMissingUsername = @"Sorry, der Username fehlt.";
NSString* const errorMissingPassword = @"Sorry, das Passwort fehlt.";
NSString* const errorUsernameAlreadyInUse = @"Sorry, dieser Name ist leider schon vergeben.";
NSString* const errorUsernameOrUsernameIncorrect = @"Sorry, der Username oder das Passwort ist falsch.";
NSString* const errorTryAgainLater = @"Ups, da ging etwas schief. Probiere es später noch einmal!";
NSString* const errorAlreadyYourExpose = @"Dieses Expose gehört dir schon!";
NSString* const errorExposeHasNoRent = @"Das Expose hat keinen Wert für Kaltmiete, sie kann nicht übernommen werden.";
NSString* const errorExposeNotExists = @"Das Expose gibt es nicht";

NSString* const urlIS24API = @"http://rest.immobilienscout24.de/restapi/api/search/v1.0/";
NSString* const urlIS24MobileExpose = @"http://mobil.immobilienscout24.de/expose/";
NSString* const urlImmopolyUser = @"https://immopoly.appspot.com/user/";
NSString* const urlImmopolyPortfolio = @"http://immopoly.appspot.com/portfolio/";

NSString* const urlImmopolyExpose = @"https://immopoly.appspot.com/user/exposes";

NSString* const alertLoginWrongInput = @"Es ist ein Fehler aufgetreten, da eines der beiden Textfelder nicht befüllt wurde.";
NSString* const alertRegisterWrongInput = @"Es wurde eine falsche Eingabe getätigt.";
NSString* const alertRegisterSuccessful = @"Glückwunsch! Du hast dich erfolgreich registriert und wurdest nun automatisch eingeloggt.";

NSString* const alertResetPasswordWrongInput = @"Es wurde eine falsche Eingabe getätigt.";
NSString* const alertResetPasswordSuccessful = @"Du bekommst in Kürze eine E-Mail mit dem Link, mit dem du dein Passwort ändern kannst.";

NSString* const alertExposeGiveAwayWarning =@"Das Abgeben eines Exposes kostet dich eine Strafe. Möchtest du trotzdem fortfahren?";

NSString* const sharingActionSheetTitle = @"Teile diese Wohnung mit Freunden!";

NSString* const sharingFacebookTitle = @"Immopoly for iPhone";
NSString* const sharingFacebookCaption = @"Werde Immobilienhai und Millionär";
NSString* const sharingFacebookDescription = @"Immopoly ein Spiel für iPhone & Android";
NSString* const sharingFacebookLink = @"http://www.immopoly.org/";
NSString* const sharingFacebookActionLabel = @"Immobilien Scout 24";
NSString* const sharingFacebookActionText = @"Schau dir doch mal die folgende Wohnung an";

NSString* const sharingTwitterAPINotAvailableAlertTitle = @"Keine iOS 5";
NSString* const sharingTwitterAPINotAvailableAlertMessage = @"Du brauchst iOS 5, um die Twitter Funktion verwenden zu können.";
NSString* const sharingTwitterNoAccountAlertTitle = @"Kein Account";
NSString* const sharingTwitterNoAccountAlertMessage = @"Du brauchst ein Twitter account, um diese Funktion verwenden zu können.";
NSString* const sharingTwitterMessage = @"Coole Wohnung gefunden!";

NSString* const sharingMailSubject = @"Super Wohnung gefunden";

NSString* const errorTokenNotFound = @"Automatischer Login ist fehlgeschlagen. Bitte gib deine Anmeldedaten erneut ein.";

NSString* const feedbackMailSubject = @"Benutzerfeedback";

@end
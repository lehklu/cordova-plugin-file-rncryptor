#import "FileRNCryptor.h"

@implementation FileRNCryptor


NSString *const PREFIX_ERROR = @"ERR: ";

- (NSString *)_asError:(NSString *)msg {

	return [PREFIX_ERROR stringByAppendingString:msg];
}

/**
 *  encrypt
 *
 *  @param command An array of arguments passed from javascript
 */
- (void)encrypt:(CDVInvokedUrlCommand *)command {

  [self.commandDelegate
  	sendPluginResult:[self crypto:@"encrypt" command:command]
  	callbackId:command.callbackId];
}

/**
 *  decrypt
 *
 *  @param command An array of arguments passed from javascript
 */
- (void)decrypt:(CDVInvokedUrlCommand *)command {

  [self.commandDelegate
  	sendPluginResult:[self crypto:@"decrypt" command:command]
  	callbackId:command.callbackId];
}

/**
 *  Encrypts or decrypts file at given URI.
 *
 *
 *  @param action  Cryptographic operation
 *  @param command Cordova arguments
 *
 *  @return result of operation
 */
- (CDVPluginResult*)crypto:(NSString *)action command:(CDVInvokedUrlCommand *)command {

  NSData *data = nil;
  NSString *path = [command.arguments objectAtIndex:0];
  NSString *password = [command.arguments objectAtIndex:1];
  NSFileManager *fileManager = [NSFileManager defaultManager];

  BOOL fileExists = [fileManager fileExistsAtPath:path];


  if(path==nil || [path length]==0 || password == nil || [password length] == 0)
  	return [CDVPluginResult
  						resultWithStatus:CDVCommandStatus_ERROR
  						messageAsString:[self _asError: @"Empty argument"]];

  if(! fileExists)
  	return [CDVPluginResult
  						resultWithStatus:CDVCommandStatus_ERROR
  						messageAsString:[self _asError: @"File not found"]];


	NSData *fileData = [NSData dataWithContentsOfFile:path];

  NSError *error;
  if ([action isEqualToString:@"encrypt"])
  {
    data = [RNEncryptor
    					encryptData:fileData
              withSettings:kRNCryptorAES256Settings
              password:password
              error:&error];

	}
	else if ([action isEqualToString:@"decrypt"])
	{
    data = [RNDecryptor
    					decryptData:fileData
              withPassword:password
              error:&error];
	}
	else
	{
		return [CDVPluginResult
  						resultWithStatus:CDVCommandStatus_ERROR
  						messageAsString:[self _asError: @"Action not 'encrypt' or 'decrypt'"]];
	}


  if(error != nil)
  {
		return [CDVPluginResult
  						resultWithStatus:CDVCommandStatus_ERROR
  						messageAsString:[self _asError: [error localizedDescription]]];
  }



	[data writeToFile:path atomically:YES];
	return [CDVPluginResult
						resultWithStatus:CDVCommandStatus_OK
						messageAsString:path];
}

@end

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
 *  encryptText
 *
 *  @param command An array of arguments passed from javascript
 */
- (void)encryptText:(CDVInvokedUrlCommand *)command {

  [self.commandDelegate
  	sendPluginResult:[self cryptoText:@"encryptText" command:command]
  	callbackId:command.callbackId];
}

/**
 *  decryptText
 *
 *  @param command An array of arguments passed from javascript
 */
- (void)decryptText:(CDVInvokedUrlCommand *)command {

  [self.commandDelegate
  	sendPluginResult:[self cryptoText:@"decryptText" command:command]
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

/**
 *  Encrypts or decrypts given text.
 *
 *
 *  @param action  Cryptographic operation
 *  @param command Cordova arguments
 *
 *  @return result of operation
 */
- (CDVPluginResult*)cryptoText:(NSString *)action command:(CDVInvokedUrlCommand *)command {

  NSData *data = nil;
  NSString *text = [command.arguments objectAtIndex:0];
  NSString *password = [command.arguments objectAtIndex:1];

  if(text == nil || [text length] == 0)
  	return [CDVPluginResult
  						resultWithStatus:CDVCommandStatus_ERROR
  						messageAsString:[self _asError: @"Empty argument"]];


  NSError *error;
  NSString *result = nil;
  if ([action isEqualToString:@"encryptText"])
  {
    NSData *textData = [text dataUsingEncoding:NSUTF8StringEncoding];

    data = [RNEncryptor
    					encryptData:textData
              withSettings:kRNCryptorAES256Settings
              password:password
              error:&error];

    result = [data base64EncodedStringWithOptions:0];
	}
	else if ([action isEqualToString:@"decryptText"])
	{
    NSData *cryptData = [[NSData alloc] initWithBase64EncodedString:text options:0]; 

    data = [RNDecryptor
    					decryptData:cryptData
              withPassword:password
              error:&error];

    result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	}
	else
	{
		return [CDVPluginResult
  						resultWithStatus:CDVCommandStatus_ERROR
  						messageAsString:[self _asError: @"Action not 'encryptText' or 'decryptText'"]];
	}


  if(error != nil)
  {
		return [CDVPluginResult
  						resultWithStatus:CDVCommandStatus_ERROR
  						messageAsString:[self _asError: [error localizedDescription]]];
  }


	return [CDVPluginResult
						resultWithStatus:CDVCommandStatus_OK
						messageAsString:result];
}

@end

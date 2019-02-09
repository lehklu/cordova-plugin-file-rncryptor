package at.lehklu.android;

import org.cryptonode.jncryptor.*;

import java.io.IOException;

import org.apache.cordova.LOG;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaResourceApi;

import org.json.JSONArray;
import org.json.JSONException;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;

/**
 * This class encrypts and decrypts files using the jncryptor lib
 */
public class FileRNCryptor extends CordovaPlugin {

  private static final String TAG = "FileRNCryptor";

  public static final String ENCRYPT_ACTION = "encrypt";
  public static final String DECRYPT_ACTION = "decrypt";

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

		if( ! (action.equals(ENCRYPT_ACTION) || action.equals(DECRYPT_ACTION)))
    	return false;


		Path path = Paths.get(args.getString(0));
    String pass = args.getString(1);

    this.cryptOp(path, pass, action, callbackContext);

    return true;
  }

  private void cryptOp(Path path, String password, String action, CallbackContext callbackContext) {

		boolean fileWritable=Files.isWritable(path);

  	if(! fileWritable)
  	{
  		callbackContext.error("File not writable:"+path.toString());
  		return;
  	}


  	try
  	{
			byte[] data=Files.readAllBytes(path);

			JNCryptor cryptor = new AES256JNCryptor();

			byte[] cryptData=ENCRYPT_ACTION.equals(action)?
				cryptor.encryptData(data, password.toCharArray()):
				cryptor.decryptData(data, password.toCharArray());

			Files.write(path, cryptData);

			callbackContext.success(path.toString());

    } catch (IOException e) {
      LOG.d(TAG, "cryptoOp IOException: " + e.getMessage());
      callbackContext.error(e.getMessage());
    } catch (OutOfMemoryError e) {
      LOG.d(TAG, "cryptoOp OutOfMemoryError: " + e.getMessage());
      callbackContext.error(e.getMessage());
    } catch (SecurityException e) {
      LOG.d(TAG, "cryptoOp SecurityException: " + e.getMessage());
      callbackContext.error(e.getMessage());
		} catch (CryptorException e) {
      LOG.d(TAG, "cryptoOp CryptorException: " + e.getMessage());
      callbackContext.error(e.getMessage());
		}
  }
}

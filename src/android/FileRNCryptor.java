package at.lehklu.android;

import org.cryptonode.jncryptor.*;

import java.io.IOException;

import org.apache.cordova.LOG;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaResourceApi;

import org.json.JSONArray;
import org.json.JSONException;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.channels.FileChannel;

import java.nio.ByteBuffer;
import java.util.Base64;
import java.nio.charset.StandardCharsets;

/**
 * This class encrypts and decrypts files using the jncryptor lib
 */
public class FileRNCryptor extends CordovaPlugin {

  private static final String TAG = "FileRNCryptor";

  public static final String ENCRYPT_ACTION = "encrypt";
  public static final String DECRYPT_ACTION = "decrypt";
  public static final String ENCRYPTTEXT_ACTION = "encryptText";
  public static final String DECRYPTTEXT_ACTION = "decryptText";  

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

    if(action.equals(ENCRYPT_ACTION) || action.equals(DECRYPT_ACTION))
    {
      final String path = args.getString(0);
      final String pass = args.getString(1);
  
      this.cryptOp(path, pass, action, callbackContext);
    }
    else if(action.equals(ENCRYPTTEXT_ACTION) || action.equals(DECRYPTTEXT_ACTION))
    {
      final String text = args.getString(0);
      final String pass = args.getString(1);
  
      this.cryptOpText(text, pass, action, callbackContext);
    }
    else
    {

      return false;
      //<--
    }


    return true;
  }

  private void cryptOp(String path, String password, String action, CallbackContext callbackContext) {

  	try
  	{
  		FileInputStream iStream=new FileInputStream(path);
  		FileChannel iChannel=iStream.getChannel();

  		if(Integer.MAX_VALUE<iChannel.size())
  		{
      	LOG.d(TAG, "cryptoOp: file too large");
      	callbackContext.error("cryptoOp: file too large");
  			return;
  			//<--
  		}


  		ByteBuffer buffer=ByteBuffer.allocate((int)iChannel.size());
  		iChannel.read(buffer);
			byte[] data=buffer.array();
			iStream.close();


			JNCryptor cryptor = new AES256JNCryptor();

			byte[] cryptData=ENCRYPT_ACTION.equals(action)?
				cryptor.encryptData(data, password.toCharArray()):
				cryptor.decryptData(data, password.toCharArray());


			FileOutputStream oStream=new FileOutputStream(path);
			FileChannel oChannel=oStream.getChannel();
			oChannel.write(ByteBuffer.wrap(cryptData));
			oStream.close();

			callbackContext.success(path);

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

  private void cryptOpText(String text, String password, String action, CallbackContext callbackContext) {

  	try
  	{
			JNCryptor cryptor = new AES256JNCryptor();

			byte[] cryptData=ENCRYPT_ACTION.equals(action)?
				cryptor.encryptData(text.getBytes(StandardCharsets.UTF_8), password.toCharArray()):
				cryptor.decryptData(Base64.getDecoder().decode(text), password.toCharArray());

			callbackContext.success(ENCRYPT_ACTION.equals(action)?
        Base64.getEncoder().encodeToString(cryptData):
        new String(cryptData, StandardCharsets.UTF_8));

    } catch (SecurityException e) {
      LOG.d(TAG, "cryptoOp SecurityException: " + e.getMessage());
      callbackContext.error(e.getMessage());
		} catch (CryptorException e) {
      LOG.d(TAG, "cryptoOp CryptorException: " + e.getMessage());
      callbackContext.error(e.getMessage());
		}
  }  
}

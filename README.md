cordova-plugin-file-rncryptor
====

> Cordova File Encryption Plugin for Android and iOS.
> Using RNCryptor(iOS) and JNCryptor(Android) for interchangeable files

> Based on:
>
> - https://github.com/prsuhas/cordova-plugin-file-encryption
>
> - https://github.com/VJAI/simple-crypto

## Install

```bash
$ cordova plugin add cordova-plugin-file-rncryptor
```

## Usage

```javascript
window['FileRNCryptor'].encrypt($localPath, $password,
	($$file)=>{ $resolve($$file); },
	($$err)=>{ $reject($$err); });

window['FileRNCryptor'].decrypt($localPath, $password,
	($$file)=>{ $resolve($$file); },
	($$err)=>{ $reject($$err); });
```

## API

The plugin exposes the following methods:

```javascript
window['FileRNCryptor'].encrypt(file, key, success, error);
window['FileRNCryptor'].decrypt(file, key, success, error);
```
#### Parameters:
* __file:__ A string representing a local path
* __key:__ A key for the crypto operations
* __success:__ Optional success callback
* __error:__ Optional error callback
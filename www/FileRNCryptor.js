/**
 * FileRNCryptor.js
 *
 * @overview Cryptographic file operations for Cordova.
 * @author Werner Lechner
 * @license MIT
*/
var exec = require('cordova/exec');

var PLUGIN_NAME = 'FileRNCryptor';

var FileRNCryptor = {
  encrypt: function (path, password, success, error) {

    exec(success, error, PLUGIN_NAME, 'encrypt', [path, password]);
  },
  decrypt: function (path, password, success, error) {

    exec(success, error, PLUGIN_NAME, 'decrypt', [path, password]);
  },
};

module.exports = FileRNCryptor;

cordova.define("cordova-plugin-shared-preferences.SharedPreferences", function(require, exports, module) { 'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.getSharedPreferences = getSharedPreferences;
exports.putString = putString;
exports.getString = getString;
exports.remove = remove;
exports.clear = clear;
var PLUGIN = 'SharedPreferences';

function getSharedPreferences(file, mode, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, PLUGIN, 'getSharedPreferences', [file, mode]);
}

function putString(key, string, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, PLUGIN, 'putString', [key, string]);
}

function getString(key, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, PLUGIN, 'getString', [key]);
}

function remove(key, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, PLUGIN, 'remove', [key]);
}

function clear(successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, PLUGIN, 'clear', ['null']);
}
});

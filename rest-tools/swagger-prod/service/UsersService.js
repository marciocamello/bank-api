'use strict';


/**
 * create user
 * 
 *
 * body CreateuserRequest 
 * contentType String 
 * authorization String  (optional)
 * returns Object
 **/
exports.createuser = function(body,contentType,authorization) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = "{}";
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * list user
 * 
 *
 * authorization String  (optional)
 * returns Object
 **/
exports.listuser = function(authorization) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = "{}";
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * show user
 * 
 *
 * authorization String  (optional)
 * returns Object
 **/
exports.showuser = function(authorization) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = "{}";
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * terminate user
 * 
 *
 * authorization String  (optional)
 * returns Object
 **/
exports.terminateuser = function(authorization) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = "{}";
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * update user
 * 
 *
 * body UpdateuserRequest 
 * contentType String 
 * authorization String  (optional)
 * returns Object
 **/
exports.updateuser = function(body,contentType,authorization) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = "{}";
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


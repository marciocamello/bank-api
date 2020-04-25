'use strict';


/**
 * create
 * 
 *
 * body CreateRequest 
 * contentType String 
 * authorization String  (optional)
 * returns Object
 **/
exports.create = function(body,contentType,authorization) {
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
 * current account
 * 
 *
 * authorization String  (optional)
 * returns Object
 **/
exports.currentaccount = function(authorization) {
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
 * login
 * 
 *
 * body LoginRequest 
 * contentType String 
 * authorization String  (optional)
 * returns Object
 **/
exports.login = function(body,contentType,authorization) {
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
 * terminate
 * 
 *
 * authorization String  (optional)
 * returns Object
 **/
exports.terminate = function(authorization) {
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
 * transfer
 * 
 *
 * body TransferRequest 
 * contentType String 
 * authorization String  (optional)
 * returns Object
 **/
exports.transfer = function(body,contentType,authorization) {
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
 * withdrawal
 * 
 *
 * body WithdrawalRequest 
 * contentType String 
 * authorization String  (optional)
 * returns Object
 **/
exports.withdrawal = function(body,contentType,authorization) {
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


'use strict';


/**
 * filter transactions
 * 
 *
 * body FiltertransactionsRequest 
 * contentType String 
 * authorization String  (optional)
 * returns Object
 **/
exports.filtertransactions = function(body,contentType,authorization) {
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


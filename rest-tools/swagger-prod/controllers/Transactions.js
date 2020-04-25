'use strict';

var utils = require('../utils/writer.js');
var Transactions = require('../service/TransactionsService');

module.exports.filtertransactions = function filtertransactions (req, res, next) {
  var body = req.swagger.params['Body'].value;
  var contentType = req.swagger.params['Content-Type'].value;
  var authorization = req.swagger.params['Authorization'].value;
  Transactions.filtertransactions(body,contentType,authorization)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

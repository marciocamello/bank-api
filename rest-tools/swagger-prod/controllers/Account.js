'use strict';

var utils = require('../utils/writer.js');
var Account = require('../service/AccountService');

module.exports.create = function create (req, res, next) {
  var body = req.swagger.params['Body'].value;
  var contentType = req.swagger.params['Content-Type'].value;
  var authorization = req.swagger.params['Authorization'].value;
  Account.create(body,contentType,authorization)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.currentaccount = function currentaccount (req, res, next) {
  var authorization = req.swagger.params['Authorization'].value;
  Account.currentaccount(authorization)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.login = function login (req, res, next) {
  var body = req.swagger.params['Body'].value;
  var contentType = req.swagger.params['Content-Type'].value;
  var authorization = req.swagger.params['Authorization'].value;
  Account.login(body,contentType,authorization)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.terminate = function terminate (req, res, next) {
  var authorization = req.swagger.params['Authorization'].value;
  Account.terminate(authorization)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.transfer = function transfer (req, res, next) {
  var body = req.swagger.params['Body'].value;
  var contentType = req.swagger.params['Content-Type'].value;
  var authorization = req.swagger.params['Authorization'].value;
  Account.transfer(body,contentType,authorization)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.withdrawal = function withdrawal (req, res, next) {
  var body = req.swagger.params['Body'].value;
  var contentType = req.swagger.params['Content-Type'].value;
  var authorization = req.swagger.params['Authorization'].value;
  Account.withdrawal(body,contentType,authorization)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

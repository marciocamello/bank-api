'use strict';

var utils = require('../utils/writer.js');
var Users = require('../service/UsersService');

module.exports.createuser = function createuser (req, res, next) {
  var body = req.swagger.params['Body'].value;
  var contentType = req.swagger.params['Content-Type'].value;
  var authorization = req.swagger.params['Authorization'].value;
  Users.createuser(body,contentType,authorization)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.listuser = function listuser (req, res, next) {
  var authorization = req.swagger.params['Authorization'].value;
  Users.listuser(authorization)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.showuser = function showuser (req, res, next) {
  var authorization = req.swagger.params['Authorization'].value;
  Users.showuser(authorization)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.terminateuser = function terminateuser (req, res, next) {
  var authorization = req.swagger.params['Authorization'].value;
  Users.terminateuser(authorization)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.updateuser = function updateuser (req, res, next) {
  var body = req.swagger.params['Body'].value;
  var contentType = req.swagger.params['Content-Type'].value;
  var authorization = req.swagger.params['Authorization'].value;
  Users.updateuser(body,contentType,authorization)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

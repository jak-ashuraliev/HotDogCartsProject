var express = require('express');
var router = express.Router();
let logJson = require('../data/log.json');
let vendorsJson = require('../data/vendors.json');
let ordersJson = require('../data/orders.json');
let menuitemsJson = require('../data/menuitems.json');

//Send back the Cart vendors when admin goes to cart locations
router.get('/vendors', function(req, res, next) {
    res.send(vendorsJson);
})

//We have to do something with input from add cart
router.get('/addcart', function(req, res, next) {
    res.send("You should be able to type something in and send it to databse");
    //send cart to database
})

//We have to do something with input from add cart
router.get('/removecart', function(req, res, next) {
    var vendors = JSON.stringify(vendorsJson);
    var vendorsAndComment = vendors.concat("\n They should also be able to toggle availability which will be reflected in the database.");
    res.send(vendorsAndComment);
})

//Get logs when admin goes to logs
router.get('/log', function(req, res, next) {
    res.send(logJson);
})

//Send back the orders when the admin selects incoming orders
router.get('/orders', function(req, res, next){
    res.send(ordersJson);
})

router.get('/menuitems', function(req, res,next){
    var menuitems = JSON.stringify(menuitemsJson);
    var menuitemsAndComment = menuitems.concat("We should add a way to narrow down by location");
    res.send(menuitemsAndComment);
})
module.exports = router;
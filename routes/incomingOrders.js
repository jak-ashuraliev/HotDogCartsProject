const express = require('express');
const router = express.Router();
const vendorJson = require('../data/incomingOrders.json');

//Get All IncomingOrders
router.get('/', function (req, res) {
    res.json(incomingOrdersJson);
});

module.exports = router;
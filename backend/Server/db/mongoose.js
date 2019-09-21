var mongoose = require('mongoose');

mongoose.Promise = global.Promise;
mongoUri = 'mongodb://UddhavNavneeth:ProvInsPassword08@ds014808.mlab.com:14808/provins';
mongoose.connect(mongoUri, function(err) {
    if (err) {
        throw err;
    } else {
        console.log(`Successfully connected to mlab`);
    }
});

module.exports = { mongoose };
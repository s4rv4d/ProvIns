const mongoose = require('mongoose');

mongoose.Promise = global.Promise;
mongoUri = `mongodb://${process.env.MLAB_ID}:${process.env.MLAB_PASS}@ds014808.mlab.com:14808/provins`;
mongoose.connect(mongoUri, function(err) {
    if (err) {
        throw err;
    } else {
        console.log(`Successfully connected to mlab`);
    }
});

module.exports = { mongoose };
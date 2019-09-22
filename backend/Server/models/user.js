const {mongoose} = require('../db/mongoose');
const bcrypt = require('bcryptjs');

const UserSchema = mongoose.Schema({
    email: {
        type: String,
        required: true,
        trim: true,
        unique: true
    },
    password: {
        type: String,
        required: true,
        trim: true
    },
    devices: [{
        devName: {
            type: String,
            trim: true
        },
        devType: {
            type: String,
            trim: true
        },
        mac: {
            type: String,
            trim: true
        },
        ip: {
            type: String,
            trim: true
        },
        uid: {
            type: String,
            trim: true
        },
        blueName: {
            type: String,
            trim: true
        },
        rand: {
            type: String,
            trim: true
        }
    }]
});

UserSchema.methods.isCorrectPassword = function(password, callback){
    bcrypt.compare(password, this.password, function(err, same) {
      if (err) {
        callback(err);
      } else {
        callback(err, same);
      }
    });
}

let User = mongoose.model('User', UserSchema);
module.exports = {User};

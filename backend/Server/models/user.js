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
    aadhaar: {
        type: String,
        required: true,
        trim: true
    },
    devices: [{
        dname: {
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
        }
    }]
});

// UserSchema.pre('save', function(next) {
//       if (this.isModified('password') || this.isModified('aadhaar')) {
//         bcrypt.genSalt(10, (err, salt) => {
//             bcrypt.hash(this.password, salt, (err, hash1) => {
//                 this.password = hash1;
//                 // next();
//             });
//             bcrypt.hash(this.aadhaar, salt, (err, hash2) => {
//                 this.password = hash2;
//                 next();
//             });
//         });
//       }
// })

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

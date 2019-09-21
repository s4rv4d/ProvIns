const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const morgan = require('morgan');
const bcrypt = require('bcryptjs');
const nodemailer = require('nodemailer');
const pass = require("nanoid");
require('dotenv').config();

let {User} = require('./models/user');

const app = express();
const port = process.env.PORT || 4000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(morgan('default'));
app.use(cors());

app.get('/hey', (req,res) => {
    res.send('Heyo!!');
})

app.post('/signup', (req,res) => {

    let hash1 = bcrypt.hashSync(req.body.password, 8);
    let hash2 = bcrypt.hashSync(req.body.aadhaar, 8);
    let user = new User({
        email: req.body.email,
        password: hash1,
        aadhaar: hash2
    });
    user.save().then((doc) => {
        res.send(doc);
    }).catch((e) => {
        console.log(e);
        res.status(500).send('Unsuccesful SignUp');
    })
})

//signup with email
app.post('/newSignup', (req,res) => {
    const passw = pass(8);
    let hash = bcrypt.hashSync(passw, 8);
    const mailOptions = {
        from: 'uddhav.navneeth@gmail.com', // sender address
        to: req.body.email, // list of receivers
        subject: 'Welcome to ProvIns', // Subject line
        html: `<p>Your password currently is: ${passw}</p><p>Login into the app and change your password</p>`// plain text body
      };

    transporter.sendMail(mailOptions, function (err, info) {
        if(err)
          res.status(500).send(err);
        else{
            let user = new User({
                email: req.body.email,
                password: hash
                });
                user.save().then((doc) => {
                    res.send('Succesful');
                }).catch((e) => {
                    console.log(e);
                    res.status(500).send('Unsuccesful SignUp');
                })
        }  
     });
    
})


app.post('/login', function(req, res) {
    const { email, password } = req.body;
    User.findOne({ email }, function(err, user) {
      if (err) {
        console.error(err);
        res.status(500)
          .json({
          error: 'Internal error please try again'
        });
      } else if (!user) {
        res.status(401)
          .json({
            error: 'No such email'
          });
      } else {
        user.isCorrectPassword(password, function(err, same) {
          if (err) {
              console.log(err);
            res.status(500)
              .json({
                error: 'Internal error with password please try again'
            });
          } else if (!same) {
            res.status(401)
              .json({
                error: 'Incorrect password'
            });
          } else {
            // Issue token
            res.status(200).send(user);
          }
        });
      }
    });
  });


//change password
app.post('/changepassword', (req, res) => {
    User.findOne({email: req.body.email}).then((user) => {
        if (!user) {
            res.send('No such email');
        }
        user.isCorrectPassword(req.body.oldpassword, function(err, same) {
            if (err) {
                console.log(err);
                res.status(500).send('Internal Error');
            } else if(!same) {
                res.status(401).send('Incorrect old password');
            } else {
                let hash = bcrypt.hashSync(req.body.newpassword, 8);
                user.password = hash;
                user.save().then((doc) => {
                    res.send(doc);
                }).catch((e) => {
                    console.log(e);
                    res.status(402).send(e);
                })
            }
        })
    }).catch((e) => {
        console.log(e);
        res.status(500).send('Error occured');
    })
})

//set newly generated random password
app.post('/resetpassword', (req, res) => {
    User.findOne({email: req.body.email}).then((user) => {
        const passw = pass(8);
        let hash = bcrypt.hashSync(passw, 8);
        const mailOptions = {
            from: 'uddhav.navneeth@gmail.com', // sender address
            to: req.body.email, // list of receivers
            subject: 'ProvIns: Temporary Password Has Been Set', // Subject line
            html: `<p>Your password has been reset to: ${passw}</p><p>Login into the app and change your password</p>`// plain text body
        };

        transporter.sendMail(mailOptions, function (err, info) {
            if(err) {
                console.log(err);
                res.status(500).send(err);
            }
            
            else{
                    user.password = hash;
                    user.save().then((doc) => {
                        res.send('Succesful');
                    }).catch((e) => {
                        res.status(500).send('Unsuccesful in reseting password');
                    })
            }
        });
    });
})


//Add device
app.post('/add', (req, res) => {
    let device = {
        devName: req.body.devName,
        devType: req.body.devType,
        ip: req.body.ip,
        mac: req.body.mac,
        uid: req.body.uid,
        blueName: req.body.blueName
    }
    User.findOne({email: req.body.email}).then((doc) => {
        
        doc.devices.push(device);
        doc.save().then((resdoc) => {
            res.send(resdoc);
        })
    }).catch((e) => {
        console.log(e);
        res.status(500).send(e);
    })
})

//Delete device
app.post('/delete', (req, res) => {
    User.findOne({email: req.body.email}).then((user) => {

        user.devices = user.devices.filter(( device ) => {
            return device.devType !== req.body.devType;
        });
        user.save().then((resdoc) => {
            res.send(resdoc);
        })

    }).catch((e) => {
        console.log(e);
        res.status(500).send(e);
    })
})

//display all devices
app.post('/display', (req, res) => {
    User.findOne({email: req.body.email}).then((user) => {

        let devices = [...user.devices]
        res.send(devices);

    }).catch((e) => {
        console.log(e);
        res.status(500).send(e);
    })
})

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
           user: process.env.OOF_ID,
           pass: process.env.OOF_PASS
       }
   });

app.listen(port, () => {
    console.log(`started up at ${port}`);
});
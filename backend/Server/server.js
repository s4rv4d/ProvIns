const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const morgan = require('morgan');
const bcrypt = require('bcryptjs');

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
        res.send('Unsuccesful SignUp');
    })
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

//Add device
app.post('/add', (req, res) => {
    let device = {
        dname: req.body.dname,
        ip: req.body.ip,
        mac: req.body.mac,
        uid: req.body.uid
    }
    User.findOne({email: req.body.email}).then((doc) => {
        
        doc.devices.push(device);
        doc.save().then((resdoc) => {
            res.send(resdoc);
        })
    }).catch((e) => {
        res.status(500).send(e);
    })
})

//Delete device
app.post('/delete', (req, res) => {
    User.findOne({email: req.body.email}).then((user) => {

        user.devices = user.devices.filter(( device ) => {
            return device.dname !== req.body.dname;
        });
        user.save().then((resdoc) => {
            res.send(resdoc);
        })

    }).catch((e) => {
        res.status(500).send(e);
    })
})


app.listen(port, () => {
    console.log(`started up at ${port}`);
});
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

// app.post()

app.listen(port, () => {
    console.log(`started up at ${port}`);
});
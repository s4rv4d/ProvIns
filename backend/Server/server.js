const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const morgan = require('morgan');
const bcrypt = require('bcryptjs');

const app = express();
const port = process.env.PORT || 4000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(morgan('default'));
app.use(cors());

app.get('/hey', (req,res) => {
    res.send('Heyo!!');
})

app.listen(port, () => {
    console.log(`started up at ${port}`);
});
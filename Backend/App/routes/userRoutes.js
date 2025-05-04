const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const User = require('../models/user');

router.use(express.urlencoded({ extended: true }));
router.use(express.json());

router.post("/create", async(req, res) => {
    try {
        const existingUser = await User.findOne({email: req.body.email});
        if (existingUser) {
            console.log("already exist");
          return res.status(409).json({ error: 'This email already exists.' });
        }
    
        const hashedPassword = await bcrypt.hash(req.body.password, 10); 
    
        const newUser = new User({
            name: req.body.name,
            email: req.body.email,
            password: hashedPassword,
            score: 0
        }); 
    
        await newUser.save();

        res.status(200).json({ message: 'User created successfully' });
      } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
      }
});

router.get("/", async (req, res) => {
    try {
        const users = await User.find({}, '-password');
        res.status(200).json(users);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

router.post("/login", async (req, res) => {
    try {
        const existingUser = await User.findOne({email: req.body.email});
        if (!existingUser) {
            return res.status(401).json({ error: 'User not found' });
        }

        const isPasswordValid = await bcrypt.compare(req.body.password, existingUser.password);
        if (!isPasswordValid) {
            console.log("password mismatch")
            return res.status(401).json({ error: 'Invalid email or password' });
        }

        const payload = {
            id: existingUser._id,
            name: existingUser.name,
            email: existingUser.email,
            score: existingUser.score
        };


        res.status(200).json({user: payload});
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

module.exports = router;
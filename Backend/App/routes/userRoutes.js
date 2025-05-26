const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const User = require('../models/user');
const Challenge = require('../models/challenge');
const Message = require('../models/message');

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
            score: 0,
            role: 'user'
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

        const challengeCount = await Challenge.countDocuments({
            $and: [
                { completed: true },
                { to: existingUser._id }
            ]
        });

        const payload = {
            id: existingUser._id,
            name: existingUser.name,
            email: existingUser.email,
            score: challengeCount * 10,
            role: existingUser.role,
            challengeCount: challengeCount
        };


        res.status(200).json(payload);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

router.get("/users", async (req, res) => {
    try {
        const users = await User.find({ role: 'user' });

        const payloads = await Promise.all(users.map(async (user) => {
            const challengeCount = await Challenge.countDocuments({
                completed: true,
                to: user._id
            });

            return {
                id: user._id,
                name: user.name,
                email: user.email,
                score: challengeCount * 10,
                role: user.role,
                challengeCount: challengeCount
            };
        }));

        res.status(200).json(payloads);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

router.get("/specialists", async (req, res) => {
    try {
        const users = await User.find({ role: { $in: ['doctor', 'trainer'] } });

        const payloads = await Promise.all(users.map(async (user) => {
            const challengeCount = await Challenge.countDocuments({
                completed: true,
                to: user._id
            });

            return {
                id: user._id,
                name: user.name,
                email: user.email,
                score: challengeCount * 10,
                role: user.role,
                challengeCount: challengeCount
            };
        }));

        res.status(200).json(payloads);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

router.get("/inquiries/:specialistID", async (req, res) => {
  try {
    const { specialistID } = req.params;

    const messages = await Message.find({
      $or: [{ from: specialistID }, { to: specialistID }]
    });

    const userIds = new Set();
    messages.forEach(msg => {
      if (msg.from.toString() !== specialistID) userIds.add(msg.from.toString());
      if (msg.to.toString() !== specialistID) userIds.add(msg.to.toString());
    });

    const users = await User.find({ _id: { $in: Array.from(userIds) } });

    const payloads = await Promise.all(users.map(async (user) => {
      const challengeCount = await Challenge.countDocuments({
        completed: true,
        to: user._id
      });

      return {
        id: user._id,
        name: user.name,
        email: user.email,
        score: challengeCount * 10,
        role: user.role,
        challengeCount
      };
    }));

    res.status(200).json(payloads);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});



module.exports = router;
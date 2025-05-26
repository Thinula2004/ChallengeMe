const express = require('express');
const Challenge = require('../models/challenge');
const User = require('../models/user');
const router = express.Router();

router.post('/create', async (req, res) => {
    try {
      const { title, description, from, to, deadline } = req.body;
  
      if (!title || !description || !from || !to || !deadline) {
        return res.status(400).json({ error: 'All fields are required.' });
      }

      const fromUser = await User.findById(from);
      const toUser = await User.findById(to);
  
      if (!fromUser || !toUser) {
          return res.status(400).json({ error: 'User IDs are invalid.' });
      }

  
      const parsedDeadline = new Date(deadline);
      if (isNaN(parsedDeadline.getTime())) {
        return res.status(400).json({ error: 'Invalid deadline format. Use YYYY-MM-DD.' });
      }
  
      const challenge = new Challenge({
        title,
        description,
        from,
        to,
        deadline: parsedDeadline,
      });
  
      await challenge.save();

      await challenge.populate('from to');
  
      return res.status(200).json({
            id: challenge._id,
            title: challenge.title,
            description: challenge.description,
            from: challenge.from,
            to: challenge.to,
            deadline: challenge.deadline.toISOString().slice(0, 10),
            completed: challenge.completed
      });
    } catch (err) {
      console.error('Error creating challenge:', err);
      return res.status(500).json({ error: 'Server error.' });
    }
  });

router.get('/from/:userId', async (req, res) => {
    try {
        const challenges = await Challenge.find({ from: req.params.userId })
            .populate('from')
            .populate('to');

        const response = challenges.map(ch => ({
            id: ch._id,
            title: ch.title,
            description: ch.description,
            from: ch.from,
            to: ch.to,
            deadline: ch.deadline.toISOString().slice(0, 10),
            completed: ch.completed
        }));

        return res.status(200).json(response);
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Server error.' });
    }
});

router.get('/to/:userId', async (req, res) => {
    try {
        const challenges = await Challenge.find({ to: req.params.userId })
            .populate('from')
            .populate('to');
          
        challenges.sort((a, b) => a.completed === b.completed ? 0 : a.completed ? 1 : -1);

        const response = challenges.map(ch => ({
            id: ch._id,
            title: ch.title,
            description: ch.description,
            from: ch.from,
            to: ch.to,
            deadline: ch.deadline.toISOString().slice(0, 10),
            completed: ch.completed
        }));

        return res.status(200).json(response);
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Server error.' });
    }
});

router.post('/complete/:challengeId', async (req, res) => {
    try {
      const challenge = await Challenge.findById(req.params.challengeId).populate('from')
            .populate('to');
  
      if (!challenge) {
        return res.status(400).json({ error: 'Challenge not found.' });
      }
  
      challenge.completed = true;
      await challenge.save();

      const user = await User.findById(challenge.to.id);

      const challengeCount = await Challenge.countDocuments({
          $and: [
              { completed: true },
              { to: user._id }
          ]
      });

      const payload = {
            id: user._id,
            name: user.name,
            email: user.email,
            score: challengeCount * 10,
            role: user.role,
            challengeCount: challengeCount
        };
  
      return res.status(200).json(payload);
    } catch (err) {
      console.error(err);
      return res.status(500).json({ error: 'Server error.' });
    }
});

router.delete('/:userID', async (req, res) => {
    try{
        const challenge = Challenge.findByIdAndDelete(req.params.userID);

        if(!challenge){
            return res.status(400).json({error: 'Challenge not Found'});
        }

        res.status(200).json(true);

    }catch(err){
        res.status(500).json({error: err.message})
    }
})

module.exports = router;

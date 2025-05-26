const express = require('express');
const router = express.Router();
const Message = require('../models/message');

router.post('/send', async (req, res) => {
    try {
        const { from, to, body } = req.body;

        if (!from || !to || !body) {
            return res.status(400).json({ error: 'Missing required fields' });
        }

        const message = new Message({
            from,
            to,
            body,
            time: new Date()
        });

        await message.save();
        await message.populate('from to');

        const payload = {
            id: message._id,
            from: message.from,
            to: message.to,
            time: message.createdAt,
            body: message.body
        };

        res.status(200).json(payload);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

router.get('/', async (req, res) => {
    try {
        const { fromID, toID } = req.query;

        if (!fromID || !toID) {
            return res.status(400).json({ error: 'fromID and toID are required' });
        }

        const messages = await Message.find({
            $or: [
                { from: fromID, to: toID },
                { from: toID, to: fromID }
            ]
        }).sort({ createdAt: 1 }).populate('from to');

        const payload = messages.map(m => ({
            id: m._id,
            from: {
                id: m.from._id,
                ...m.from.toObject(),
                _id: undefined
            },
            to: {
                id: m.to._id,
                ...m.to.toObject(),
                _id: undefined
            },
            time: m.createdAt,
            body: m.body
        }));

        res.status(200).json(payload);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});


router.delete('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const deleted = await Message.findByIdAndDelete(id);

        if (!deleted) {
            return res.status(404).json({ error: 'Message not found' });
        }

        res.status(200).json({ message: 'Message deleted successfully' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});

module.exports = router;

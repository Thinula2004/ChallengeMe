const mongoose = require('mongoose');

const challengeSchema = new mongoose.Schema({
    title: {type: String, required: true},
    description: {type: String, required: true},
    deadline: {type: Date, required: true},
    from: { 
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true
    },
    to: { 
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true
    },
    completed: {
        type: Boolean, required: false, default: false
    }
});

const Challenge = mongoose.model('Challenge', challengeSchema);

module.exports = Challenge;

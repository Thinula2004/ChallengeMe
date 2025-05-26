const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    name: {type: String, required: true},
    email: {type: String, required: true, minlength: 4, unique: true},
    password: {type: String, required: true, minlength: 4,},
    score: {type: String, required: false},
    role: {
        type: String,
        enum: ['user', 'doctor', 'trainer'],
        default: 'user'
    }
});

const User = mongoose.model('User', userSchema);

module.exports = User;

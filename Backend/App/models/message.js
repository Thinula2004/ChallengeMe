const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
    body: { type: String, required: true },
    from: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    to: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true }
}, { timestamps: true });

const Message = mongoose.model('Message', messageSchema);

module.exports = Message;

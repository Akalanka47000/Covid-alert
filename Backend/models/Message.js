const mongoose = require("mongoose");

const messageSchema = new mongoose.Schema({
  chatroom: {
    type: String,
    required: "Chatroom is required!",
    ref: "Chatroom",
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    required: "User is required!",
    ref: "User",
  },
  message: {
    type: String,
    required: "Message is required!",
  },
  name: {
    type: String,
    required: "Name is required!",
  },
  time: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model("Message", messageSchema);

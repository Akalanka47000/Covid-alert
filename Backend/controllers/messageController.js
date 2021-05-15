const mongoose = require("mongoose");
const Message = mongoose.model("Message");

exports.getAllMessages = async (req, res) => {
    const messages = await Message.find({});

    const filteredMessages=[];
    messages.forEach(function(message) {
      if(message.chatroom==req.params.id){
        filteredMessages.push(message);
      }
    });
    res.json(filteredMessages);
  };

  exports.deleteMessages = async (req, res) => {
    
    const messages = await Message.find({});
    messages.forEach(function(message) {
      if(message.chatroom==req.params.id){
        message.remove();
      }
    });

    res
      .status(200)
      .json({ success: true, message: `Chats with ${req.params.id} deleted sucessfully` });
  };
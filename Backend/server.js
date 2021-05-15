require("dotenv").config();

const mongoose = require("mongoose");
mongoose.connect(process.env.DATABASE, {
  useNewUrlParser: true,
  useCreateIndex: true,
  useFindAndModify: false,
  useUnifiedTopology: true,
});

mongoose.connection.on("error", (err) => {
  console.log("Mongoose Connection ERROR: " + err.message);
});

mongoose.connection.once("open", () => {
  console.log("MongoDB Connected!");
});

//Bring in the models
require("./models/Chatroom");
require("./models/Message");

const app = require("./app");

const PORT = process.env.PORT || 8000;

const server = app.listen(
  PORT,
  console.log(
    `Server running in ${process.env.ENV} mode on port ${PORT}`
  )
);

const io = require("socket.io")(server);
const jwt = require("jsonwebtoken");

const Message = mongoose.model("Message");
const User = require("./models/User");

io.use(async (socket, next) => {
  try {
    const token = socket.handshake.query.token;
    const payload = await jwt.verify(token, process.env.JWT_SECRET);
    socket.userId = payload.id;
    next();
  } catch (err) {}
});

io.on("connection", (socket) => {
  console.log("Connected: " + socket.userId);

  socket.on("disconnect", () => {
    console.log("Disconnected: " + socket.userId);
  });

  socket.on("joinRoom", ({ chatroomId }) => {
    socket.join(chatroomId);
    console.log("A user joined chatroom: " + chatroomId);
  });

  socket.on("leaveRoom", ({ chatroomId }) => {
    socket.leave(chatroomId);
    console.log("A user left chatroom: " + chatroomId);
  });

  socket.on("chatroomMessage", async ({ chatroomId, message }) => {
    if (message.trim().length > 0) {
      const user = await User.findOne({ _id: socket.userId });
      const newMessage = new Message({
        chatroom: chatroomId,
        userId: socket.userId,
        message,
        name: user.name,
      });
      io.to(chatroomId).emit("newMessage", {
        chatroom: chatroomId,
        message,
        name: user.name,
        userId: socket.userId,
        time: newMessage.time,
      });
      await newMessage.save();
    }
  });
});

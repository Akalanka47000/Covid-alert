const router = require("express").Router();

const messageController = require("../controllers/messageController");

const { protect, authorize } = require("../middlewares/auth");

router
.route("/chats/:id")
.get(protect,messageController.getAllMessages)
.delete(protect,messageController.deleteMessages);

module.exports = router;

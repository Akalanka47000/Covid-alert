const router = require("express").Router();
const { catchErrors } = require("../handlers/errorHandlers");
const notificationController = require("../controllers/notificationController");

router.post("/send", catchErrors(notificationController.sendNotification));
router.put("/uploadImage", catchErrors(notificationController.uploadImage));

module.exports = router;

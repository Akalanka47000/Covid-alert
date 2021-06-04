const router = require("express").Router();
const { catchErrors } = require("../handlers/errorHandlers");
const userController = require("../controllers/userController");
const {protect, authorize } = require("../middlewares/auth");
router.post("/login", catchErrors(userController.login));
router.post("/register", catchErrors(userController.register));
router.patch("/update/:id",protect, catchErrors(userController.updateUser));
router.patch("/markPositive/:id",protect, authorize("Admin"), catchErrors(userController.markPositive));
router.patch("/updateLocation/:id",protect, catchErrors(userController.updateLocation));

module.exports = router;

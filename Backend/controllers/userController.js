const User = require("../models/User");

exports.register = async (req, res) => {
  const { name, email, password, role, category } = req.body;

  // Check if user is already exist
  let Euser = await User.findOne({ email });

  if (Euser) {
    return res.status(400).json({
      message: "User already exists!",
    });
  }

  // Create user
  const user = await User.create({
    name,
    email,
    password,
    role,
    category,
  });

  sendTokenResponse(user, 200, res);
};

exports.login = async (req, res) => {
  const { email, password } = req.body;

  // Validate email & password
  if (!email || !password) {
    return res.status(400).json({
      message: "Please provide an email and password",
    });
  }

  // Check for user
  const user = await User.findOne({ email }).select("+password");

  if (!user) {
    return res.status(401).json({
      message: "Invalid credentials",
    });
  }

  // Check if password matches
  const isMatch = await user.matchPassword(password);

  if (!isMatch) {
    return res.status(401).json({
      message: "Invalid credentials",
    });
  }

  sendTokenResponse(user, 200, res);
};

// Get token from model, create cookie and send response
const sendTokenResponse = (user, statusCode, res) => {
  // Create token
  const token = user.getSignedJwtToken();

  const options = {
    expires: new Date(
      Date.now() + process.env.JWT_COOKIE_EXPIRE * 24 * 60 * 60 * 1000
    ),
    httpOnly: true,
  };

  if (process.env.NODE_ENV === "production") {
    options.secure = true;
  }

  res
    .status(statusCode)
    .cookie("token", token, options)
    .json({ success: true, token });
};

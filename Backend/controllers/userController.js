const User = require("../models/User");
const distanceRetriever = require("../utils/distanceRetriever");

var admin = require("firebase-admin");



exports.register = async (req, res) => {
  const { name, email, password, location } = req.body;

  // Validate details
  if (!email || !password || !name) {
    return res.status(400).json({
      message: "Please provide an email, password and a name",
    });
  }

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
    location,
  });

  sendTokenResponse(user, 200, res);
};

exports.login = async (req, res) => {
  const { email, password, device } = req.body;

  // Validate email & password
  if (!email || !password) {
    return res.status(400).json({
      message: "Please provide an email and password",
    });
  }

   // Validate sender
   if (!device) {
    return res.status(400).json({
      message: "Please specify sending device",
    });
  }

  if (device!=="Web" && device!="Mobile") {
    return res.status(400).json({
      message: "Invalid device type",
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

  if(user.role!="Admin" && device=="Web"){
    return res.status(403).json({
      message: "Not authorized",
    });
  }

  sendTokenResponse(user, 200, res);
};

// @desc    Update user 
// @route   PATCH /users/update/:id
// @access  Private/Admin

exports.updateUser =async (req, res,next) => {

  // const { location } = req.body;

  let user = await User.findById(req.params.id);
 
  if (!user) {
    return next(
      res.status(400).json({
        message: `User not found with id of ${req.params.id}`,
      })
    );
  }

   


   user = await User.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
  });

  res.status(200).json({
    success: true,
    data: user,
  });
};


// @desc    Mark a user with given email as corona positive and give him permission to change his status
// @route   PATCH /users/markPositive/:id   where id is the email of the user
// @access  Private/Admin

exports.markPositive =async (req, res,next) => {

  const email=req.params.id;

  const users=await User.find();

  let found=false;
  let userId;
  for(let i=0;i<users.length;i++){
    if(users[i].email==email){
      found=true;
      userId=users[i]._id;
      break;
    }
  }

 
  if (!found) {
    return next(
      res.status(400).json({
        message: `User not found with email of ${email}`,
      })
    );
  }else{
    //update user
    user = await User.findByIdAndUpdate(userId, req.body, {
      new: true,
      runValidators: true,
    });
  
    res.status(200).json({
      success: true,
      data: user,
    });
  }
};


// @desc    Update user location and send out notifications about nearby patients
// @route   PATCH /users/updateLocation/:id
// @access  Private/Admin

exports.updateLocation =async (req, res,next) => {



  let user = await User.findById(req.params.id);
 
  if (!user) {
    return next(
      res.status(400).json({
        message: `User not found with id of ${req.params.id}`,
      })
    );
  }

   


   user = await User.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
  });

  

  const users=await User.find();

  let sendingUser = await User.findById(req.params.id);

  let totalPatientCount=0;

  for(let i=0;i<users.length;i++){

    let distance=distanceRetriever.getDistance(req.body.location.latitude,req.body.location.longitude,users[i].location.latitude,users[i].location.longitude);
    console.log(distance);
    console.log(users[i]._id);
    if(distance<0.005 && users[i]._id.toString()!=req.params.id.toString()){

      //add the person who sent location update to the interacted list of the detected person close to him 
      let interactees=users[i].interactedWith;
      //console.log(interactees);
      let alreadyInList=false;
      for(let j=0;j<interactees.length;j++){
        if(interactees[j].userId.toString()==req.params.id){
          alreadyInList=true;
          break;
        }
      }
      if(!alreadyInList){
        interactees.push(
          {
            "userId":req.params.id.toString(),
            "interactionTime":Date.now,
          }
        );
      }
    
      await User.findByIdAndUpdate(users[i]._id, {"interactedWith":interactees}, {
        new: true,
        runValidators: true,
      });

       //add the person close to him to the interacted list of the person who sent the location update
      
    
       alreadyInList=false;
       for(let j=0;j<sendingUser.interactedWith.length;j++){
         if(sendingUser.interactedWith[j].userId.toString()==users[i]._id.toString()){
           alreadyInList=true;
           break;
         }
       }
       if(!alreadyInList){
        sendingUser.interactedWith.push(
           {
             "userId":users[i]._id.toString(),
             "interactionTime":Date.now,
           }
         );
       }

       await User.findByIdAndUpdate(req.params.id, {
        "interactedWith":sendingUser.interactedWith,
      }, {
        new: true,
        runValidators: true,
      });

     
      //add to total if user is positive
      if(users[i].positiveStatus==true && !sendingUser.alreadyNotifiedList.includes(users[i]._id.toString())){
        totalPatientCount++;
        sendingUser.alreadyNotifiedList.push(users[i]._id.toString());
        await User.findByIdAndUpdate(req.params.id, {
          "alreadyNotifiedList":sendingUser.alreadyNotifiedList
        }, {
          new: true,
          runValidators: true,
        });
      }
    }
  
  }
console.log(totalPatientCount);
  // //update sendingUser
  // await User.findByIdAndUpdate(req.params.id, {
  //   "interactedWith":sendingUser.interactedWith,
  //   "alreadyNotifiedList":sendingUser.alreadyNotifiedList
  // }, {
  //   new: true,
  //   runValidators: true,
  // });

  if(totalPatientCount!=0 && sendingUser.notifications==true ){
    var registrationToken = sendingUser.firebaseToken;
    let body;
    let title;
    if(totalPatientCount==1){
      title="Patient Detected in the Vicinity"
      body="You are in an area close to a covid patient";
    }else{
      title="Patients Detected in the Vicinity";
      body="You are in an area close to "+totalPatientCount+" covid patients";
    }
   
    var payload = {
      notification: {
        title: title,
        body: body,
      }
    };
    var options = {
      priority: "normal",
      timeToLive: 60 * 60
    };
    admin.messaging().sendToDevice(registrationToken, payload, options)
    .then(function(response) {
      console.log("Successfully sent message:", response);
    })
    .catch(function(error) {
      console.log("Error sending message:", error);
    });
  }

  res.status(200).json({
    success: true,
    data: user,
  });
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
    .json({ success: true,token,userData:user});
};

const Image = require("../models/Image");
const User = require("../models/User");
const distanceRetriever = require("../utils/distanceRetriever");

var admin = require("firebase-admin");

// var serviceAccount = require("../serviceAccountKey.json");

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
// });

exports.sendNotification = async (req, res) => {
  
    const { latitude,longitude } = req.body;
  
    // Validate details
    if (!latitude || !longitude) {
      return res.status(400).json({
        message: "Please provide a latitude and a longitude",
      });
    }

    const users=await User.find();

    for(let i=0;i<users.length;i++){
      let distance=distanceRetriever.getDistance(latitude,longitude,users[i].location.latitude,users[i].location.longitude);
      console.log(distance);
      if(distance<1 && users[i].notifications==true){
        var registrationToken = users[i].firebaseToken;
        var payload = {
          notification: {
            title: "Patient Detected in your Vicinity",
            body: parseInt(distance*1000,10)+"m from your current location"
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
    }
    
    return res.status(200).json({
          message: `Sucessfully notified`,
    });
  };


  exports.uploadImage = async (req, res) => {

    const { base64URL } = req.body;
  
    // Validate image
    if (!base64URL ) {
      return res.status(400).json({
        message: "Please upload an image",
      });
    }

    await Image.create({
      base64URL
    });

    return res.status(200).json({
          message: `Image uploaded`,
    });
  };
const functions = require("firebase-functions");
const admin= require("firebase-admin");
const nodemailer = require("nodemailer");
admin.initializeApp(functions.config().firebase);

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "pilltrack.22.iot@gmail.com",
    pass: "mmz22iot",
  },
});

exports.SendReminder = functions.database.ref("userID/notification/reminder").
    onUpdate((snapshot, context) => {
      const payload = {
        notification: {
          title: "Reminder: 5 min to take pills!",
          body: "don't forget!",
          alert: "true",
          sound: "default",
        },
      };

      return admin.database().ref("userID/fcm-token").once("value").then(
          (allToken) => {
            if (allToken.val() && snapshot.after.val() == true) {
              console.log("token available");
              const token = Object.keys(allToken.val());
              return admin.messaging().sendToDevice(token, payload);
            }
          });
    });

exports.SendOkandNextTime = functions.database.
    ref("userID/notification/taken_pill").onUpdate((snapshot, context) => {
      const payload = {
        notification: {
          title: "You took pills in time! Great :)",
          body: "see you next time",
          alert: "true",
          sound: "default",
        },
      };

      return admin.database().ref("userID/fcm-token").once("value").then(
          (allToken) => {
            if (allToken.val() && snapshot.after.val() == true) {
              console.log("token available");
              const token = Object.keys(allToken.val());
              return admin.messaging().sendToDevice(token, payload);
            }
          });
    });


exports.SendLate1Message = functions.database.
    ref("userID/notification/late1").onUpdate((snapshot, context) => {
      const payload = {
        notification: {
          title: "WARNING: you are 15 min LATE!",
          body: "pills need to be taken now.",
          alert: "true",
          sound: "default",
        },
      };

      return admin.database().ref("userID/fcm-token").once("value").then(
          (allToken) => {
            if (allToken.val() && snapshot.after.val() == true) {
              console.log("token available");
              const token = Object.keys(allToken.val());
              return admin.messaging().sendToDevice(token, payload);
            }
          });
    });


exports.SendLate2Message = functions.database.
    ref("userID/notification/late2").onUpdate((snapshot, context) => {
      const payload = {
        notification: {
          title: "You are 30 min LATE!",
          body: "This will be reported. Be careful next time.",
          alert: "true",
          sound: "default",
        },
      };

      return admin.database().ref("userID/fcm-token").once("value").then(
          (allToken) => {
            if (allToken.val() && snapshot.after.val() == true) {
              console.log("token available");
              const token = Object.keys(allToken.val());
              return admin.messaging().sendToDevice(token, payload);
            }
          });
    });

exports.SendRefillReminder = functions.database.
    ref("userID/notification/refill").onUpdate((snapshot, context) => {
      const payload = {
        notification: {
          title: "You need to REFILL your pill box today!",
          body: "Please refill all the cells after your last dose.",
          alert: "true",
          sound: "default",
        },
      };

      return admin.database().ref("userID/fcm-token").once("value").then(
          (allToken) => {
            if (allToken.val() && snapshot.after.val() == true) {
              console.log("token available");
              const token = Object.keys(allToken.val());
              return admin.messaging().sendToDevice(token, payload);
            }
          });
    });

exports.SendNotRefilledWarning = functions.database.
    ref("userID/notification/didNotRefill").onUpdate((snapshot, context) => {
      const payload = {
        notification: {
          title: "WARNING! your pill box will NOT WORK until you refill",
          body: "refill all cells with pills now! then confirm in the app.",
          alert: "true",
          sound: "default",
        },
      };

      return admin.database().ref("userID/fcm-token").once("value").then(
          (allToken) => {
            if (allToken.val() && snapshot.after.val() == true) {
              console.log("token available");
              const token = Object.keys(allToken.val());
              return admin.messaging().sendToDevice(token, payload);
            }
          });
    });

exports.sendMail = functions.database.
    ref("userID/notification/late1").onUpdate((snapshot, context) => {
      if (snapshot.after.val() == true) {
        const mailOptions = {
          from: "pilltrack.22.iot@gmail.com",
          to: "malakmarred159@gmail.com",
          subject: "David is 15min LATE for his pills",
          text: "Call him now please!!",
          html: "<b> David is 15min LATE </b>",
        };
        return transporter.sendMail(mailOptions, (erro, info) => {
          if (erro) {
            console.log("err in send mail");
          } else console.log("mail sent");
        });
      }
    });


exports.SendLate1Monitor = functions.database.
    ref("monitor/notification/late1").onUpdate((snapshot, context) => {
      const payload = {
        notification: {
          title: "Your patient is 15 min LATE for pills",
          body: "Please call him now!",
          alert: "true",
          sound: "default",
        },
      };

      return admin.database().ref("monitor/fcm-token").once("value").then(
          (allToken) => {
            if (allToken.val() && snapshot.after.val() == true) {
              console.log("token available");
              const token = Object.keys(allToken.val());
              return admin.messaging().sendToDevice(token, payload);
            }
          });
    });

exports.SendLate2Monitor = functions.database.
    ref("monitor/notification/late2").onUpdate((snapshot, context) => {
      const payload = {
        notification: {
          title: "Your patient is 30 min LATE for pills",
          body: "This was saved in the LOG.",
          alert: "true",
          sound: "default",
        },
      };

      return admin.database().ref("monitor/fcm-token").once("value").then(
          (allToken) => {
            if (allToken.val() && snapshot.after.val() == true) {
              console.log("token available");
              const token = Object.keys(allToken.val());
              return admin.messaging().sendToDevice(token, payload);
            }
          });
    });

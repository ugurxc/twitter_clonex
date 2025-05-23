/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

/* const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger"); */
/* const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
admin.initializeApp();

exports.addMessage = functions.https.onRequest(async (req, res) => {
  // Grab the text parameter.
  const original = req.query.text;
  // Push the new message into Firestore using the Firebase Admin SDK.
  const writeResult = await admin
      .firestore()
      .collection("messages")
      .add({original: original});
    // Send back a message that we've successfully written the message
  res.json({result: `Message with ID: ${writeResult.id} added.`});
}); */
// //////////////////////////////
/* const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotificationOnMessage = functions.firestore
    .document("user/{userId}/messages/{messageId}")
    .onCreate(async (snapshot, context) => {
      const messageData = snapshot.data();

      const receiverId = messageData.receiverId;

      if (messageData.isNotificationSent) {
        console.log("Bildirimin zaten gönderildiği mesaj:", snapshot.id);
        return null;
      }

      // Alıcının FCM token'ını Firestore'dan al
      const userDoc = await admin.firestore()
          .collection("user").doc(receiverId).get();
      const fcmToken = userDoc.data().fcmToken;


      if (fcmToken) {
        const payload = {
          notification: {
            title: "Yeni Bildirim",
            body: messageData.text,
          },
          token: fcmToken,
        };


        try {
          const response = await admin.messaging().send(payload);
          console.log("Bildirim gönderildi:", response);

          // BildirimgönderildiktensisNonSent alanını true olarak güncelle
          await snapshot.ref.update({isNotificationSent: true});
          console.log("isNotificationSent alanı true olarak güncellendi.");
        } catch (error) {
          console.error("Bildirimi gönderirken hata:", error);
        }
      }

      return null;
    }); */
// ////////////////

const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotificationOnMessage = functions.firestore
    .document("user/{userId}/messages/{messageId}")
    .onCreate(async (snapshot, context) => {
      const messageData = snapshot.data();
      const messageId = messageData.id; // Mesaj modelindeki id'yi alıyoruz
      const receiverId = messageData.receiverId;
      const senderId =messageData.senderId;

      // Mesajın bildirim gönderilip gönderilmediğini kontrol ediyoruz
      const existingNotification = await admin.firestore()
          .collection("notificationsSent")
          .doc(messageId)// messageData.id'yi kullanıyoruz
          .get();

      if (existingNotification.exists) {
        // Eğer bu message.id'ye göre bildirim zaten gönderildiyse çık
        console.log("Bu mesaj için zaten bildirim gönderildi.");
        return null;
      }

      // Alıcının FCM token'ını Firestore'dan al
      const userDoc = await admin.firestore()
          .collection("user").doc(receiverId).get();
      const fcmToken = userDoc.data().fcmToken;

      const senderDoc = await admin.firestore()
          .collection("user").doc(senderId).get();
      const senderName = senderDoc.data().name || "Bilinmeyen";

      if (fcmToken) {
        const payload = {
          notification: {
            title: `${senderName} size bir mesaj gönderdi`,
            body: messageData.text,
          },
          token: fcmToken,
        };

        // Bildirimi FCM aracılığıyla gönder
        await admin.messaging().send(payload)
            .then((response) => {
              console.log("Bildirim gönderildi:", response);
            })
            .catch((error) => {
              console.error("Bildirimi gönderirken hata:", error);
            });

        // Bildirim gönderildikten sonra messageId ile bildirim kaydediyoruz
        await admin.firestore()
            .collection("notificationsSent")
            .doc(messageId)// messageData.id'yi kullanıyoruz
            .set({sentAt: admin.firestore.FieldValue.serverTimestamp()});
      }

      return null;
    });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// Bildirimi FCM aracılığıyla gönder
/*     return admin.messaging().send(payload).then(async (response) => {
          console.log("Bildirim gönderildi:", response);
          await snapshot.ref.update({isNotificationSent: true});
          return null;
        }).catch((error) => {
          console.error("Bildirimi gönderirken hata:", error);
        }); */

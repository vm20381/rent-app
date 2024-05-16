import * as admin from "firebase-admin";

// Initialize your Firebase app (only needed once per app)
admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    databaseURL: "https://captainapp-crew-2024.firebaseio.com",
});

// root user's uid
const uid = "pyn3MMqQWrceCEUKARYg9S6pYUE3"; // cspell: disable-line

// Set or update a user's password
admin
    .auth()
    .updateUser(uid, {
        password: "target",
    })
    .then((userRecord) =>
        console.log("Successfully updated user", userRecord.toJSON())
    )
    .catch((error) => console.error("Error updating user:", error));

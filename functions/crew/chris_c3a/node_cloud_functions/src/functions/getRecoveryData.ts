import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import axios from "axios";
import cors from "cors";

const corsHandler = cors({origin: true});

// Ensure Firebase Admin SDK is initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

export const getRecoveryData = functions.region("europe-west1").https.onRequest( async (request, response) => {
  corsHandler(request, response, async () => {
    const db = admin.firestore();
    try {
      // Fetch the access token from Firestore
      const tokenSnapshot = await db.collection("whoop_tokens").limit(1).get();
      if (tokenSnapshot.empty) {
        response.status(404).send({data: "No access token found."});
        return;
      }
      const accessToken = tokenSnapshot.docs[0].data().access_token;

      // Make the API request to WHOOP
      const apiUrl = "https://api.prod.whoop.com/developer/v1/recovery";
      const apiResponse = await axios.get(apiUrl, {
        headers: {"Authorization": `Bearer ${accessToken}`},
      });

      // Send back the API response
      response.send({data: apiResponse.data});
    } catch (error) {
      console.error("Error fetching recovery data:", error);
      response.status(500).send({data: "Failed to fetch recovery data."});
    }
  });
});

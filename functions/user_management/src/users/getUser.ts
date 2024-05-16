// getUser.ts
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {checkAuth, mapUser} from "../utils/utils";

export const getUser = functions.region("europe-west1").https.onCall(async (data, context) => {
  checkAuth(context);
  // Optional: checkRole for specific access

  try {
    const user = await admin.auth().getUser(data.uid);
    return mapUser(user);
  } catch (error: any) {
    throw new functions.https.HttpsError("internal", error.message);
  }
});

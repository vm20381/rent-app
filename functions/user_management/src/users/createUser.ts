// createUser.ts
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {checkAuth, checkRole, mapUser} from "../utils/utils";

export const createUser = functions.region("europe-west1").https.onCall(async (data, context) => {
  checkAuth(context);
  checkRole(context, ["admin", "manager"]);

  const {displayName, password, email, role} = data;
  try {
    const userRecord = await admin.auth().createUser({
      email,
      password,
      displayName,
    });
    await admin.auth().setCustomUserClaims(userRecord.uid, {role});
    return mapUser(userRecord);
  } catch (error: any) {
    throw new functions.https.HttpsError("internal", error.message);
  }
});

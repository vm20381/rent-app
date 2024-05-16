// updateUser.ts
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {checkAuth, checkRole, mapUser} from "../utils/utils";

export const updateUser = functions.region("europe-west1").https.onCall(async (data, context) => {
  checkAuth(context);
  checkRole(context, ["admin", "manager"]);

  const {uid, displayName, email} = data;
  try {
    await admin.auth().updateUser(uid, {email, displayName});
    return mapUser(await admin.auth().getUser(uid));
  } catch (error: any) {
    throw new functions.https.HttpsError("internal", error.message);
  }
});

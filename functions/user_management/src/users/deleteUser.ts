// deleteUser.ts
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {checkAuth, checkRole} from "../utils/utils";

export const deleteUser = functions.region("europe-west1").https.onCall(async (data, context) => {
  checkAuth(context);
  checkRole(context, ["admin"]);

  try {
    await admin.auth().deleteUser(data.uid);
    return {result: "User deleted successfully"};
  } catch (error: any) {
    throw new functions.https.HttpsError("internal", error.message);
  }
});

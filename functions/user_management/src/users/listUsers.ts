// listUsers.ts
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {checkAuth, checkRole, mapUser} from "../utils/utils";

export const listUsers = functions.region("europe-west1").https.onCall(async (data, context) => {
  checkAuth(context);
  // checkRole(context, ["admin", "manager"]);

  try {
    const listUsersResult = await admin.auth().listUsers();
    const users = listUsersResult.users.map((user) => mapUser(user));
    return {users};
  } catch (error: any) {
    throw new functions.https.HttpsError("internal", error.message);
  }
});

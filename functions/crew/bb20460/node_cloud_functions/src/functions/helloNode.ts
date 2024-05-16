// createUser.ts
import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";
import {
  checkAuth,
  // checkRole,
  // mapUser,
} from "../utils/utils";

export const helloNode = functions.region("europe-west1").https.onCall(async (data, context) => {
  checkAuth(context);
  // checkRole(context, ["admin", "manager"]);
  return "Hello from Firebase!";
});

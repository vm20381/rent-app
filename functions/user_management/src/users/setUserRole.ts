// Import necessary modules from Firebase and utility functions
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {checkAuth, checkRole} from "../utils/utils";
import {logger} from "firebase-functions";

/**
 * Sets or updates a user's role.
 * @param data Contains the uid of the user and the new role to assign.
 * @param context Provides context about this function call, including authentication.
 */
export const setUserRole = functions.region("europe-west1").https.onCall(async (data, context) => {
  logger.info("Received data:", data);
  logger.info("Setting user role");
  // log idToken
  logger.info("idToken:", context.auth?.token);
  // Check if the request is authenticated
  checkAuth(context);
  // Ensure the caller has admin privileges to assign roles
  // checkRole(context, ["admin"]);

  const {uid, role} = data;

  if (!role) {
    throw new functions.https.HttpsError("invalid-argument", "The function must be called with a role.");
  }

  try {
    // Set custom user claims on the user identified by uid
    await admin.auth().setCustomUserClaims(uid, {role});
    return {uid, role, message: `Role ${role} assigned to user ${uid}`};
  } catch (error: any) {
    throw new functions.https.HttpsError("internal", error.message);
  }
});

import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import {logger} from "firebase-functions";
admin.initializeApp();

export const checkAuth = (context: functions.https.CallableContext) => {
  logger.info("Checking authentication...");
  if (!context.auth) {
    console.log("Authentication failed.");
    throw new functions.https.HttpsError("unauthenticated", "The function must be called while authenticated.");
  }
  logger.info("Authentication successful.");
};

export const checkRole = (context: functions.https.CallableContext, roles: Array<string>) => {
  const role = context.auth?.token.role;
  if (!roles.includes(role)) {
    throw new functions.https.HttpsError("permission-denied", "The function must be called by an authorized user.");
  }
};

export const mapUser = (user: admin.auth.UserRecord) => ({
  uid: user.uid,
  email: user.email,
  displayName: user.displayName,
  role: user.customClaims?.role,
  lastSignInTime: user.metadata.lastSignInTime,
  creationTime: user.metadata.creationTime,
  photoURL: user.photoURL,
});

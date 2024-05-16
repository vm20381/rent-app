"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.setUserRole = void 0;
// Import necessary modules from Firebase and utility functions
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
const utils_1 = require("../utils/utils");
const firebase_functions_1 = require("firebase-functions");
/**
 * Sets or updates a user's role.
 * @param data Contains the uid of the user and the new role to assign.
 * @param context Provides context about this function call, including authentication.
 */
exports.setUserRole = functions.region("europe-west1").https.onCall(async (data, context) => {
    var _a;
    firebase_functions_1.logger.info("Received data:", data);
    firebase_functions_1.logger.info("Setting user role");
    // log idToken
    firebase_functions_1.logger.info("idToken:", (_a = context.auth) === null || _a === void 0 ? void 0 : _a.token);
    // Check if the request is authenticated
    (0, utils_1.checkAuth)(context);
    // Ensure the caller has admin privileges to assign roles
    // checkRole(context, ["admin"]);
    const { uid, role } = data;
    if (!role) {
        throw new functions.https.HttpsError("invalid-argument", "The function must be called with a role.");
    }
    try {
        // Set custom user claims on the user identified by uid
        await admin.auth().setCustomUserClaims(uid, { role });
        return { uid, role, message: `Role ${role} assigned to user ${uid}` };
    }
    catch (error) {
        throw new functions.https.HttpsError("internal", error.message);
    }
});

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
exports.mapUser = exports.checkRole = exports.checkAuth = void 0;
const admin = __importStar(require("firebase-admin"));
const functions = __importStar(require("firebase-functions"));
const firebase_functions_1 = require("firebase-functions");
admin.initializeApp();
const checkAuth = (context) => {
    firebase_functions_1.logger.info("Checking authentication...");
    if (!context.auth) {
        console.log("Authentication failed.");
        throw new functions.https.HttpsError("unauthenticated", "The function must be called while authenticated.");
    }
    firebase_functions_1.logger.info("Authentication successful.");
};
exports.checkAuth = checkAuth;
const checkRole = (context, roles) => {
    var _a;
    const role = (_a = context.auth) === null || _a === void 0 ? void 0 : _a.token.role;
    if (!roles.includes(role)) {
        throw new functions.https.HttpsError("permission-denied", "The function must be called by an authorized user.");
    }
};
exports.checkRole = checkRole;
const mapUser = (user) => {
    var _a;
    return ({
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        role: (_a = user.customClaims) === null || _a === void 0 ? void 0 : _a.role,
        lastSignInTime: user.metadata.lastSignInTime,
        creationTime: user.metadata.creationTime,
        photoURL: user.photoURL,
    });
};
exports.mapUser = mapUser;

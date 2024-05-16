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
exports.uploadUserPhotoToBucket = void 0;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
const utils_1 = require("../utils/utils");
exports.uploadUserPhotoToBucket = functions.region("europe-west1").https.onCall(async (data, context) => {
    // Check if the caller is authenticated and authorized
    (0, utils_1.checkAuth)(context);
    (0, utils_1.checkRole)(context, ["admin", "manager"]);
    // Allowed file extensions for profile image
    const allowedExtensions = ["png", "jpg", "jpeg", "JPG", "JPEG", "PNG"];
    const { uid, imageData, filename } = data;
    // Check image data is not null
    if (!imageData) {
        throw new functions.https.HttpsError("failed-precondition", "Missing required image");
    }
    // Check if file is of allowed type
    if (!allowedExtensions.includes(filename.split(".").pop())) {
        throw new functions.https.HttpsError("invalid-argument", "Image file type is not jpg or png");
    }
    try {
        // Specify the path in the bucket
        const bucket = admin.storage().bucket("captainapp-crew-2024.appspot.com"); // Replace YOUR_BUCKET_URL with your actual bucket URL
        const filePath = `profileImages/${uid}/${filename}`; // You can dynamically set the extension based on your needs
        const file = bucket.file(filePath);
        // Adjust contentType based on actual image type
        let contentType = filename.split(".").pop();
        if (contentType == "jpg" || contentType == "JPG" || contentType == "JPEG")
            contentType = "jpeg";
        // Upload the image to Firebase Cloud Storage
        await file.save(Buffer.from(imageData, "base64"), {
            metadata: {
                contentType: `image/${contentType}`,
            },
        });
        return { downloadURL: "/" + filePath };
    }
    catch (error) {
        throw new functions.https.HttpsError("internal", error.message);
    }
});

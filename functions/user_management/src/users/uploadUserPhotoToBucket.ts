import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {checkAuth, checkRole} from "../utils/utils";

export const uploadUserPhotoToBucket = functions.region("europe-west1").https.onCall(async (data, context) => {
  // Check if the caller is authenticated and authorized
  checkAuth(context);
  checkRole(context, ["admin", "manager"]);

  // Allowed file extensions for profile image
  const allowedExtensions = ["png", "jpg", "jpeg", "JPG", "JPEG", "PNG"];

  const {uid, imageData, filename} = data;

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
    if (contentType == "jpg" || contentType == "JPG" || contentType == "JPEG") contentType = "jpeg";

    // Upload the image to Firebase Cloud Storage
    await file.save(Buffer.from(imageData, "base64"), {
      metadata: {
        contentType: `image/${contentType}`,
      },
    });

    return {downloadURL: "/" + filePath};
  } catch (error: any) {
    throw new functions.https.HttpsError("internal", error.message);
  }
});

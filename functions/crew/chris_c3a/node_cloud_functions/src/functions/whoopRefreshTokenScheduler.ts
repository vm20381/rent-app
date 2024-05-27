import * as functions from "firebase-functions";
import admin from "firebase-admin";
import fetch, {Response} from "node-fetch";


if (admin.apps.length === 0) {
  admin.initializeApp();
}

interface TokenResponse {
  access_token: string;
  refresh_token: string;
}

const clientId = functions.config().whoopapi.client_id;
const clientSecret = functions.config().whoopapi.client_secret;
const tokenUrl = "https://api.prod.whoop.com/oauth/oauth2/token";

// run every 30 minutes to fetch a new access token
export const whoopRefreshTokenScheduler = functions.pubsub.schedule("every 30 minutes").onRun(async (context) => {
  const refreshToken: string | undefined = await getStoredRefreshToken();

  const response: Response = await fetch(tokenUrl, {
    method: "POST",
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: new URLSearchParams({
      grant_type: "refresh_token",
      refresh_token: refreshToken ?? "",
      client_id: clientId,
      client_secret: clientSecret,
    }),
  });

  if (!response.ok) {
    console.error("Failed to refresh token:", response.statusText);
    return;
  }

  const responseData = await response.json();

  // extract the access token and refresh token from the response
  const newTokens: TokenResponse = {
    access_token: responseData.access_token,
    refresh_token: responseData.refresh_token,
  };

  console.log("New tokens:", newTokens);
  await storeNewTokens(newTokens);
});

/**
 * Retrieves the stored refresh token from Firestore.
 * @returns {Promise<string | undefined>} The refresh token.
 */
async function getStoredRefreshToken(): Promise<string | undefined> {
  const snapshot = await admin.firestore().collection("whoop_tokens").limit(1).get();
  const doc = snapshot.docs[0]; // Get the first document in the collection
  return doc.data()?.refresh_token;
}

/**
 * Stores the new tokens in Firestore.
 * @param {TokenResponse} tokens - The new tokens to be stored.
 */
async function storeNewTokens(tokens: TokenResponse): Promise<void> {
  const snapshot = await admin.firestore().collection("whoop_tokens").get();
  if (snapshot.empty) {
    console.log("No documents found. Creating a new document.");
    await admin.firestore().collection("whoop_tokens").add(tokens);
  } else {
    const firstDocId = snapshot.docs[0].id;
    await admin.firestore().collection("whoop_tokens").doc(firstDocId).set(tokens);
  }
}

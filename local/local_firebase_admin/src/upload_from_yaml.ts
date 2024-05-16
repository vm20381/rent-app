import * as fs from "fs";
import * as yaml from "js-yaml";
import * as admin from "firebase-admin";
import { Storage } from "@google-cloud/storage";
import * as QRCode from "qrcode";

// import serviceAccount from "../src/admin_key.json";

/**
 * Authenticates Firestore using the provided key file.
 * @param {string} keyFile - The path to the key file.
 * @returns {object} - The authenticated Firestore instance.
 */
async function authenticateFirestore(keyFile = "../src/admin_key.json") {
    const adminServiceAccount = await import(keyFile);
    admin.initializeApp({
        credential: admin.credential.cert(adminServiceAccount),
    });
    const Firestore = admin.firestore();
    return Firestore;
}

/**
 * Authenticates Google Cloud Storage using the provided project ID and key file.
 * @param {string} projectID - The ID of the Google Cloud project.
 * @param {string} keyFile - The path to the key file.
 * @returns {Storage} - The authenticated Google Cloud Storage instance.
 */
function authenticateGCS(
    projectID = "captainapp-crew-2024",
    keyFile = "src/keys.json"
) {
    const storage = new Storage({
        projectId: projectID,
        keyFilename: keyFile,
    });
    return storage;
}

/**
 * Generates a QR code for the given document ID, collection path, and base path.
 * @param {string} documentID - The ID of the document.
 * @param {string} collectionPath - The path of the collection.
 * @param {string} basePath - The base path for the QR code URL.
 * @returns {Promise<string>} - The generated QR code data.
 */
async function generateQRCode(
    documentID: string,
    collectionPath: string,
    basePath: string
): Promise<string> {
    let qrCodeData = "";
    const qrCodeUrl = basePath + "/" + collectionPath + "/" + documentID;
    QRCode.toString(
        qrCodeUrl,
        { type: "svg" },
        function (err: unknown, url: string) {
            // Explicitly type 'url' as string
            qrCodeData = url;
            if (err) throw err;
        }
    );
    return qrCodeData;
}

/**
 * Saves the SVG data to Google Cloud Storage.
 * @param {string} svgData - The SVG data to be saved.
 * @param {string} bucketName - The name of the bucket.
 * @param {string} destFileName - The destination file name.
 * @param {any} storage - The Google Cloud Storage instance.
 * @returns {Promise<void>} - A promise that resolves when the SVG data has been saved.
 * @throws {Error} - An error is thrown if the SVG data cannot be saved.
 * */
async function saveSVGtoGCS(
    svgData: string,
    bucketName: string,
    destFileName: string,
    storage: Storage
) {
    const bucket = storage.bucket(bucketName);
    const file = bucket.file(destFileName);

    try {
        await file.save(svgData, {
            metadata: {
                contentType: "image/svg+xml",
            },
        });
        console.log(`Uploaded to ${destFileName}`);
    } catch (error) {
        console.error("Error uploading SVG:", error);
    }
}

// Define a type for the structure where assets is an array of objects with any properties.
interface YamlData {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    assets: Record<string, any>[];
}

/**
 * Parses a YAML file and returns the parsed data as JSON.
 * @param {string} yamlFilePath - The path to the YAML file.
 * @returns {YamlData} - The parsed YAML data as JSON.
 */
function parseYamlFile(yamlFilePath: string): YamlData {
    const yamlData = fs.readFileSync(yamlFilePath, "utf8");
    const jsonData = yaml.load(yamlData) as YamlData;
    return jsonData;
}

/**
 * Reads YAML file and writes its contents to Firestore, calling qrcode creation logic.
 * @param {any} jsonData - The JSON data to be written to Firestore.
 * @param {string} collectionName - The name of the collection in Firestore.
 * @returns {Promise<void>} - A promise that resolves when the data has been written to Firestore.
 */
async function writeToFirestore(jsonData: any, collectionName = "entities") {
    try {
        const firestore = await authenticateFirestore();
        const collectionRef = firestore.collection(collectionName);

        // Write data to Firestore
        await Promise.all(
            jsonData.assets.map(async (asset: any) => {
                // Generate a random unique ID for each document
                const docRef = collectionRef.doc();
                await docRef.set(asset);
                console.log("Document written with ID: ", docRef.id);
                const svgData = await generateQRCode(
                    docRef.id,
                    collectionName,
                    "https://captainapp-crew-2024.web.app"
                );
                saveSVGtoGCS(
                    svgData,
                    "captainapp-crew-2024.appspot.com",
                    `qrcodes/${docRef.id}.svg`,
                    authenticateGCS()
                );
            })
        );

        console.log("Data has been successfully written to Firestore.");
    } catch (error) {
        console.error("Error writing to Firestore:", error);
    }
}

// DON'T USE GLOBALS
// const firestore = authenticateFirestore();
// const storage = authenticateGCS();

// Bad bucket name:
// "captainapp-crew-2024.appspot.com";

const jsonData = parseYamlFile(
    "package:crew_example/data/example_entities.yaml"
);
writeToFirestore(jsonData);

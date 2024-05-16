"use strict";
var __createBinding =
    (this && this.__createBinding) ||
    (Object.create
        ? function (o, m, k, k2) {
              if (k2 === undefined) k2 = k;
              var desc = Object.getOwnPropertyDescriptor(m, k);
              if (
                  !desc ||
                  ("get" in desc
                      ? !m.__esModule
                      : desc.writable || desc.configurable)
              ) {
                  desc = {
                      enumerable: true,
                      get: function () {
                          return m[k];
                      },
                  };
              }
              Object.defineProperty(o, k2, desc);
          }
        : function (o, m, k, k2) {
              if (k2 === undefined) k2 = k;
              o[k2] = m[k];
          });
var __setModuleDefault =
    (this && this.__setModuleDefault) ||
    (Object.create
        ? function (o, v) {
              Object.defineProperty(o, "default", {
                  enumerable: true,
                  value: v,
              });
          }
        : function (o, v) {
              o["default"] = v;
          });
var __importStar =
    (this && this.__importStar) ||
    function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null)
            for (var k in mod)
                if (
                    k !== "default" &&
                    Object.prototype.hasOwnProperty.call(mod, k)
                )
                    __createBinding(result, mod, k);
        __setModuleDefault(result, mod);
        return result;
    };
Object.defineProperty(exports, "__esModule", { value: true });
const fs = __importStar(require("fs"));
const yaml = __importStar(require("js-yaml"));
const admin = __importStar(require("firebase-admin"));
const storage_1 = require("@google-cloud/storage");
const QRCode = __importStar(require("qrcode"));
// import serviceAccount from "../src/admin_key.json";
/**
 * Authenticates Firestore using the provided key file.
 * @param {string} keyFile - The path to the key file.
 * @returns {object} - The authenticated Firestore instance.
 */
async function authenticateFirestore(keyFile = "../src/admin_key.json") {
    const adminServiceAccount = await Promise.resolve(`${keyFile}`).then((s) =>
        __importStar(require(s))
    );
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
    const storage = new storage_1.Storage({
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
async function generateQRCode(documentID, collectionPath, basePath) {
    let qrCodeData = "";
    const qrCodeUrl = basePath + "/" + collectionPath + "/" + documentID;
    QRCode.toString(qrCodeUrl, { type: "svg" }, function (err, url) {
        qrCodeData = url;
        if (err) throw err;
    });
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
async function saveSVGtoGCS(svgData, bucketName, destFileName, storage) {
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
/**
 * Parses a YAML file and returns the parsed data as JSON.
 * @param {string} yamlFilePath - The path to the YAML file.
 * @returns {YamlData} - The parsed YAML data as JSON.
 */
function parseYamlFile(yamlFilePath) {
    const yamlData = fs.readFileSync(yamlFilePath, "utf8");
    const jsonData = yaml.load(yamlData);
    return jsonData;
}
/**
 * Reads YAML file and writes its contents to Firestore, calling qrcode creation logic.
 * @param {any} jsonData - The JSON data to be written to Firestore.
 * @param {string} collectionName - The name of the collection in Firestore.
 * @returns {Promise<void>} - A promise that resolves when the data has been written to Firestore.
 */
async function writeToFirestore(jsonData, collectionName = "entities") {
    try {
        const firestore = await authenticateFirestore();
        const collectionRef = firestore.collection(collectionName);
        // Write data to Firestore
        await Promise.all(
            jsonData.assets.map(async (asset) => {
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

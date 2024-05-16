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
exports.remove = exports.patch = exports.get = exports.all = exports.create = void 0;
const admin = __importStar(require("firebase-admin"));
/**
 * Creates a new user.
 *
 * @param {Request} req - The request object.
 * @param {Response} res - The response object.
 * @return {Promise<void>} - A promise that resolves when the user is created.
 */
async function create(req, res) {
    try {
        const { displayName, password, email, role } = req.body;
        if (!displayName || !password || !email || !role) {
            return res.status(400).send({ message: "Missing fields" });
        }
        const { uid } = await admin.auth().createUser({
            displayName,
            password,
            email,
        });
        await admin.auth().setCustomUserClaims(uid, { role });
        return res.status(201).send({ uid });
    }
    catch (err) {
        return handleError(res, err);
    }
}
exports.create = create;
/**
 * Retrieves all users.
 *
 * @param req - The request object.
 * @param res - The response object.
 * @return A response with the list of users.
 */
async function all(req, res) {
    try {
        const listUsers = await admin.auth().listUsers();
        const users = listUsers.users.map(mapUser);
        return res.status(200).send({ users });
    }
    catch (err) {
        return handleError(res, err);
    }
}
exports.all = all;
/**
 * Maps a user record from the Firebase Admin SDK to a simplified user object.
 * @param user - The user record obtained from the Firebase Admin SDK.
 * @return The simplified user object with selected properties.
 */
function mapUser(user) {
    const customClaims = (user.customClaims || { role: "" });
    const role = customClaims.role ? customClaims.role : "";
    return {
        uid: user.uid,
        email: user.email || "",
        displayName: user.displayName || "",
        role,
        lastSignInTime: user.metadata.lastSignInTime,
        creationTime: user.metadata.creationTime,
    };
}
/**
 * Retrieves a user by ID.
 *
 * @param req - The request object.
 * @param res - The response object.
 * @return A Promise that resolves to the user data.
 */
async function get(req, res) {
    try {
        const { id } = req.params;
        const user = await admin.auth().getUser(id);
        return res.status(200).send({ user: mapUser(user) });
    }
    catch (err) {
        return handleError(res, err);
    }
}
exports.get = get;
/**
 * Updates a user's information.
 * @param {Request} req - The request object.
 * @param {Response} res - The response object.
 * @return {Promise<void>} - A promise that resolves when the user's information is updated.
 */
async function patch(req, res) {
    try {
        const { id } = req.params;
        const { displayName, password, email, role } = req.body;
        if (!id || !displayName || !password || !email || !role) {
            return res.status(400).send({ message: "Missing fields" });
        }
        await admin.auth().updateUser(id, { displayName, password, email });
        await admin.auth().setCustomUserClaims(id, { role });
        const user = await admin.auth().getUser(id);
        return res.status(204).send({ user: mapUser(user) });
    }
    catch (err) {
        return handleError(res, err);
    }
}
exports.patch = patch;
/**
 * Removes a user.
 * @param req - The request object.
 * @param res - The response object.
 * @return A response with status 204 if the user is successfully removed.
 */
async function remove(req, res) {
    try {
        const { id } = req.params;
        await admin.auth().deleteUser(id);
        return res.status(204).send({});
    }
    catch (err) {
        return handleError(res, err);
    }
}
exports.remove = remove;
/**
 * Handles errors by sending an error response with the provided error details.
 * @param res - The response object to send the error response.
 * @param err - The error object containing the error code and message.
 * @return The response object with the error status and message.
 */
function handleError(res, err) {
    return res.status(500).send({ message: `${err.code} - ${err.message}` });
}

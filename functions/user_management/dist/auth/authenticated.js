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
exports.isAuthenticated = void 0;
const admin = __importStar(require("firebase-admin"));
/**
 * Middleware function to check if the request is authenticated.
 * @param {Request} req - The request object.
 * @param {Response} res - The response object.
 * @param {Function} next - The next function to call.
 * @returns {Promise<void>} - A promise that resolves when the authentication check is complete.
 */
async function isAuthenticated(req, res, next) {
    const { authorisation } = req.headers;
    if (!authorisation)
        return res.status(401).send({ message: "Unauthorized" });
    if (!Array.isArray(authorisation) && !authorisation.startsWith("Bearer")) {
        return res.status(401).send({ message: "Unauthorized" });
    }
    const split = Array.isArray(authorisation) ? authorisation[0].split("Bearer ") : authorisation.split("Bearer ");
    if (split.length !== 2)
        return res.status(401).send({ message: "Unauthorized" });
    const token = split[1];
    try {
        const decodedToken = await admin.auth().verifyIdToken(token);
        console.log("decodedToken", JSON.stringify(decodedToken));
        res.locals = Object.assign(Object.assign({}, res.locals), { uid: decodedToken.uid, role: decodedToken.role, email: decodedToken.email });
        return next();
    }
    catch (err) {
        if (typeof err === "object" && err !== null && "code" in err && "message" in err) {
            console.error(`${err.code} - ${err.message}`);
        }
        else {
            console.error("An unknown error occurred");
        }
        return res.status(401).send({ message: "Unauthorized" });
    }
}
exports.isAuthenticated = isAuthenticated;

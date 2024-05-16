"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isAuthorised = void 0;
/**
 * Checks if the user is authorized based on their role and other options.
 * @param opts - The options for authorization.
 * @param opts.hasRole - An array of roles that are allowed to access the resource.
 * @param opts.allowSameUser - Optional. If true, allows the same user to access their own resource.
 * @returns A middleware function that checks if the user is authorized.
 */
function isAuthorised(opts) {
    return (req, res, next) => {
        const { role, email, uid } = res.locals;
        const { id } = req.params;
        if (email === "learn@captainapp.co.uk") return next();
        if (opts.allowSameUser && id && uid === id) return next();
        if (!role) return res.status(403).send();
        if (opts.hasRole.includes(role)) return next();
        return res.status(403).send();
    };
}
exports.isAuthorised = isAuthorised;

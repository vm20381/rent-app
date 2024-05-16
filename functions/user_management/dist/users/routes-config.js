"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.routesConfig = void 0;
const controller_1 = require("./controller");
const authenticated_1 = require("../auth/authenticated");
const authorised_1 = require("../auth/authorised");
/**
 * Configures the routes for user-related operations.
 * @param {Application} app - The Express application object.
 */
function routesConfig(app) {
    // creates a new user
    app.post("/users", authenticated_1.isAuthenticated, (0, authorised_1.isAuthorised)({ hasRole: ["admin", "manager"] }), controller_1.create);
    // lists all users
    app.get("/users", [authenticated_1.isAuthenticated, (0, authorised_1.isAuthorised)({ hasRole: ["admin", "manager"] }), controller_1.all]);
    // get :id user
    app.get("/users/:id", [authenticated_1.isAuthenticated, (0, authorised_1.isAuthorised)({ hasRole: ["admin", "manager"], allowSameUser: true }), controller_1.get]);
    // updates :id user
    app.patch("/users/:id", [
        authenticated_1.isAuthenticated,
        (0, authorised_1.isAuthorised)({ hasRole: ["admin", "manager"], allowSameUser: true }),
        controller_1.patch,
    ]);
    // deletes :id user
    app.delete("/users/:id", [authenticated_1.isAuthenticated, (0, authorised_1.isAuthorised)({ hasRole: ["admin", "manager"] }), controller_1.remove]);
}
exports.routesConfig = routesConfig;

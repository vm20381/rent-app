# Firebase Functions - Node.js

This folder contains an example set of cloud functions for the Crew Firebase project, written in Node.js. Follow the steps below to set up the functions, create and manage your environment, and deploy your functions to Firebase.

## Prerequisites

Before you begin, ensure you have the following installed:

- [node](https://nodejs.org/en/download/) we recommend installing via nvm. Use node 18.12.1 for this project.
- [pnpm](https://pnpm.io/installation) we recommend installing via npm i -g pnpm or via homebrew if on mac.
- [Firebase CLI](https://firebase.google.com/docs/cli#install_the_firebase_cli) we recommend installing via node, preferably via pnpm. i.e. pnpm install -g firebase-tools

### Explanation of nvm and pnpm:

- **nvm (Node Version Manager)**: A tool that allows you to install multiple versions of Node.js on your machine and switch between them easily. This is useful because different projects may require different versions of Node.js.
- **pnpm**: An npm package manager alternative that is faster and more efficient than npm for your machine because it shares dependencies between projects.

## Setup

1. **Clone the repository**

    ```bash
    git clone https://github.com/Captain-App/captain-app-crew.git
    cd functions/examples/node_cloud_functions
    ```

2. **Use nvm to install Node.js**

    Install and use the required Node.js version:

    ```bash
    nvm install 18.12.1
    nvm use 18.12.1
    ```

3. **Install dependencies**

    With the correct Node.js version active, install the required packages:

    ```bash
    pnpm install
    ```

## Project Structure

The `functions` folder contains the following structure:

```
nodejs_cloud_functions/
├── index.js
├── package.json
├── .env (optional)
├── node_modules/
└── README.md
```

- `index.js`: Entry point for your cloud functions.
- `package.json`: File listing all the dependencies and scripts for your project.
- `.env`: Environment variables file (add to `.gitignore` if it contains sensitive information).
- `node_modules/`: Directory for installed Node.js packages (should be added to `.gitignore`).

## Deploying Functions

1. **Login to Firebase**

    ```bash
    firebase login
    ```

    Sign in as learn@captainapp.co.uk

2. **Deploy the functions**

    Deploy your functions to Firebase:

    ```bash
    firebase deploy --only functions:node-example
    ```

## Troubleshooting

```bash
Error: HTTP Error: 400, <?xml version='1.0' encoding='UTF-8'?><Error><Code>EntityTooLarge</Code><Message>Your proposed upload is larger than the maximum object size specified in your Policy Document.</Message><Details>Content-length exceeds upper bound on range</Details></Error>
```

you may find the package size is too big for firebase to deploy. If this is the case, you can try (or deploy each set of functions one at a time):



```bash
pnpm prune --production
```

## Testing Functions Locally

For more information, see the [Firebase documentation on local emulation](https://firebase.google.com/docs/functions/local-emulator).

## Managing Dependencies

To add new dependencies, use `pnpm` to install the package and then update `package.json`:

```bash
pnpm add <package-name>
```

## Environment Variables

Store environment variables in a `.env` file. Use the `dotenv` package to load these variables into your functions. Install it via pnpm if not already installed:

```bash
pnpm add dotenv
```

Then, load the environment variables in your `index.js`:

```javascript
import dotenv from "dotenv";
dotenv.config();

const apiKey = process.env.API_KEY;
```

Make sure to add the `.env` file to your `.gitignore` to prevent sensitive information from being committed to the repository.

Another note; you only need to import and call the `dotenv` package once in the index file. It will automatically load the environment variables from the `.env` file which can be accessed via `process.env` in any of your functions.
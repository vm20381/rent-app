# Firebase Cloud Functions

This folder contains the following structure:

```
examples/
├── node_cloud_functions/
│   ├── index.js
│   ├── package.json
│   └── README.md
└── python_cloud_functions/
    ├── main.py
    ├── requirements.txt
    └── README.md
<github-username>/
├── node_cloud_functions/
│   ├── index.js
│   ├── package.json
│   └── README.md
└── python_cloud_functions/
    ├── main.py
    ├── requirements.txt
    └── README.md
```

- `index.js` or `main.py`: Entry point for your cloud functions.
- `package.json` or `requirements.txt`: File listing all the dependencies and scripts for your project.
- `README.md`: Instructions on how to set up/build and deploy your cloud functions.

NB: You will need to be able to build the functions before they can be deployed. 

## Setting up Firebase

If you don't already, we recommend you use pnpm to manage your packages. You can install it with:

    ```bash
    npm install -g pnpm
    ```

(which you may need to install npm first with nvm)
Run:

    ```bash
    pnpm setup
    ```

Install the Firebase CLI:

    ```bash
    pnpm add -g firebase-tools
    ```

Login to Firebase:

    ```bash
    firebase login
    ```

If you need to install typescript:

    ```bash
    pnpm add -g typescript
    ```

## Note from experience

I have come across an error where I could not deploy the functions because the 

```bash
firebase deploy --only functions:user_management
```
Did not work. I had to run tsc, and lint individually before deploying the functions.

```bash 
cd functions/user_management
tsc
npm run lint
npm run build
```

then comment out lines 36-38 in firebase.json, finally run the deploy command.

```bash
firebase deploy --only functions:user_management
```

## Deploying Functions

1. **Login to Firebase**

    ```bash
    firebase login
    ```

    Sign in as learn@captainapp.co.uk

2. **Deploy the functions**
  
      Deploy the example functions to Firebase:
  
      ```bash
      firebase deploy --only functions:example-node,example-python
      ```

      or do them separately:

      ```bash
        firebase deploy --only functions:example-node
        firebase deploy --only functions:example-python
    ```

      Deploy your own functions to Firebase:

      ```bash
      firebase deploy --only functions:<github-username>-node,<github-username>-python
      ```

## Troubleshooting

you may see the error:

```bash
Error: Failed to get Firebase project captainapp-crew-2024. Please make sure the project exists and your account has permission to access it.
```

Just resign to the Firebase CLI with the correct account:

if you are already logged in as learn@captainapp.co.uk:

```bash
firebase login --reauth
```

else:

```bash
firebase logout
firebase login
```

Seeing logs:

```bash
firebase functions:log
```
Or, much easier; view them online in the Firebase console.

[firbase console](https://console.firebase.google.com/)

[functions](https://console.firebase.google.com/project/captainapp-crew-2024/functions)

[logs explorer](https://console.cloud.google.com/logs/)



## Other functions

You may find there are a few other folders in this directory that contain cloud functions for different use cases. Feel free to explore them and deploy them to Firebase.

example: functions/user_management

These functions are used to manage users in Firebase Authentication. They include functions to create, update, and delete users and are used by the Crew Dashboard to manage users.
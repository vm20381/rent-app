# Firebase Functions - Python

This folder contains an example set of cloud functions for the Crew Firebase project, written in Python. Follow the steps below to set up the functions, create and manage a virtual environment, and deploy your functions to Firebase.

## Prerequisites

Before you begin, ensure you have the following installed:

- [miniconda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html) if you are using a mac we recommend installing via homebrew.
- [node](https://nodejs.org/en/download/) we recommend installing via nvm. Use node 18.12.1 for this project.
- [pnpm](https://pnpm.io/installation) we recommend installing via npm i -g pnpm or via homebrew if on mac.
- [Firebase CLI](https://firebase.google.com/docs/cli#install_the_firebase_cli) we recommend installing via node preferably via pnpm. i.e. pnpm install -g firebase-tools

Quick explanation of miniconda nvm and pnpm:

miniconda is a package manager that allows you to create isolated environments for your python projects, this is useful because different projects may require different versions of python or different packages.

nvm (node version manager) is a tool that allows you to install multiple versions of node on your machine and switch between them easily, this is useful because different projects may require different versions of node.

pnpm is an npm package manager alternative that is faster and more efficient than npm for your machine because it shares dependencies between projects.

## Setup

1. **Clone the repository**

    ```bash
    git clone https://github.com/Captain-App/captain-app-crew.git
    cd functions/examples/python_cloud_functions
    ```

2. **Create conda environment**

    Create a conda environment in the `functions` folder:

    ```bash
    conda create -n captain-app-crew python=3.12
    conda activate captain-app-crew
    ```

    test installation by running `python --version`
    you should see `Python 3.12.3`

3. **Create a virtual environment (from the conda environment)**

    Create a virtual environment in the `functions` folder:

    ```bash
    python -m venv venv
    ```

4. **Activate the virtual environment**

    - **Windows:**

      ```bash
      venv\Scripts\activate
      ```

    - **macOS/Linux:**

      ```bash
      source venv/bin/activate
      ```

      this will activate the virtual environment and you should see `(venv)` in your terminal prompt.

5. **Install dependencies**

    With the virtual environment activated, install the required packages:

    ```bash
    pip install -r requirements.txt
    ```

## Project Structure

The `functions` folder contains the following structure:

```
python_cloud_functions/
├── main.py
├── requirements.txt
├── .env (optional)
├── venv/
└── README.md
```

- `main.py`: Entry point for your cloud functions.
- `requirements.txt`: File listing all the dependencies for your project.
- `.env`: Environment variables file (add to `.gitignore` if it contains sensitive information).
- `venv/`: Virtual environment directory (should be added to `.gitignore`).


## Deploying Functions

1. **Login to Firebase**

    ```bash
    firebase login
    ```

    Sign in as learn@captainapp.co.uk


2. **Deploy the functions**

    Deploy your functions to Firebase:

    ```bash
    firebase deploy --only functions:python-example
    ```

## Testing Functions Locally

see docs for more info: https://firebase.google.com/docs/functions/local-emulator

## Managing Dependencies

To add new dependencies, use `pip` to install the package and then update `requirements.txt`:

```bash
pip install <package-name>
pip freeze > requirements.txt
```

## Environment Variables

Store environment variables in a `.env` file. Use the `python-dotenv` package to load these variables into your functions. Install it via pip if not already installed:

```bash
pip install python-dotenv
```

Then, load the environment variables in your `main.py`:

```python
from dotenv import load_dotenv
import os

load_dotenv()

# Access environment variables
api_key = os.getenv('API_KEY')
```
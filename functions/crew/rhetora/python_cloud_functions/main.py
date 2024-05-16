# import base64
# import firebase_admin
# from firebase_admin import credentials, storage
# import subprocess
# import os
from firebase_functions import https_fn


# if not firebase_admin._apps:
#     # Assuming you are running this in Google Cloud,
#     # where the environment already provides default credentials
#     # If running locally, you would need to specify the path to your service account key file
#     credential = credentials.ApplicationDefault()
#     firebase_admin.initialize_app(credential, {"storageBucket": "captainapp-crew-2024"})

# Firebase bucket name
# bucket_name = f"captainapp-crew-2024.appspot.com"

# req format for file name: docID/docType/docName.pdf

@https_fn.on_call(region="europe-west1")
def hello_python(req: https_fn.Request) -> https_fn.Response:
    # Check if the req method is GET
    if req.method != "GET":
        return "This endpoint supports only GET requests.", 405
    
    # respond hello world
    return "Hello, world!", 200

    
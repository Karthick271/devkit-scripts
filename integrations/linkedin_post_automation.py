import requests
import json
import os

# ===================== CONFIG =====================
ACCESS_TOKEN = "AQWrm8vGPLZtO_gdfdfe8UeGJH0hbupJXdhXKl6LMdf1k_n6xV38hoky_1VTSRpIEmZdfdHrJbYNRfCdfdf-18X_59v"  # Replace with your actual access token
ORGANIZATION_URN = "urn:li:organization:106232344sds344326ewew" # Replace with your actual organization URN
IMAGE_PATH = "/home/karthick/Pictures/S1-3-fav.jpg"  # Change this to your image path
POST_TEXT = "Hello from  Me! 🚀" 
IMAGE_TITLE = "Karthick Rocks!" # Change this to your desired image title
IMAGE_DESCRIPTION = "Awesome image uploaded via API"

# ===================== HEADERS =====================
auth_headers = {
    "Authorization": f"Bearer {ACCESS_TOKEN}",
    "Content-Type": "application/json"
}

# ===================== STEP 1: REGISTER UPLOAD =====================
def register_image_upload():
    url = "https://api.linkedin.com/v2/assets?action=registerUpload"
    payload = {
        "registerUploadRequest": {
            "owner": ORGANIZATION_URN,
            "recipes": ["urn:li:digitalmediaRecipe:feedshare-image"],
            "serviceRelationships": [{
                "identifier": "urn:li:userGeneratedContent",
                "relationshipType": "OWNER"
            }]
        }
    }

    response = requests.post(url, headers=auth_headers, json=payload)
    if response.status_code != 200:
        raise Exception("Error in registerUpload:", response.text)

    data = response.json()
    upload_url = data["value"]["uploadMechanism"]["com.linkedin.digitalmedia.uploading.MediaUploadHttpRequest"]["uploadUrl"]
    asset_urn = data["value"]["asset"]
    return upload_url, asset_urn

# ===================== STEP 2: UPLOAD IMAGE =====================
def upload_image(upload_url):
    with open(IMAGE_PATH, 'rb') as image_file:
        upload_headers = {
            "Authorization": f"Bearer {ACCESS_TOKEN}",
            "Content-Type": "image/jpeg"
        }
        response = requests.put(upload_url, data=image_file, headers=upload_headers)
        if response.status_code not in [200, 201]:
            raise Exception("Error uploading image:", response.text)
        print("✅ Image uploaded successfully.")

# ===================== STEP 3: CREATE POST =====================
def create_image_post(asset_urn):
    url = "https://api.linkedin.com/v2/ugcPosts"
    payload = {
        "author": ORGANIZATION_URN,
        "lifecycleState": "PUBLISHED",
        "specificContent": {
            "com.linkedin.ugc.ShareContent": {
                "shareCommentary": {
                    "text": POST_TEXT
                },
                "shareMediaCategory": "IMAGE",
                "media": [{
                    "status": "READY",
                    "description": {"text": IMAGE_DESCRIPTION},
                    "media": asset_urn,
                    "title": {"text": IMAGE_TITLE}
                }]
            }
        },
        "visibility": {
            "com.linkedin.ugc.MemberNetworkVisibility": "PUBLIC"
        }
    }

    response = requests.post(url, headers=auth_headers, json=payload)
    if response.status_code != 201:
        raise Exception("Error creating post:", response.text)

    print("✅ Post created successfully.")
    print("Post ID:", response.json().get("id"))

# ===================== EXECUTION FLOW =====================
if __name__ == "__main__":
    print("🔄 Registering upload...")
    upload_url, asset_urn = register_image_upload()

    print("⬆️ Uploading image...")
    upload_image(upload_url)

    print("📝 Creating post...")
    create_image_post(asset_urn)

import requests
import json
import numpy as np
from PIL import Image
import urllib.request
from jaseci.actions.live_actions import jaseci_action  # step 1

with open('credentials.json', 'r') as file:
    data = json.load(file)
id = data["id"] 
auth = data["token"]

@jaseci_action(act_group=["I"], allow_remote=True)

def get_audio(audio_id, file_name):
    headers = {
        "Authorization": auth,
        "Content-Type": "application/json"
    }
    url = "https://graph.facebook.com/v15.0/"+audio_id+"?phone_number_id="+id
    response = requests.get(url, headers=headers)
    print(response.json())
    data = response.json()
    audio_url = data["url"]
    response = requests.get(audio_url, headers=headers)
    with open(file_name, 'wb') as f:
        f.write(response.content)

@jaseci_action(act_group=["I"], allow_remote=True)

def get_image(image_id, file_name):
    headers = {
        "Authorization": auth,
        "Content-Type": "application/json"
    }
    url = "https://graph.facebook.com/v15.0/"+image_id+"?phone_number_id="+id
    response = requests.get(url, headers=headers)
    print(response.json())
    data = response.json()
    audio_url = data["url"]
    response = requests.get(audio_url, headers=headers)
    with open(file_name, 'wb') as f:
        f.write(response.content)

@jaseci_action(act_group=["I"], allow_remote=True)

def get_video(video_id, file_name):
    headers = {
        "Authorization": auth,
        "Content-Type": "application/json"
    }
    url = "https://graph.facebook.com/v15.0/"+video_id+"?phone_number_id="+id
    response = requests.get(url, headers=headers)
    print(response.json())
    data = response.json()
    audio_url = data["url"]
    response = requests.get(audio_url, headers=headers)
    with open(file_name, 'wb') as f:
        f.write(response.content)

@jaseci_action(act_group=["send"], allow_remote=True)

def case_report(description, lat, lon, title):
    if not lat:
       lat = 0
    if not lon:
        lon = 0
    url = "http://52.72.153.254:8050/api/v1/cases"
    headers = {
        "accept": "application/json"
    }
    data = {
        "title": title,
        "description": description,
        "lat": lat,
        "lon": lon,
        "suggested_action": "Arrest them",
        "phone_number": "+5926099511",
    }

    with open('image.jpg', 'rb') as f:
        files = {'attachments[0]': f.read()}
    response = requests.post(url, data=data, headers=headers, files=files)
    print(response.json())
    return response
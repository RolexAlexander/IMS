import requests
import urllib.request
from jaseci.actions.live_actions import jaseci_action  # step 1

@jaseci_action(act_group=["I"], allow_remote=True)

def get_audio(audio_id, file_name):
    headers = {
        "Authorization": "Bearer EAANXymhwFzEBANzqVG7lTLZAFKzH3wPrRpyxDZCnsgzohfacwPfpNg0sjZCAUAqWmQy6ZAZA4q9ZCMlvPKOaniTgTp9HNbZBqwuWy2qIxdXmRU8jCX0xIIukZBSH5yjO3MoyLWiBbxAL6ZCoLhtQt5hrWMH2ZC2fKUqIrR5UmWVdJrt2eWOBBHCCj1jBQ5udPDyRq0ZAJSGGmBoZCgZDZD",
        "Content-Type": "application/json"
    }
    url = "https://graph.facebook.com/v15.0/"+audio_id+"?phone_number_id=114616771548131"
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
        "Authorization": "Bearer EAANXymhwFzEBANzqVG7lTLZAFKzH3wPrRpyxDZCnsgzohfacwPfpNg0sjZCAUAqWmQy6ZAZA4q9ZCMlvPKOaniTgTp9HNbZBqwuWy2qIxdXmRU8jCX0xIIukZBSH5yjO3MoyLWiBbxAL6ZCoLhtQt5hrWMH2ZC2fKUqIrR5UmWVdJrt2eWOBBHCCj1jBQ5udPDyRq0ZAJSGGmBoZCgZDZD",
        "Content-Type": "application/json"
    }
    url = "https://graph.facebook.com/v15.0/"+image_id+"?phone_number_id=114616771548131"
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
        "Authorization": "Bearer EAANXymhwFzEBANzqVG7lTLZAFKzH3wPrRpyxDZCnsgzohfacwPfpNg0sjZCAUAqWmQy6ZAZA4q9ZCMlvPKOaniTgTp9HNbZBqwuWy2qIxdXmRU8jCX0xIIukZBSH5yjO3MoyLWiBbxAL6ZCoLhtQt5hrWMH2ZC2fKUqIrR5UmWVdJrt2eWOBBHCCj1jBQ5udPDyRq0ZAJSGGmBoZCgZDZD",
        "Content-Type": "application/json"
    }
    url = "https://graph.facebook.com/v15.0/"+video_id+"?phone_number_id=114616771548131"
    response = requests.get(url, headers=headers)
    print(response.json())
    data = response.json()
    audio_url = data["url"]
    response = requests.get(audio_url, headers=headers)
    with open(file_name, 'wb') as f:
        f.write(response.content)

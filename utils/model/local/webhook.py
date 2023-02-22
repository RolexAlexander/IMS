import requests
import json

def create_walker(url, token):
    url = url+"/js/walker_spawn_create"
    headers = {
        "Authorization": "token "+token,
        "Content-Type": "application/json"
    }
    data = { "name": "sample_walker", "snt":"active:sentinel" }

    response = requests.post(url, headers=headers, data=json.dumps(data))
    print(response.content)

def gen_key(url ,token):
    url = url+"/js/walker_get"
    headers = {
        "Authorization": "token "+token,
        "Content-Type": "application/json"
    }
    data = { "mode": "keys", "wlk": "spawned:walker:sample_walker", "detailed": False }

    response = requests.post(url, headers=headers, data=json.dumps(data))
    print(response.content)

def create_url(url,node,walker,key):
    url = url+"/js_public/walker_callback/"+node+"/"+walker+"?key="+key
    print(url)

def token(token, url):
    url = url
    data = { 
        "token": token 
    }
    response = requests.post(url, headers=None, data=data)
    print(response.content)

def test():
    # url = "https://b9e9ca262865e0c568d7f6f027173e0a.loophole.site/js_public/walker_callback/35729c94-2b95-405f-9617-efdbbf6988ce/f39e4bb4-349c-4830-99ee-eb0b3fbf99f0?key=4f1c9b56a08c1b4cd84d9a830055d33e"

    # response = requests.get(url)
    # print(response.content)
    verify_token = "123"
    challenge = "111111111111111111111111111111111"
    mode = "subscribe"

    url = "https://b51fcfc0bcacf8caa5f65d3011810cfe.loophole.site/js_public/walker_callback/0c9bf7ef-50af-4125-9cbf-08fe1e8a6a39/0f688618-e098-4338-aafb-85711b30e6ec?key=58dd103ce288ce9137fd6bb2677a15b8"
    params = {
        "hub.verify_token": verify_token,
        "hub.challenge": challenge,
        "hub.mode": mode
    }

    response = requests.get(url, params=params)

    print(response.text)

# create_walker("http://localhost:8000", "3368b1d7740e9a3e5892f3c8fd15bbf50ec01305b896855ff052a1bf52ef847f")
# gen_key("http://localhost:8000" ,"3368b1d7740e9a3e5892f3c8fd15bbf50ec01305b896855ff052a1bf52ef847f")
# create_url("https://b51fcfc0bcacf8caa5f65d3011810cfe.loophole.site","0c9bf7ef-50af-4125-9cbf-08fe1e8a6a39","0f688618-e098-4338-aafb-85711b30e6ec","58dd103ce288ce9137fd6bb2677a15b8")
# token("5394a16c11455f2dadd36264ec4a3ca30c476774ee5a321af6711b662ef5915d", "https://b9e9ca262865e0c568d7f6f027173e0a.loophole.site/js_public/walker_callback/f661d2e2-dcc9-4d39-ac2d-e92667f8e819/d1e65f31-3876-45cc-a93c-3bce7bb21030?key=4f1c9b56a08c1b4cd84d9a830055d33e")
test()
# python3 utils/model/local/webhook.py
# https://b51fcfc0bcacf8caa5f65d3011810cfe.loophole.site/js_public/walker_callback/5d7b2cb4-cdd9-459f-b124-72172d62548e/aaf9c220-9abe-4c12-af82-cef83b74f45c?key=58dd103ce288ce9137fd6bb2677a15b8
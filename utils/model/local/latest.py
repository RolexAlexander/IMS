import requests
import json
from jaseci.actions.live_actions import jaseci_action

@jaseci_action(act_group=["latest"], allow_remote=True)

def update():
    url = "http://52.72.153.254:8010/ords/gms/subscription/latest_notification"
    headers = {}
    response = requests.get(url, headers)
    pay_load = response.json()
    print(pay_load)
    return pay_load

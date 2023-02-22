import requests
import json
from jaseci.actions.live_actions import jaseci_action #Module for naming jaseci actions

@jaseci_action(act_group=["O"], allow_remote=True)

def send_message(phone_number, answer, whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "text",
        "text": {
            "preview_url": False,
            "body": answer
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def reply_to_message(phone_number, answer, message_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "context": {
            "message_id": message_id
        },
        "type": "text",
        "text": {
            "preview_url": False,
            "body": answer
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_text_message_with_preview(phone_number, preview_url,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "to": phone_number,
        "text": {
            "preview_url": True,
            "body": preview_url
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_reply_with_reaction(phone_number, message_id, emoji,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "reaction",
        "reaction": {
            "message_id": message_id,
            "emoji": emoji
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_image_message_with_url(phone_number, media_url,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "image",
        "image": {
            "link": media_url
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_reply_image_with_url(phone_number, media_url, message_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "context": {
            "message_id": message_id
        },
        "type": "image",
        "image": {
            "link": media_url
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_image_message_with_id(phone_number, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "image",
        "image": {
            "id": media_id
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_reply_image_with_id(phone_number, media_id, message_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "context": {
            "message_id": message_id
        },
        "type": "image",
        "image": {
            "id": media_id
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_audio_with_id(phone_number, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "audio",
        "audio": {
            "id": media_id
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_reply_audio_with_id(phone_number, media_id, message_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "context": {
            "message_id": message_id
        },
        "type": "audio",
        "audio": {
            "id": media_id
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_audio_with_url(phone_number, media_url,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "audio",
        "audio": {
            "link": media_url
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_reply_audio_with_url(phone_number, media_url, message_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "context": {
            "message_id": message_id
        },
        "type": "audio",
        "audio": {
            "link": media_url
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_document_message_by_id(phone_number, media_id,answer,file_name,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "document",
        "document": {
            "id": media_id,
            "caption": answer,
            "filename": file_name
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_reply_to_document_message_by_id(phone_number, message_id, media_id, answer, file_name,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "context": {
            "message_id": message_id
        },
        "type": "document",
        "document": {
            "id": media_id,
            "caption": answer,
            "filename": file_name
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_document_message_by_url(phone_number, media_url, answer,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "document",
        "document": {
            "link": media_url,
            "caption": answer
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_reply_to_document_message_by_url(phone_number, message_id, file_name, preview_url, user_number, user_message, media_url, media_id, latitude, longitude, location_name, address, template_name,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "context": {
            "message_id": message_id
        },
        "type": "document",
        "document": {
            "link": media_url,
            "caption": user_message
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_sticker_message_by_id(phone_number, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "sticker",
        "sticker": {
            "id": media_id
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_reply_to_sticker_message_by_id(phone_number, message_id, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "context": {
            "message_id": message_id
        },
        "type": "sticker",
        "sticker": {
            "id": media_id
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_sticker_message_by_url(phone_number, media_url, whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "sticker",
        "sticker": {
            "link": media_url
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_reply_to_sticker_message_by_url(phone_number, message_id, media_url,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "context": {
            "message_id": message_id
        },
        "type": "sticker",
        "sticker": {
            "link": media_url
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_video_message_by_id(phone_number, user_message, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "video",
        "video": {
            "caption": user_message,
            "id": media_id
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_reply_to_video_message_by_id(phone_number, message_id, user_message, media_id, whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "context": {
                "message_id": message_id
            },
            "type": "video",
            "video": {
                "caption": user_message,
                "id": media_id
            }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_video_message_by_url(phone_number, user_message, media_url,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "video",
        "video": {
            "caption": user_message,
            "link": media_url
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def Send_reply_to_video_message_by_url(phone_number, message_id, media_url, user_message, whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "context": {
            "message_id": message_id
        },
        "type": "video",
        "video": {
            "caption": user_message,
            "id": media_url
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_contact_message(phone_number, message_id, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "contacts",
        "contacts": [
            {
                "addresses": [
                    {
                        "street": "1 Hacker Way",
                        "city": "Menlo Park",
                        "state": "CA",
                        "zip": "94025",
                        "country": "United States",
                        "country_code": "us",
                        "type": "HOME"
                    },
                    {
                        "street": "200 Jefferson Dr",
                        "city": "Menlo Park",
                        "state": "CA",
                        "zip": "94025",
                        "country": "United States",
                        "country_code": "us",
                        "type": "WORK"
                    }
                ],
                "birthday": "2012-08-18",
                "emails": [
                    {
                        "email": "test@fb.com",
                        "type": "WORK"
                    },
                    {
                        "email": "test@whatsapp.com",
                        "type": "HOME"
                    }
                ],
                "name": {
                    "formatted_name": "John Smith",
                    "first_name": "John",
                    "last_name": "Smith",
                    "middle_name": "D.",
                    "suffix": "Jr",
                    "prefix": "Dr"
                },
                "org": {
                    "company": "WhatsApp",
                    "department": "Design",
                    "title": "Manager"
                },
                "phones": [
                    {
                        "phone": "+1 (940) 555-1234",
                        "type": "HOME"
                    },
                    {
                        "phone": "+1 (650) 555-1234",
                        "type": "WORK",
                        "wa_id": "16505551234"
                    }
                ],
                "urls": [
                    {
                        "url": "https://www.facebook.com",
                        "type": "WORK"
                    },
                    {
                        "url": "https://www.whatsapp.com",
                        "type": "HOME"
                    }
                ]
            }
        ]
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def Send_reply_to_contact_message(phone_number, message_id, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "context": {
            "message_id": message_id
        },
        "type": "contacts",
        "contacts": [
            {
                "addresses": [
                    {
                        "street": "1 Hacker Way",
                        "city": "Menlo Park",
                        "state": "CA",
                        "zip": "94025",
                        "country": "United States",
                        "country_code": "us",
                        "type": "HOME"
                    },
                    {
                        "street": "200 Jefferson Dr",
                        "city": "Menlo Park",
                        "state": "CA",
                        "zip": "94025",
                        "country": "United States",
                        "country_code": "us",
                        "type": "WORK"
                    }
                ],
                "birthday": "2012-08-18",
                "emails": [
                    {
                        "email": "test@fb.com",
                        "type": "WORK"
                    },
                    {
                        "email": "test@whatsapp.com",
                        "type": "HOME"
                    }
                ],
                "name": {
                    "formatted_name": "John Smith",
                    "first_name": "John",
                    "last_name": "Smith",
                    "middle_name": "D.",
                    "suffix": "Jr",
                    "prefix": "Dr"
                },
                "org": {
                    "company": "WhatsApp",
                    "department": "Design",
                    "title": "Manager"
                },
                "phones": [
                    {
                        "phone": "+1 (940) 555-1234",
                        "type": "HOME"
                    },
                    {
                        "phone": "+1 (650) 555-1234",
                        "type": "WORK",
                        "wa_id": "16505551234"
                    }
                ],
                "urls": [
                    {
                        "url": "https://www.facebook.com",
                        "type": "WORK"
                    },
                    {
                        "url": "https://www.whatsapp.com",
                        "type": "HOME"
                    }
                ]
            }
        ]
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_location_messages(phone_number, message_id, latitude, longitude, location_name, address, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "location",
        "location": {
            "latitude": latitude,
            "longitude": longitude,
            "name": location_name,
            "address": address
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_reply_to_location_message(phone_number, message_id, latitude, longitude, location_name, address, whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "context": {
            "message_id": message_id
        },
        "type": "location",
        "location": {
            "latitude": latitude,
            "longitude": longitude,
            "name": location_name,
            "address": address
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_message_template_text(phone_number, message_id, template_name,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "template",
        "template": {
            "name": template_name,
            "language": {
                "code": "en_US"
            }
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_message_list(phone_number, message_id, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "interactive",
        "interactive": {
            "type": "list",
            "header": {
                "type": "text",
                "text": "Gtt Service"
            },
            "body": {
                "text": "They are an array of Gtt services, please select one from below"
            },
            "footer": {
                "text": "Services"
            },
            "action": {
                "button": "Gtt Services",
                "sections": [
                    {
                        "title": "Internet Services",
                        "rows": [
                            {
                                "id": "Blaze",
                                "title": "Blaze",
                                "description": "Fastest Internet in Guyana"
                            },
                            {
                                "id": "Fibre",
                                "title": "Fibre",
                                "description": "Third Fastest Internet in Guyana"
                            }
                        ]
                    },
                    {
                        "title": "Telephone Services",
                        "rows": [
                            {
                                "id": "Landline",
                                "title": "Landline",
                                "description": "Local Calls to friends and Family"
                            },
                            {
                                "id": "Fibre Voice",
                                "title": "Fibre Voice",
                                "description": "Calls to both local and mobile numbers for free."
                            }
                        ]
                    }
                ]
            }
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def Send_reply_to_list_message(phone_number, message_id, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "context": {
            "message_id": message_id
        },
        "type": "interactive",
        "interactive": {
            "type": "list",
            "header": {
                "type": "text",
                "text": "Gtt Service"
            },
            "body": {
                "text": "They are an array of Gtt services, please select one from below"
            },
            "footer": {
                "text": "Services"
            },
            "action": {
                "button": "Gtt Services",
                "sections": [
                    {
                        "title": "Internet Services",
                        "rows": [
                            {
                                "id": "Blaze",
                                "title": "Blaze",
                                "description": "Fastest Internet in Guyana"
                            },
                            {
                                "id": "Fibre",
                                "title": "Fibre",
                                "description": "Third Fastest Internet in Guyana"
                            }
                        ]
                    },
                    {
                        "title": "Telephone Services",
                        "rows": [
                            {
                                "id": "Landline",
                                "title": "Landline",
                                "description": "Local Calls to friends and Family"
                            },
                            {
                                "id": "Fibre Voice",
                                "title": "Fibre Voice",
                                "description": "Calls to both local and mobile numbers for free."
                            }
                        ]
                    }
                ]
            }
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())
    
@jaseci_action(act_group=["O"], allow_remote=True)

def mark_message_as_read(phone_number, message_id, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "status": "read",
        "message_id": message_id
    }
    response = requests.put(whatsapp_url, json=data, headers=headers)
    print(response.json())

# The following walkers are not yet operable but they maight be useful in the future
# 
# 
# 
# 
# 
# 
# 
# 
# 
@jaseci_action(act_group=["O"], allow_remote=True)

def retrieve_download_media(phone_number, message_id, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    url = "https://graph.facebook.com/v15.0/"+whatsapp_url+"?phone_number_id=100744942921876"
    response = requests.get(url, None, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def delete_media(phone_number, message_id, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        # "context": {
        #     "message_id": message_id
        # },
        # "type": "sticker",
        # "sticker": {
        #     "id": media_id
        # }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def upload_media(phone_number, message_id, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        # "context": {
        #     "message_id": message_id
        # },
        # "type": "sticker",
        # "sticker": {
        #     "id": media_id
        # }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_Single_product_message(phone_number, message_id, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "interactive": {
            "type": "product",
            "body": {
                "text": "<OPTIONAL_BODY_TEXT>"
            },
            "footer": {
                "text": "<OPTIONAL_FOOTER_TEXT>"
            },
            "action": {
                "catalog_id": "367025965434465",
                "product_retailer_id": "<ID_TEST_ITEM_1>"
            }
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_multi_product_message(phone_number, message_id, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "interactive",
        "interactive": {
            "type": "product_list",
            "header": {
                "type": "<HEADER_TYPE>",
                "text": "<YOUR_TEXT_HEADER_CONTENT>"
            },
            "body": {
                "text": "<YOUR_TEXT_BODY_CONTENT>"
            },
            "footer": {
                "text": "<YOUR_TEXT_FOOTER_CONTENT>"
            },
            "action": {
                "catalog_id": "146265584024623",
                "sections": [
                    {
                        "title": "<SECTION1_TITLE>",
                        "product_items": [
                            {
                                "product_retailer_id": "<YOUR_PRODUCT1_SKU_IN_CATALOG>"
                            },
                            {
                                "product_retailer_id": "<YOUR_SECOND_PRODUCT1_SKU_IN_CATALOG>"
                            }
                        ]
                    },
                    {
                        "title": "<SECTION2_TITLE>",
                        "product_items": [
                            {
                                "product_retailer_id": "<YOUR_PRODUCT2_SKU_IN_CATALOG>"
                            },
                            {
                                "product_retailer_id": "<YOUR_SECOND_PRODUCT2_SKU_IN_CATALOG>"
                            }
                        ]
                    }
                ]
            }
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_reply_button(phone_number, message_id, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "interactive",
        "interactive": {
            "type": "button",
            "body": {
                "text": "<BUTTON_TEXT>"
            },
            "action": {
                "buttons": [
                    {
                        "type": "reply",
                        "reply": {
                            "id": "<UNIQUE_BUTTON_ID_1>",
                            "title": "<BUTTON_TITLE_1>"
                        }
                    },
                    {
                        "type": "reply",
                        "reply": {
                            "id": "<UNIQUE_BUTTON_ID_2>",
                            "title": "<BUTTON_TITLE_2>"
                        }
                    }
                ]
            }
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())

@jaseci_action(act_group=["O"], allow_remote=True)

def send_message_template_media(phone_number, message_id, media_id,whatsapp_url, authorisation):
    headers = {
        "Authorization": "Bearer "+authorisation,
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "template",
        "template": {
            "name": "template-name",
            "language": {
                "code": "language-and-locale-code"
            },
            "components": [
                {
                    "type": "header",
                    "parameters": [
                        {
                            "type": "image",
                            "image": {
                                "link": "http(s)://the-image-url"
                            }
                        }
                    ]
                },
                {
                    "type": "body",
                    "parameters": [
                        {
                            "type": "text",
                            "text": "text-string"
                        },
                        {
                            "type": "currency",
                            "currency": {
                                "fallback_value": "$100.99",
                                "code": "USD",
                                "amount_1000": 100990
                            }
                        },
                        {
                            "type": "date_time",
                            "date_time": {
                                "fallback_value": "February 25, 1977",
                                "day_of_week": 5,
                                "year": 1977,
                                "month": 2,
                                "day_of_month": 25,
                                "hour": 15,
                                "minute": 33,
                                "calendar": "GREGORIAN"
                            }
                        }
                    ]
                }
            ]
        }
    }
    response = requests.post(whatsapp_url, json=data, headers=headers)
    print(response.json())


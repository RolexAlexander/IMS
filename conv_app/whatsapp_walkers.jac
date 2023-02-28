// walker send_message{
//     has phone_number = " ";
//     has answer = " ";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "text",
//         "text": {
//             "preview_url": False,
//             "body": answer
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     global.message_id = response["response"]["messages"][0]["id"];
//     std.out(global.message_id);
//     disengage;
// }

// walker reply_to_message{
//     has phone_number = "";
//     has answer = "";
//     has message_id = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "context": {
//             "message_id": message_id
//         },
//         "type": "text",
//         "text": {
//             "preview_url": false,
//             "body": answer
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_text_message_with_preview{
//     has phone_number = "";
//     has preview_url = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "to": phone_number,
//         "text": {
//             "preview_url": true,
//             "body": preview_url
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_reply_with_reaction{
//     has phone_number = "";
//     has message_id = "";
//     has emoji = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "reaction",
//         "reaction": {
//             "message_id": message_id,
//             "emoji": emoji
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_image_message_with_url{
//     has phone_number = "";
//     has answer = "";
//     has media_url = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "image",
//         "image": {
//             "link": media_url
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_reply_image_with_url{
//     has phone_number = "";
//     has media_url = "";
//     has message_id = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "context": {
//         "message_id": message_id
//         },
//         "type": "image",
//         "image": {
//             "link": media_url
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_image_message_with_id{
//     has phone_number = "";
//     has media_id = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "image",
//         "image": {
//             "id": media_id
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_reply_image__with_id{
//     has phone_number = "";
//     has media_id = "";
//     has message_id = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "context": {
//         "message_id": message_id
//         },
//         "type": "image",
//         "image": {
//             "link": media_id
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_audio_with_id{
//     has phone_number = "";
//     has media_id = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "audio",
//         "audio": {
//             "id": media_id
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_reply_audio_with_id{
//     has phone_number = "";
//     has media_id = "";
//     has message_id = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "context": {
//             "message_id": message_id
//         },
//         "type": "audio",
//         "audio": {
//             "id": media_id
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_audio_with_url{
//     has phone_number = "";
//     has media_url = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "audio",
//         "audio": {
//             "link": media_url
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_reply_audio_with_url{
//     has phone_number = "";
//     has media_url = "";
//     has message_id = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "context": {
//             "message_id": message_id
//         },
//         "type": "audio",
//         "audio": {
//             "link": media_url
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_document_message_by_iD{
//     has phone_number = "";
//     has media_id = "";
//     has answer = "";
//     has file_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "document",
//         "document": {
//             "id": media_id,
//             "caption": answer,
//             "filename": file_name
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_reply_to_document_message_by_iD{
//     has phone_number = "";
//     has message_id = "";
//     has media_id = "";
//     has answer = "";
//     has file_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "context": {
//             "message_id": message_id
//         },
//         "type": "document",
//         "document": {
//             "id": media_id,
//             "caption": answer,
//             "filename": file_name
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_document_message_by_Url{
//     has phone_number = "";
//     has media_url = "";
//     has answer = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "document",
//         "document": {
//             "link": media_url,
//             "caption": answer
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_reply_to_document_message_by_url{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "context": {
//             "message_id": message_id
//         },
//         "type": "document",
//         "document": {
//             "link": media_url,
//             "caption": user_message
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_sticker_message_by_iD{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "sticker",
//         "sticker": {
//             "id": media_id
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_reply_to_sticker_message_by_id{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "context": {
//             "message_id": message_id
//         },
//         "type": "sticker",
//         "sticker": {
//             "id": media_id
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_sticker_message_by_url{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "sticker",
//         "sticker": {
//             "link": media_url
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_reply_to_sticker_message_by_url{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "context": {
//             "message_id": message_id
//         },
//         "type": "sticker",
//         "sticker": {
//             "link": media_url
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_video_message_by_id{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "video",
//         "video": {
//             "caption": user_message,
//             "id": media_id
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_reply_to_video_message_by_id{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "context": {
//             "message_id": message_id
//         },
//         "type": "video",
//         "video": {
//             "caption": user_message,
//             "id": media_id
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_video_message_by_url{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "video",
//         "video": {
//             "caption": user_message,
//             "link": media_url
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_reply_to_video_message_by_url{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "context": {
//             "message_id": message_id
//         },
//         "type": "video",
//         "video": {
//             "caption": user_message,
//             "id": media_url
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_contact_message{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";
//     has contact;

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data =  {
//         "messaging_product": "whatsapp",
//         "to": phone_number,
//         "type": "contacts",
//         "contacts": contact
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_reply_to_contact_message{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";
//     has contact;

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data =  {
//         "messaging_product": "whatsapp",
//         "to": phone_number,
//         "context": {
//             "message_id": message_id
//         },
//         "type": "contacts",
//         "contacts": contact
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_location_messages{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "location",
//         "location": {
//             "latitude": latitude,
//             "longitude": longitude,
//             "name": location_name,
//             "address": address
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_reply_to_location_message{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "context": {
//             "message_id": message_id
//         },
//         "type": "location",
//         "location": {
//             "latitude": latitude,
//             "longitude": longitude,
//             "name": location_name,
//             "address": address
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_message_template_text{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "template",
//         "template": {
//             "name": template_name,
//             "language": {
//                 "code": "en_US"
//             }
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_message_list{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";
//     has interactive;

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "interactive",
//         "interactive": interactive
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker send_reply_to_list_message{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "context": {
//             "message_id": message_id
//         },
//         "type": "interactive",
//         "interactive": {
//             "type": "list",
//             "header": {
//                 "type": "text",
//                 "text": "Gtt Service"
//             },
//             "body": {
//                 "text": "They are an array of Gtt services, please select one from below"
//             },
//             "footer": {
//                 "text": "Services"
//             },
//             "action": {
//                 "button": "Gtt Services",
//                 "sections": [
//                     {
//                         "title": "Internet Services",
//                         "rows": [
//                             {
//                                 "id": "Blaze",
//                                 "title": "Blaze",
//                                 "description": "Fastest Internet in Guyana"
//                             },
//                             {
//                                 "id": "Fibre",
//                                 "title": "Fibre",
//                                 "description": "Third Fastest Internet in Guyana"
//                             }
//                         ]
//                     },
//                     {
//                         "title": "Telephone Services",
//                         "rows": [
//                             {
//                                 "id": "Landline",
//                                 "title": "Landline",
//                                 "description": "Local Calls to friends and Family"
//                             },
//                             {
//                                 "id": "Fibre Voice",
//                                 "title": "Fibre Voice",
//                                 "description": "Calls to both local and mobile numbers for free."
//                             }
//                         ]
//                     }
//                 ]
//             }
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// walker mark_message_as_read{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";

//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "status": "read",
//         "message_id": message_id
//     };
//     response = request.put(url ,data , headers);
//     disengage;
// }
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// // 
// //These Walker need editing to allow users to use them more efficiently
// // Retrieve media is dependent on the I.retreive_media python module
// walker retrieve_download_media{
//     has phone_number = "";
//     has message_id = "";
//     has file_name = "";
//     has preview_url = "";
//     has user_number = "";
//     has user_message = "";
//     has media_url = "";
//     has media_id = "";
//     has latitude = 0;
//     has longitude = 0;
//     has location_name = "";
//     has address = "";
//     has template_name = "";

//     url = "https://graph.facebook.com/v15.0/"+global.whatsapp_url+"?phone_number_id=100744942921876";
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     response = request.get(url ,null , headers);
//     global.user_media_url = response["response"]["url"];
//     disengage;
// }

// //This walker is uesd everytime we upload a media and is finish sending it
// walker delete_media{
//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number
//         // "context": {
//         //     "message_id": message_id
//         // },
//         // "type": "text",
//         // "text": {
//         //     "preview_url": false,
//         //     "body": user_message
//         // }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// //Upload media only if you don't have a loophole server for sending media
// //Edit and complete tomorrow along with 
// walker upload_media{
//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number
//         // "context": {
//         //     "message_id": message_id
//         // },
//         // "type": "text",
//         // "text": {
//         //     "preview_url": false,
//         //     "body": user_message
//         // }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// //Don't know if we need this walker
// walker send_single_product_message{
//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "interactive": {
//             "type": "product",
//             "body": {
//                 "text": "<OPTIONAL_BODY_TEXT>"
//             },
//             "footer": {
//                 "text": "<OPTIONAL_FOOTER_TEXT>"
//             },
//             "action": {
//                 "catalog_id": "367025965434465",
//                 "product_retailer_id": "<ID_TEST_ITEM_1>"
//             }
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// //Don't know if we need this walker
// walker send_multi_product_message{
//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "interactive",
//         "interactive": {
//             "type": "product_list",
//             "header": {
//                 "type": "<HEADER_TYPE>",
//                 "text": "<YOUR_TEXT_HEADER_CONTENT>"
//             },
//             "body": {
//                 "text": "<YOUR_TEXT_BODY_CONTENT>"
//             },
//             "footer": {
//                 "text": "<YOUR_TEXT_FOOTER_CONTENT>"
//             },
//             "action": {
//                 "catalog_id": "146265584024623",
//                 "sections": [
//                     {
//                         "title": "<SECTION1_TITLE>",
//                         "product_items": [
//                             {
//                                 "product_retailer_id": "<YOUR_PRODUCT1_SKU_IN_CATALOG>"
//                             },
//                             {
//                                 "product_retailer_id": "<YOUR_SECOND_PRODUCT1_SKU_IN_CATALOG>"
//                             }
//                         ]
//                     },
//                     {
//                         "title": "<SECTION2_TITLE>",
//                         "product_items": [
//                             {
//                                 "product_retailer_id": "<YOUR_PRODUCT2_SKU_IN_CATALOG>"
//                             },
//                             {
//                                 "product_retailer_id": "<YOUR_SECOND_PRODUCT2_SKU_IN_CATALOG>"
//                             }
//                         ]
//                     }
//                 ]
//             }
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// //Don't know if we need this walker also
// walker send_reply_button{
//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "interactive",
//         "interactive": {
//             "type": "button",
//             "body": {
//                 "text": "<BUTTON_TEXT>"
//             },
//             "action": {
//                 "buttons": [
//                     {
//                         "type": "reply",
//                         "reply": {
//                             "id": "<UNIQUE_BUTTON_ID_1>",
//                             "title": "<BUTTON_TITLE_1>"
//                         }
//                     },
//                     {
//                         "type": "reply",
//                         "reply": {
//                             "id": "<UNIQUE_BUTTON_ID_2>",
//                             "title": "<BUTTON_TITLE_2>"
//                         }
//                     }
//                 ]
//             }
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }

// //I am quite certain we don't need this media
// walker send_message_template_media{
//     url = global.whatsapp_url;
//     headers = {
//         "Authorization": "Bearer "+global.authorisation,
//         "Content-Type": "application/json"
//     };
//     data = {
//         "messaging_product": "whatsapp",
//         "recipient_type": "individual",
//         "to": phone_number,
//         "type": "template",
//         "template": {
//             "name": "template-name",
//             "language": {
//                 "code": "language-and-locale-code"
//             },
//             "components": [
//                 {
//                     "type": "header",
//                     "parameters": [
//                         {
//                             "type": "image",
//                             "image": {
//                                 "link": "http(s)://the-image-url"
//                             }
//                         }
//                     ]
//                 },
//                 {
//                     "type": "body",
//                     "parameters": [
//                         {
//                             "type": "text",
//                             "text": "text-string"
//                         },
//                         {
//                             "type": "currency",
//                             "currency": {
//                                 "fallback_value": "$100.99",
//                                 "code": "USD",
//                                 "amount_1000": 100990
//                             }
//                         },
//                         {
//                             "type": "date_time",
//                             "date_time": {
//                                 "fallback_value": "February 25, 1977",
//                                 "day_of_week": 5,
//                                 "year": 1977,
//                                 "month": 2,
//                                 "day_of_month": 25,
//                                 "hour": 15,
//                                 "minute": 33,
//                                 "calendar": "GREGORIAN"
//                             }
//                         }
//                     ]
//                 }
//             ]
//         }
//     };
//     response = request.post(url ,data , headers);
//     std.out(response);
//     disengage;
// }


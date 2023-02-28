
// spawn faq_state 
walker ingest_faq {
    has kb_file;

    root: take -[conv_root]-> node::conv_root;
    conv_root: take -[dialog]-> node::dialog;
    dialog: take -[intent_transition]-> node::faqs;
    faqs {
        kb = file.load_json(global.train_faq_answer_path);
        for faq in kb {
            answer = faq["answer"];
            spawn here +[faq]+> node::faq(name = "faq", answer=answer);

        }
    }
}

// update user node
walker maintainer {
    has prev_state;
    has dialogue_context;
    root: take -[conv_root]-> node::conv_root;
    conv_root: take -[user]-> node::user;
}

// create nodes and edges
walker create_node_and_edge{
    has first_node = "";
    has second_node = "";
    has template = "";          // response_only
    has intent = "";            // greetings
    has entities = [];          // number
    has name = "";              // number


    with entry {
        if(first_node == ""): first_node = global.dialog;
        bienc = file.load_json(global.train_classifer_path);


        
        if(second_node ==""){
            // std.out("first_node");
            // std.out(first_node);
            uuid_1 = spawn *(first_node) walker::get_jac_uuid;
            std.out("First");

            if(template == "response_only"){
                uuid_2 = spawn node::response_only_template(imprint=[{"list_imprint": bienc[intent], "name": intent}], name=intent);
            }
            elif(template == "extract_info"){
                if (intent in bienc){
                    uuid_2 = spawn node::extract_info_template(imprint=[{"list_imprint": bienc[intent], "name": intent}], name=intent);
                }
                else{
                    uuid_2 = spawn node::extract_info_template(name=intent);
                    global.entity_label.list::append(intent);
                }
            }
            elif(template == "collect_info"){
                if (intent in bienc){
                    uuid_2 = spawn node::collect_info_template(imprint=[{"list_imprint": bienc[intent], "name": intent}], name=intent);
                }
                else{
                    uuid_2 = spawn node::collect_info_template(name=intent);
                    global.entity_label.list::append(intent);
                }
            }

            if(intent != ""){
                uuid_1 +[intent_transition(intent=intent.str)]+> uuid_2;
            }
            elif(entities.length > 0){
                uuid_1 +[entity_transition(entities=entities)]+>uuid_2;
            }
            elif(name != ""){
                uuid_1 +[redirect_transition(name=name)]+>uuid_2;
            }

            report:custom = {"uuid_1":uuid_1.info['jid'], "uuid_2":uuid_2.info['jid']};
        }
        elif (second_node !=""){
            uuid_1 = spawn *(first_node) walker::get_jac_uuid;
            uuid_2 = spawn *(second_node) walker::get_jac_uuid;
            std.out("Second");

            if(intent != ""){
                uuid_1 +[intent_transition(intent=intent.str)]+> uuid_2;
            }
            elif(entities.length > 0){
                uuid_1 +[entity_transition(entities=entities)]+>uuid_2;
            }
            elif(name != ""){
                uuid_1 +[redirect_transition(name=name)]+>uuid_2;
            }
            report:custom = {"uuid_1":uuid_1.info['jid'], "uuid_2":uuid_2.info['jid']};
        }
    }
}

// get jac uuid work with walker create_node_and_edge
walker get_jac_uuid{
    has anchor uuid;
    with entry{
        uuid = here;
        // report:custom = uuid;
    }
}

walker send_message{
    has phone_number = " ";
    has answer = " ";

    url = global.whatsapp_url;
    headers = {
        "Authorization": "Bearer "+global.authorisation,
        "Content-Type": "application/json"
    };
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
    };
    response = request.post(url ,data , headers);
    std.out(response);
    global.message_id = response["response"]["messages"][0]["id"];
    std.out(global.message_id);
    disengage;
}

walker reply_to_message{
    has phone_number = "";
    has answer = "";
    has message_id = "";

    url = global.whatsapp_url;
    headers = {
        "Authorization": "Bearer "+global.authorisation,
        "Content-Type": "application/json"
    };
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "context": {
            "message_id": message_id
        },
        "type": "text",
        "text": {
            "preview_url": false,
            "body": answer
        }
    };
    response = request.post(url ,data , headers);
    std.out(response);
    disengage;
}

walker send_image_message_with_url{
    has phone_number = "";
    has answer = "";
    has media_url = "";

    url = global.whatsapp_url;
    headers = {
        "Authorization": "Bearer "+global.authorisation,
        "Content-Type": "application/json"
    };
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "image",
        "image": {
            "link": media_url
        }
    };
    response = request.post(url ,data , headers);
    std.out(response);
    disengage;
}

walker send_document_message_by_Url{
    has phone_number = "";
    has media_url = "";
    has answer = "";

    url = global.whatsapp_url;
    headers = {
        "Authorization": "Bearer "+global.authorisation,
        "Content-Type": "application/json"
    };
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "document",
        "document": {
            "link": media_url,
            "caption": answer
        }
    };
    response = request.post(url ,data , headers);
    std.out(response);
    disengage;
}

walker send_reply_with_reaction{
    has phone_number = "";
    has message_id = "";
    has emoji = "";
    has anchor response;

    url = global.whatsapp_url;
    headers = {
        "Authorization": "Bearer "+global.authorisation,
        "Content-Type": "application/json"
    };
    data = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": phone_number,
        "type": "reaction",
        "reaction": {
            "message_id": message_id,
            "emoji": emoji
        }
    };
    response = request.post(url ,data , headers);
    std.out(response);
    disengage;
}

// talker 
walker talk {
    has question, media_url, media_type, user_data, phone_number;
    has predicted_intent;
    has extracted_entities={};
    has dialogue_context ={
        "image": [],
        "video": [],
        "audio": [],
        "description": "",
        "location": [],
        "asked": [],
        "last_node": "",
        "recieved": [],
        "case_number": "",
        "repeat_report": false,
        "repeat_id": "",
        "live_location": {
            "latitude": null,
            "longitude": null
        },
        "cancel_casenumber": "",
        "status_casenumber": "",
        "report_title": ""
    };

    has response;
    has next_state;
    has prev_state;
    has cont_state;
    has yes_or_no;
    has respond = true;
    has threshold = false;
    has right_away_transition;

    root: take -[conv_root]-> node::conv_root;
    conv_root: take -[user]-> node::user;
    user {
        if(cont_state == ""): std.out('WALKER TALKER ERROR: cont_state is an EMPTY STR');
        take *(cont_state);
        std.out("userrrrr");
    }
    dialogue_state {
        std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        std.out(here.name);
        std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        //  || here.name == "image" || here.name == "description" || here.name == "location"
        // if(here.name == "subscribe"){
        //     here::subscribe;
        // }
        // if(here.name =="unsubscribe"){
        //     here::unsubscribe;
        // }
        if(here.name == "traffic_report"){
            std.out("______________________________true_______________________________");
            if(right_away_transition){
                std.out("_____________Asking Question now________________________");
                take right_away_transition;
            }else{
                std.out("_____________We have no right_away_transition________________________");
                take *(global.dialog);
            }
        }
        elif((here.name == "confirmation") || (here.name == "cancellation")){
            if(right_away_transition){
                yield;
                take right_away_transition;
            }else{
                take *(global.dialog);
            }
        }
        else{
            if (respond) {
                take next_state else {
                    report {
                        "name": here.name,
                        "response": "Sorry I can't handle that just yet."
                    };
                }
                respond = false;
            }
            // std.out("______________________________False_______________________________");
            // if(next_state){
            //     std.out("______________________________ccccccccccccccccccccccccccc_______________________________");
            //     take next_state;
            //     respond = false;
            // }else{
            //     std.out("______________________________mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm_______________________________");
            //     yield;
            //     take *(global.main_root);
            // }
        }
    }
}

walker subscribe{
    has anchor response;
    has phone_number;

    headers = {};
    url = "http://52.72.153.254:8050/api/v1/subscribe";
    data = {
        "subscription_type" : "whatsapp",
        "subscription_value" : phone_number
    };
    response = request.post(url, data, headers);
    report {"Request Status": response};
}

walker unsubscribe{
    has anchor response;
    has phone_number;

    headers = {};
    url = "http://52.72.153.254:8050/api/v1/unsubscribe";
    data = {
        "subscription_type" : "whatsapp",
        "subscription_value" : phone_number
    };
    response = request.post(url, data, headers);
    report {"Request Status": response};
}

walker traffic_alert{
    has anchor response;
    has phone_number;

    url = "http://52.72.153.254:8050/api/v1/general-alerts/latest";
    data = {};
    headers = {};
    response = request.get(url, data, headers);
    report {"Request Status": response};
}

walker traffic_report{
    has title = "Traffic Report";
    has description;
    has suggested_action = "Fix this";
    has anchor response;

    data = {
        "title": title,
        "description": description,
        "suggested_action": suggested_action
    };
    url = "https://app.resolv-ims.com/ords/gms/case/add";
    headers = {};
    response = request.post(url, data, headers);
    report {"Request Status": response};
}

walker status{
    has anchor response;
    has phone_number;
    has case_number;

    url = "http://52.72.153.254:8050/api/v1/cases/"+case_number+"/status";
    headers = {};
    data = {
        "case_number": case_number
    };
    response = request.get(url, data, headers);
    report {"Request Status": response};
}

walker cancel{
    has anchor response;
    has phone_number;
    has case_number;

    url = "http://52.72.153.254:8050/api/v1/cases/"+case_number+"/withdraw";
    headers = {};
    data = {
        "case_number": case_number,
        "phone_number": phone_number
    };
    response = request.get(url, data, headers);
    report {"Request Status": response};
}
 
walker sample_walker: anyone {
    has id;
    with entry {
        report "Public Url Recieved Post request";
    }
    request_context = global.info["request_context"];
    std.out(request_context);
    method = request_context["method"];
    if(method == "GET"){
        token = "123";
        mode = "subscribe";
        challenge = request_context["query"]["hub.challenge"];
        if(request_context["query"]["hub.verify_token"] && request_context["query"]["hub.mode"]){
            std.out("Get request has both verify token and mode");
            std.out("Verification token:",request_context["query"]["hub.verify_token"]);
            std.out("Verification token:",token);
            std.out("Verification token:",request_context["query"]["hub.mode"]);
            std.out("Verification token:",mode);
            if((request_context["query"]["hub.verify_token"] == token) && (request_context["query"]["hub.mode"] == mode)){
                std.out("verified user");
                // report status = 200;
                report:custom = challenge.int;
                // report: custom = {
                //     "challenge": challenge
                // };
                std.out(challenge);
                disengage;
            }
        }
        
    }
    if(method == "POST"){
        std.out("User wants to start the whatsapp bot");
        sender_number = null;
        sentinel = jaseci.sentinel_active_get();
        std.out(sentinel);
        sentinel = sentinel["jid"];
        sender_message = null;
        media_url = null;
        media_type = null;
        auth = "Token 3368b1d7740e9a3e5892f3c8fd15bbf50ec01305b896855ff052a1bf52ef847f";
        update_token = false;
        data = request_context["body"];
        sender_data = data["entry"][0]["changes"][0]["value"]["messages"][0];
        sender_number = data["entry"][0]["changes"][0]["value"]["messages"][0]["from"];
        message_id = data["entry"][0]["changes"][0]["value"]["messages"][0]["id"];
        media_type = sender_data["type"];
        user_data = None;
        sender_message = null;

        if (media_type=="audio"){
            std.out("User sent Audio");
            user_data = {
                "audio_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["audio"]["id"],
                "message_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["id"]
            };
            std.out(user_data);
            std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        }  
        elif(media_type=="text"){
            std.out("User sent text");
            user_data = {
                "user_utterance": data["entry"][0]["changes"][0]["value"]["messages"][0]["text"]["body"],
                "message_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["id"]
            };
            sender_message = data["entry"][0]["changes"][0]["value"]["messages"][0]["text"]["body"];
            std.out(user_data);
            std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        }
        elif(media_type=="location"){
            std.out("User sent Location");
            user_data = {
                "Latitude": data["entry"][0]["changes"][0]["value"]["messages"][0]["location"]["latitude"],
                "Longitude": data["entry"][0]["changes"][0]["value"]["messages"][0]["location"]["longitude"],
                "message_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["id"]
            };
            std.out(user_data);
            std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        }   
        elif(media_type=="document"){
            std.out("User sent document"); //mime_type
            if("mime_type" in data["entry"][0]["changes"][0]["value"]["messages"][0]["document"]){
                user_data = {
                    "document_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["document"]["id"],
                    "message_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["id"],
                    "document_type": data["entry"][0]["changes"][0]["value"]["messages"][0]["document"]["mime_type"]
                };
            }else{
                user_data = {
                    "document_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["document"]["id"],
                    "message_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["id"]
                };
            }
            std.out(user_data);
            std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        }
        elif(media_type=="sticker"){
            std.out("user sent Sticker");
            user_data = {
                "sticker_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["sticker"]["id"],
                "message_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["id"]
            };
            std.out(user_data);
            std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        }     
        elif(media_type=="reaction"){
            std.out("user sent reaction");
            user_data = {
                "reaction": data["entry"][0]["changes"][0]["value"]["messages"][0]["reaction"]["emoji"],
                "message_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["id"]
            };
            std.out(user_data);
            std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        }  
        elif(media_type=="image"){
            std.out("User sent image");
            user_data = {
                "image_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["image"]["id"],
                "message_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["id"]
            };
            std.out(user_data);
            std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        }  
        elif(media_type=="contacts"){
            std.out("User sent Contact");
            user_data = {
                "Name": data["entry"][0]["changes"][0]["value"]["messages"][0]["contacts"][0]["name"]["formatted_name"],
                "phone_number": data["entry"][0]["changes"][0]["value"]["messages"][0]["contacts"][0]["phones"][0]["wa_id"],
                "message_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["id"]
            };
            std.out(user_data);
            std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        } 
        elif(media_type=="interactive"){
            std.out("User sent interactive");
            user_data = {
                "interactive_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["interactive"]["list_reply"]["id"],
                "interactive_title": data["entry"][0]["changes"][0]["value"]["messages"][0]["interactive"]["list_reply"]["title"],
                "message_id": data["entry"][0]["changes"][0]["value"]["messages"][0]["id"]
            };
            std.out(user_data);
            std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        }    
        else{
            std.out("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
            std.out("User sent unknow media");
            std.out("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
        }
        if (
            data["entry"] &&
            data["entry"][0]["changes"] &&
            data["entry"][0]["changes"][0] &&
            data["entry"][0]["changes"][0]["value"]["messages"] &&
            data["entry"][0]["changes"][0]["value"]["messages"][0]
        ){
            std.out("User Passed all the required parameters. We will now proceed to start up the conversational bot");
            url = request_context["headers"]["Host"];
            url = "http://"+url+"/js/walker_run";
            std.out(url);
            headers = {
                'Authorization': auth,
                'Content-Type': 'application/json'
            };
            data = {
                "name": "talk",
                "ctx": {
                    "question": sender_message, 
                    "phone_number": sender_number,
                    "user_data": user_data,
                    "media_url": media_url,
                    "media_type": media_type
                },
                "_req_ctx": {},
                "snt": sentinel,
                "profiling": False,
                "is_async": False
            };
            std.out(data);
            response = request.post(url,data,headers);
        } 
    }
    if(method == "PUT"){
        report:custom = {
            "status": 415,
            "message": "The method you utilise is still in development. Thank you for your understanding. Additionally, I have a quote for you 'How you do anything is how you do everything, therefore Excellence auth to be an habit not an act'."
        };
    }else{
        report:custom = {
            "status": 415,
            "message": "The method you utilise is not supported. Try making a 'post', 'put' or 'get' request. Thank you for your understanding. Additionally, I have a quote for you 'How you do anything is how you do everything, therefore Excellence auth to be an habit not an act'."
        };
    }
}

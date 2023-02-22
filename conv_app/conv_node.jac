import {*} with "./conv_walkers.jac";
import {*} with "./whatsapp_walkers.jac";

node response_only_template:dialogue_state{
    has name;

    can nlu with talk entry {
        ::classify_intent;
        ::extract_entities;
        ::business_logic;

        state_json = file.load_json(global.train_state_path);
        for state in state_json{
            if (!visitor.respond) {
                if (here.name == state["name"].str){
                    arry = flow.select_response({}, state['responses'], {});
                    // arry = flow.select_response(null, state['responses'], null);
                    // std.out(arry);
                    visitor.response = arry['response'];
                    // visitor.response = arry[1];
                }
            }
        }
    }

    // can process with talk entry{
    //     visitor.next_state = -[intent_transition(intent==global.dialog)]->;
    // }
}
// respond only 
// redirect to dialog

node extract_info_template:dialogue_state{
    has name;

    can nlu with talk entry {
        ::classify_intent;
        ::extract_entities;
        ::business_logic;

        state_json = file.load_json(global.train_state_path);
        for state in state_json{
            if (here.name == state["name"].str){
                arry = flow.select_response(state["extracted_item"], state["responses"], visitor.dialogue_context); # select a response
                if(arry["name"] != ""){
                    visitor.response = arry['response'];
                    visitor.next_state = here;
                }
                elif(arry['name'] == ""){
                    my_dict = flow.info_json(state['resource'], visitor.dialogue_context, state['variable'] ); # setup data for response

                    if(my_dict['info_json'].length != 0){
                        visitor.extracted_entities = my_dict['info_json'][0];
                        ::business_logic;
                    }
                    else{
                        ans = flow.gen_response(arry['response'], my_dict, null);
                        visitor.response = ans;
                    }
                }
            }
        }
    }
}
// confirm entity
// if entity found: redirect to collect_info_template
// faq intent_transition

node collect_info_template:dialogue_state{
    has name;

    can nlu with talk entry{
        ::extract_entities;
        ::business_logic;
        
        state_json = file.load_json(global.train_state_path);
        for state in state_json{
            if (!visitor.respond) {
                if (here.name == state["name"].str){
                    if (state["variable"][0] not in visitor.dialogue_context){
                        visitor.next_state = -[redirect_transition]->[0];
                        visitor.respond = true;
                        visitor.predicted_intent = '';
                    }
                    else{
                        arry = flow.select_response({}, state['responses'], {});
                        ans = flow.gen_response(arry['response'], visitor.dialogue_context, null);
                        visitor.response = ans;
                        visitor.next_state = -[intent_transition(intent==global.dialog)]->;
                    }
                }
            }
        }
    }
}
// if entity not found: redirect to extract_info_template





node dialogue_state{
    has imprint;
    has name;

    // hold threshold list
    // ai kit 
    can tfm_ner.extract_entity;
    can use.text_classify;

    // custom modules
    can flow.info_json;
    can flow.select_response;
    can flow.gen_response;
    can flow.collect_info;
    can flow.select_options;
    can flow.check_required_entity;
    can latest.update;
    // can I.get_audio, I.get_image, I.get_video;
    // can location.get_details;

    can set_question{
        std.out("before question: ",visitor.question);
        if(!visitor.question || visitor.question == " "){
            std.out("User has no question");
            visitor.question = "Can I report a road problem?";
        }
        std.out("After question: ",visitor.question);
        std.out(visitor.dialogue_context);
    }

    can handle_negative_and_affirmative_response{
        data = file.load_json(global.bi_train_path);
        affirmative_data = data["yes"];
        negative_data = data["no"];
        classes = [];
        classes.list::extend(affirmative_data);
        classes.list::extend(negative_data);
        best_answer = use.text_classify(text = visitor.question, classes = classes);
        max_score = global.conv_score;
        index = best_answer["match_idx"];
        scores = best_answer["scores"];
        if(scores[index] > max_score){
            if(classes[index] in negative_data){
                std.out("_______________________negative response___________________");
                if((visitor.dialogue_context["last_node"] = "describe") || (visitor.dialogue_context["last_node"] = "location") || (visitor.dialogue_context["last_node"] = "image")){
                    visitor.threshold = true;
                    visitor.predicted_intent = "traffic_report";
                }
            }
            if(classes[index] in affirmative_data){
                std.out("_______________________affirmative response___________________");
            }
        }
    }

    can continue_report{
        if((visitor.dialogue_context["repeat_report"] == true) && (visitor.dialogue_context["recieved"] || visitor.dialogue_context["asked"])){
            std.out("________________Generating Repeated Message with reply__________________");
            data = file.load_json(global.train_state_path);
            responses = [];
            for obj in data{ 
                if("repeat_report" == obj["name"]){
                    responses = obj["responses"];
                    visitor.response = rand.choice(responses);
                }
            }
            if(visitor.response == "this is the dialogue root"){
                std.out("__________________Can't Send this to user_______________________");
                visitor.response = null;
            }
            if(visitor.response){
                std.out("__We are sending the following response: ", visitor.response, "to user ", visitor.phone_number, here.name);
                spawn here walker::reply_to_message(phone_number = visitor.phone_number, answer = visitor.response,  message_id = visitor.dialogue_context["repeat_id"]);
                visitor.response = null;
                std.out("________________________Finish Generating response_____________________-");
            }
            visitor.dialogue_context["repeat_report"] = false;
        }
    }

    can record_id{
        visitor.dialogue_context["repeat_id"] = response["messages"][0]["id"];
        visitor.dialogue_context["repeat_report"] = true;
    }

    // can retrieve_media with talk entry{
    //     std.out("before question: ",visitor.question);
    //     if(visitor.user_data){
    //         std.out("User sent a media");
    //         std.out(visitor.user_data);
    //         if(visitor.media_type == "location"){
    //             if(("Latitude" in visitor.user_data) && ("Longitude" in visitor.user_data)){
    //                 // Get the location description
    //                 result = location.get_details(visitor.user_data["Latitude"], visitor.user_data["longitude"]);
    //                 // address = result["display_name"];
    //                 visitor.dialogue_context["location"].list::extend(result);
    //                 if(!"location" in visitor.dialogue_context["recieved"]){
    //                     visitor.dialogue_context["recieved"].list::append("location");
    //                 }
    //                 std.out("Got the user location");
    //             }
    //         }
    //         if(visitor.media_type == "document"){
    //             if(("document_type" in visitor.user_data) && ("document_id" in visitor.user_data)){
    //                 // Get the video
    //                 filename = rand.word()+".mp4";
    //                 null_variables = "";
    //                 visitor.dialogue_context["video"].list::append(filename);
    //                 I.get_video(visitor.user_data["document_id"], filename);
    //                 if(!"image" in visitor.dialogue_context["recieved"]){
    //                     visitor.dialogue_context["recieved"].list::append("image");
    //                 }
    //                 visitor.media_url = null;
    //             }else{
    //                 std.out("We are not required to download this media");
    //             }
    //         }
    //         if(visitor.media_type == "image"){
    //             if("image_id" in visitor.user_data){
    //                 filename = rand.word()+".jpg";
    //                 null_variables = "";
    //                 visitor.dialogue_context["image"].list::append(filename);
    //                 I.get_image(visitor.user_data["image_id"], filename);
    //                 if(!"image" in visitor.dialogue_context["recieved"]){
    //                     visitor.dialogue_context["recieved"].list::append("image");
    //                 }
    //                 visitor.media_url = null;
    //             }
    //         }
    //         if(visitor.media_type == "audio"){
    //             if("" in visitor.user_data){
    //                 // download media
    //             }
    //         }
    //         if(visitor.media_type == "interactive"){
    //             if("" in visitor.user_data){
    //                 // download media
    //             }
    //         }
                
    //         // if(visitor.media_type == "image/jpeg"){
    //         //     filename = rand.word()+".jpg";
    //         //     null_variables = "";
    //         //     visitor.dialogue_context["image"].list::append(filename);
    //         //     I.get_media(visitor.media_url, null_variables, null_variables, filename);
    //         //     if(!"image" in visitor.dialogue_context["recieved"]){
    //         //         visitor.dialogue_context["recieved"].list::append("image");
    //         //     }
    //         //     visitor.media_url = null;
    //         // }
    //         // if(visitor.media_type == "video"){
    //         //     filename = rand.word()+".mp4";
    //         //     null_variables = "";
    //         //     visitor.dialogue_context["image"].list::append(filename);
    //         //     I.get_media(null_variables, null_variables, visitor.media_url, filename);
    //         //     visitor.media_url = null;
    //         // }
    //         // if(visitor.media_type == "audio"){
    //         //     filename = rand.word()+".mp3";
    //         //     null_variables = "";
    //         //     visitor.dialogue_context["image"].list::append(filename);
    //         //     I.get_media(null_variables, visitor.media_url, null_variables, filename);
    //         //     visitor.media_url = null;
    //         // }
    //     }
    //     if(!visitor.question || visitor.question == " "){
    //         std.out("User has no question");
    //         visitor.question = "Can I report a road problem?";
    //     }
    //     std.out("After question: ",visitor.question);
    //     std.out(visitor.dialogue_context);
    // }

    can classify_intent {
        // labels = ["not_traffic_report", "traffic_report"];
        // bi_intent = bi_enc.infer(
        //     contexts=[visitor.question],
        //     candidates=labels,
        //     context_type="text",
        //     candidate_type="text"
        // );
        // std.out(bi_intent);
        // bi_intent = bi_intent[0]["predicted"]["label"];
        // if(bi_intent == "traffic_report"){
        //     visitor.predicted_intent = "traffic_report";
        //     visitor.threshold = true;
        //     std.log("THRESHOLD: ", global.conv_score,"   SCORE: " , 90);
        //     std.log("INTENT:  ", visitor.predicted_intent);
        // }else{
            ::set_question;
            if(visitor.respond){
                imprints = -[intent_transition]->.imprint;
                intent_labels = -[intent_transition]->.edge.intent;
                std.out("intent_labels");
                std.out(intent_labels);
                max_score = global.conv_score;
                intent = "";

                for imprint in imprints {
                    // std.out("imprint dict");
                    // std.out(imprint[0]);
                    // std.out(imprint[0]['list_imprint']);
                    if (imprint[0].type == dict ){

                        best_answer = use.text_classify(
                            text = visitor.question,
                            classes = imprint[0]['list_imprint'].list
                        );
                        // std.out("best_answer");
                        // std.out(best_answer);
                        nn = best_answer['match_idx'];
                        if (best_answer['scores'][nn] > max_score){
                            max_score = best_answer['scores'][nn];
                            intent = imprint[0].name;
                        }
                            // std.out('here.name\n');
                            // std.out(here.name);
                            // std.out(best_answer['scores'][nn]);
                            // std.out(imprint[0].name);
                    }
                }
                    
                if (max_score > global.conv_score and intent in intent_labels){
                    visitor.threshold = true;
                    visitor.predicted_intent = intent;
                }
                std.log("THRESHOLD: ", global.conv_score,"   SCORE: " , max_score, " user utterance: ", visitor.question);
                std.log("INTENT:  ", visitor.predicted_intent);
                if(!visitor.predicted_intent){
                    ::handle_negative_and_affirmative_response;
                    if(!visitor.predicted_intent){
                        std.out("_________________AI Doesn't Understand the user request___________________________________");
                        data = file.load_json(global.train_state_path);
                        responses = [];
                        for obj in data{ 
                            if("service_not_offered" == obj["name"]){
                                data = obj;
                            }
                        }
                        responses = data["responses"];
                        visitor.response = rand.choice(responses);
                        response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
                        visitor.response = null;
                    }
                    
                }
            }
        // }  
        // if((visitor.predicted_intent == "yes") || (visitor.predicted_intent == "no")){
        //     std.out("xxxxxxxxxxxxxxxxxxxx__User is confirming something about traffic report__xxxxxxxxxxxxxxxxxxxxxxxxx");
        //     std.out(visitor.predicted_intent);
        //     std.out("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
        //     visitor.predicted_intent = "traffic_report";
        // }
        // std.out("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
        // std.out(visitor.predicted_intent);
        // std.out("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    }

    can extract_entities {
        if(visitor.question){
            if(visitor.respond){
                res = tfm_ner.extract_entity(visitor.question);
                if(res.type == list || res.type == dict){

                    for ent in res {
                        ent_type = ent["entity_value"];
                        ent_text = ent["entity_text"];
                        if ( !(ent_type in visitor.extracted_entities) ){
                            visitor.extracted_entities[ent_type] = [];
                        }
                        
                        if( ent_text not in visitor.extracted_entities[ent_type] ){
                            visitor.extracted_entities[ent_type].l::append(ent_text);
                            if(ent_type == "location"){
                                visitor.dialogue_context["location"].list::append(ent_text);
                                if("location" in visitor.dialogue_context["recieved"]){
                                    std.out("Already collected location");
                                }else{
                                    visitor.dialogue_context["recieved"].list::append("location");
                                }
                            }
                        }
                    }
                }
                std.log("ENTITIES:  ", visitor.extracted_entities);
            }
        }
    }

    can generate_failed_response{
        std.out("_________________Generating Failed request___________________________________");
        data = file.load_json(global.train_state_path);
        responses = [];
        for obj in data{ 
            if("failed_request" == obj["name"]){
                data = obj;
            }
        }
        if(here.name in data["responses"]){
            responses = data["responses"][here.name];
            visitor.response = rand.choice(responses);
        }
        response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
        visitor.response = null;
    }

    can generate_successful_response{
        std.out("_________________Generating successful request___________________________________");
        data = file.load_json(global.train_state_path);
        responses = [];
        for obj in data{ 
            if("successful_request" == obj["name"]){
                data = obj;
            }
        }
        if(here.name in data["responses"]){
            responses = data["responses"][here.name];
            visitor.response = rand.choice(responses);
        }
        response = spawn here walker::reply_to_message(phone_number = visitor.phone_number, answer = visitor.response, message_id = visitor.user_data["message_id"]);
        visitor.response = null;
    }

    can business_logic {
        visitor.dialogue_context.dict::update(visitor.extracted_entities);
        // std.out("global.entity_label");
        // std.out(global.entity_label);
        for label in global.entity_label {
            if (label in visitor.extracted_entities) {
                visitor.dialogue_context[label]=visitor.extracted_entities[label][0];
            }
        }
    }

    can nlu with talk entry {}

    can process with talk entry {
        if(visitor.respond){

            required_entities = -[entity_transition]->.edge.entities;
            redirect = -[redirect_transition]->;
            // std.out("redirect 1");
            // std.out(redirect);
            // std.out("visitor.respond");
            // std.out(visitor.respond);

            if(visitor.extracted_entities and !visitor.next_state){
                if(required_entities){
                    for entity in required_entities{
                        required = flow.check_required_entity(entity, visitor.extracted_entities.d::keys);
                        if(required == true){
                            // std.out("entity ext if");
                            // visitor.respond = true;
                            visitor.next_state = -[entity_transition(entities == entity)]->[0];
                        }
                        elif(visitor.predicted_intent){
                            // std.out("entity predict else");
                            visitor.next_state = -[intent_transition(intent == visitor.predicted_intent)]->[0];
                        }
                        elif(redirect){
                            // std.out("entity redirect else");
                            // visitor.respond = true;
                            visitor.next_state = -[redirect_transition]->[0];
                        }
                        else{
                            // std.out('NOTE: Can Process else ran 2!');
                        }
                    }
                }
                elif(visitor.predicted_intent){
                    // std.out("no entity predict else");
                    visitor.next_state = -[intent_transition(intent == visitor.predicted_intent)]->[0];
                }
                elif(redirect){
                    std.out("Or user used this one instead");
                    // std.out("no entity ext else");
                    // visitor.respond = true;
                    visitor.next_state = -[redirect_transition]->[0];
                }
                else{
                    // std.out('NOTE: Can Process else ran 3!');
                }
            }
            elif(visitor.predicted_intent and visitor.threshold ){
                // std.out("predict");
                // elif(visitor.predicted_intent and visitor.threshold and !visitor.next_state){
                // std.out(intent[0]['name']);
                // visitor.next_state = -[intent_transition(intent[0]['name'] == visitor.predicted_intent)]->[0];
                // visitor.respond = true;
                visitor.next_state = -[intent_transition(intent == visitor.predicted_intent)]->[0];
            }
            elif(redirect and !visitor.next_state){
                std.out("User used this as the next state");
                // elif(redirect){
                    // std.out("redirect");
                    // visitor.respond = true;
                visitor.next_state = -[redirect_transition]->[0];
            }
            else{
                // std.out('NOTE: Can Process else ran 1!');
                // visitor.next_state = null;
            }
        }
    }

    can nlg with talk entry {
        if (!visitor.respond && here.name != "dialog") {
            std.out("________________Generating Response with entry__________________");
            data = file.load_json(global.train_state_path);
            responses = [];
            for obj in data{ 
                if(here.name == obj["name"]){
                    responses = obj["responses"];
                    visitor.response = rand.choice(responses);
                }
            }
            report {
                "question": visitor.question,
                "name": here.name,
                "response": visitor.response
            };
            if(visitor.response == "this is the dialogue root"){
                std.out("__________________Can't Send this to user_______________________");
                visitor.response = null;
            }
            if(visitor.response){
                std.out("__We are sending the following response: ", visitor.response, "to user ", visitor.phone_number, here.name);
                spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
                visitor.response = null;
                std.out("________________________Finish Generating response_____________________-");
            }
        }
    }

    can cleanup with talk entry {
        intent_labels = -[intent_transition]->.edge.intent;
        // redirect_labels = -[redirect_transition]->.edge.name;

        // if(intent_labels.length == 0 or redirect_labels.length == 0){
        if(intent_labels.length == 0){
            // std.out('set to dialog prev_state');
            visitor.prev_state = global.dialog;
        }
        else{
            // std.out('set to info_jid prev_state');
            visitor.prev_state = here.info['jid'];
        }
        // std.out("visitor.prev_state\n\n");
        // std.out(visitor.prev_state);
        // std.out(here.name);

        spawn *(global.main_root) walker::maintainer( 
            prev_state = visitor.prev_state,
            // skip_state = visitor.skip_state,
            dialogue_context = visitor.dialogue_context
        );
    }
}

node dialog:dialogue_state{
    has name="dialog";

    can nlu with talk entry{
        ::classify_intent;
        ::extract_entities;
        ::business_logic;

        visitor.response = "this is the dialogue root";
    }

    can ver with talk entry{
        std.out("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
        std.out("we are at the dialog root", visitor.predicted_intent, visitor.dialogue_context);
        std.out("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    }
    
    // can process with talk entry{
    //     if
    // }
    // can nlg with talk entry{
    //     if (!visitor.respond) {
    //     // if (!visitor.respond and here.name != "dialog") {
    //         report {
    //             "question": visitor.question,
    //             "name": here.name,
    //             "response": visitor.response
    //         };
    //         // response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
    // visitor.response = null;
    //     }
    // }


}

node subscribe:dialogue_state{
    can nlu{}
    can subscribe with talk entry{
        visitor.dialogue_context["last_node"] = here.name;
        response = spawn here walker::subscribe(phone_number = visitor.phone_number);
        std.out(response);
        if(response["status_code"] == 200){
            ::generate_successful_response;
        }
        ::continue_report;
    }
    can nlg{}
}

node unsubscribe:dialogue_state{
    can nlu{}
    can unsubscribe with talk entry{
        visitor.dialogue_context["last_node"] = here.name;
        response = spawn here walker::unsubscribe(phone_number = visitor.phone_number);
        std.out(response);
        if(response["status_code"] == 200){
            ::generate_successful_response;
        }
        ::continue_report;
    }
    can nlg{}
}

node status:dialogue_state{
    can status with talk entry{
        visitor.dialogue_context["last_node"] = here.name;
        std.out("We need to design this state");
        ::continue_report;
    }
}

node traffic_alert:dialogue_state{
    can nlu{}
    can give_traffic_updates with talk entry{
        visitor.dialogue_context["last_node"] = here.name;
        response = latest.update();
        std.out(response);
        image = response["image_url"];
        document = response["document_url"];
        response = spawn here walker::send_image_message_with_url(media_url=image, phone_number=visitor.phone_number);
        std.out(response);
        response = spawn here walker::send_document_message_by_Url(media_url=document, phone_number=visitor.phone_number);
        std.out(response);
        ::continue_report;
    }
    can nlg{}
}

node traffic_report:dialogue_state{
    has needed_data = ["image", "location", "description"];
    has classifier_data = [];
    has data_2;
    
    can describe{
        // if(visitor.dialogue_context["description"]){
        //     visitor.dialogue_context["description"] += " "+visitor.question;
        // }else{
        //     visitor.dialogue_context["description"] += visitor.question;
        // }
        // if(!"description" in visitor.dialogue_context["recieved"]){
        //     visitor.dialogue_context["recieved"].list::append("description");
        // }

        if(!here.classifier_data){
            data_1 = file.load_json(global.train_tfn_ner_path);
            data_2  = file.load_json(global.bi_train_path);
            classifier_data.list::extend(data_2["traffic_report"]);
            classifier_data.list::extend(data_2["yes"]);
            classifier_data.list::extend(data_2["no"]);
        }
        best_answer = use.text_classify(text = visitor.question, classes = classifier_data);
        nn = best_answer['match_idx'];
        max_score = global.describe_score;
        std.out("____________________________________________________________________________________________________");
        std.out("Score ", best_answer['scores'][nn], " Match: ", classifier_data[nn]);
        std.out("____________________________________________________________________________________________________");
        if (best_answer['scores'][nn] > max_score){
            if(classifier_data[nn] in data_2["no"]){
                visitor.yes_or_no = "no";
            }
            elif(classifier_data[nn] in data_2["yes"]){
                visitor.yes_or_no = "yes";
            }
        }else{
            if(!"description" in visitor.dialogue_context["asked"]){
                visitor.dialogue_context["asked"].list::append("description");
            }
            if(!"description" in visitor.dialogue_context["recieved"]){
                visitor.dialogue_context["recieved"].list::append("description");
            }
            if(visitor.dialogue_context["description"]){
                visitor.dialogue_context["description"] += ". "+visitor.question;
            }else{
                visitor.dialogue_context["description"] += visitor.question;
            }
        }
    }

    can process with talk entry{
        visitor.dialogue_context["last_node"] = here.name;
        std.out("Processing cancelled");
    }

    can cancel_or_confirm{
        //get intent wether cancel or confirm
        //next if we don't have a sufficient socore we use last node and yes_or_no to decide where to go.
        visitor.right_away_transition = -[intent_transition(intent == "confirmation")]->;
    }

    can decide{
        std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        std.out("This is what was recieved", visitor.dialogue_context["recieved"], visitor.dialogue_context["asked"]);
        std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        std.out("lenght of asked: ", visitor.dialogue_context["asked"].length, "length of needed data: ", needed_data.length);
        std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        if(("image" in visitor.dialogue_context["recieved"]) && ("location" in visitor.dialogue_context["recieved"]) && ("description" in visitor.dialogue_context["recieved"])){
            ::cancel_or_confirm;
        }
        elif((!visitor.dialogue_context["recieved"]) || (!visitor.dialogue_context["asked"])){
            std.out("Fresh Meat.");
            choice = rand.choice(needed_data);
            std.out("Choice: ", choice);
            visitor.right_away_transition = -[intent_transition(intent == choice)]->;
        }
        elif(visitor.dialogue_context["asked"] && (visitor.dialogue_context["asked"].length < needed_data.length)){
            std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
            std.out("Normal Customer");
            std.out("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
            temporary_data = ["image", "location", "description"];
            tmp_data = [];
            tmp_data.list::extend(visitor.dialogue_context["asked"]);
            tmp_data.list::extend(visitor.dialogue_context["recieved"]);
            for i in needed_data{
                if(i in tmp_data){
                    temporary_data.list::remove(i);
                }else{
                    std.out("_______________Missing Information for the report________________________");
                    std.out(i, tmp_data, temporary_data);
                    std.out("_________________________________________________________________________");
                }
            }
            next_item = rand.choice(temporary_data);
            std.out("This is the question we are about to ask");
            visitor.right_away_transition = -[intent_transition(intent == next_item)]->;
            std.out("We successfully asked the correct question");
        }else{
            image = visitor.dialogue_context["image"];
            location = visitor.dialogue_context["location"];
            description = visitor.dialogue_context["description"];
            video = visitor.dialogue_context["video"];
            std.out("we got these: ", image, location, description, video);
            if(("image" in visitor.dialogue_context["recieved"]) && ("location" in visitor.dialogue_context["recieved"]) && ("description" in visitor.dialogue_context["recieved"])){
                // Logic to go to confirm report and also yes and no responses;
                std.out("We got all the information needed to confirm");
                ::cancel_or_confirm;
            }else{
                std.out("bad Customer");
                if(!image && !location){
                    std.out("_________________Generating no Image and Location Response___________________________________");
                    data = file.load_json(global.train_state_path);
                    responses = [];
                    for obj in data{ 
                        if("unanswered_question" == obj["name"]){
                            data = obj;
                        }
                    }
                    if("image_and_location" in data["responses"]){
                        responses = data["responses"]["image_and_location"];
                        visitor.response = rand.choice(responses);
                    }
                    response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
                    visitor.dialogue_context["repeat_id"] = response["messages"][0]["id"];
                    visitor.dialogue_context["repeat_report"] = true;
                    visitor.response = null;
                }
                elif(!image){
                    std.out("_________________Generating no Image Response___________________________________");
                    data = file.load_json(global.train_state_path);
                    responses = [];
                    for obj in data{ 
                        if("unanswered_question" == obj["name"]){
                            data = obj;
                        }
                    }
                    if("image_and_location" in data["responses"]){
                        responses = data["responses"]["image"];
                        visitor.response = rand.choice(responses);
                    }
                    response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
                    visitor.dialogue_context["repeat_id"] = response["messages"][0]["id"];
                    visitor.dialogue_context["repeat_report"] = true;
                    visitor.response = null;
                }
                elif(!location){
                    std.out("_________________Generating no Image and Location Response___________________________________");
                    data = file.load_json(global.train_state_path);
                    responses = [];
                    for obj in data{ 
                        if("unanswered_question" == obj["name"]){
                            data = obj;
                        }
                    }
                    if("image_and_location" in data["responses"]){
                        responses = data["responses"]["location"];
                        visitor.response = rand.choice(responses);
                    }
                    response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
                    visitor.dialogue_context["repeat_id"] = response["messages"][0]["id"];
                    visitor.dialogue_context["repeat_report"] = true;
                    visitor.response = null;
                }
                else{
                    std.out("This user is special they caused the only condition that should not happen to happen.");
                }
            }
        }
    }

    can nlu with talk entry {
        ::extract_entities;
        ::describe;
        ::decide;
    }
}

node location:dialogue_state{
    can location{
        // std.out("vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv");
        // std.out("We are on the location node");
        if(!("location" in visitor.dialogue_context["asked"])){
            visitor.dialogue_context["asked"].list::append("location");
        }
        visitor.dialogue_context["last_node"] = "location";
        // std.out("vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv");
    }

    // can process with talk entry{
    //     std.out("cancel processing");
    //     // visitor.next_state = global.dialog;
    // }

    can nlg{
        std.out("_________________xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx____________________");
    }

    can speak{
        std.out("_________________Generating location Response___________________________________");
        data = file.load_json(global.train_state_path);
        responses = [];
        for obj in data{ 
            if("ask" == obj["name"]){
                data = obj;
            }
        }
        if("location" in data["responses"]){
            responses = data["responses"]["location"];
            visitor.response = rand.choice(responses);
        }
        response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
        visitor.dialogue_context["repeat_id"] = response["messages"][0]["id"];
        visitor.dialogue_context["repeat_report"] = true;
        visitor.response = null;
        std.out("_________________Finished Generating location Response____________________________");
    }

    can nlu with talk entry {
        visitor.dialogue_context["last_node"] = here.name;
        ::location;
        ::nlg;
        ::speak;
    }
}

node description:dialogue_state{
    can describe{
        // std.out("PPPPPPPPPPPPPP___Description Node___PPPPPPPPPPPPPPPPPPPP");
        if(!("description" in visitor.dialogue_context["asked"])){
            visitor.dialogue_context["asked"].list::append("description");
        }
        visitor.dialogue_context["last_node"] = "description";
    }

    can nlg{
        std.out("_________________xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx____________________");
    }

    // can process with talk entry{
    //     std.out("Processing cancelled");
    //     // visitor.next_state = global.dialog;
    // }

    can speak{
        std.out("_________________Generating Description Response___________________________________");
        data = file.load_json(global.train_state_path);
        responses = [];
        for obj in data{ 
            if("ask" == obj["name"]){
                data = obj;
            }
        }
        if("description" in data["responses"]){
            responses = data["responses"]["description"];
            visitor.response = rand.choice(responses);
        }
        response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
        visitor.dialogue_context["repeat_id"] = response["messages"][0]["id"];
        visitor.dialogue_context["repeat_report"] = true;
        visitor.response = null;
        std.out("_________________Finished Generating Description Response____________________________");
    }

    can nlu with talk entry {
        ::describe;
        ::nlg;
        ::speak;
    }
}

node image:dialogue_state{
    can image{
        std.out("PPPPPPPPPPPPPP___Image Node___PPPPPPPPPPPPPPPPPPPP");
        if(!("image" in visitor.dialogue_context["asked"])){
            visitor.dialogue_context["asked"].list::append("image");
        }
        visitor.dialogue_context["last_node"] = "image";
    }

    can nlg{
        std.out("_________________xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx____________________");
    }

    // can process with talk entry{
    //     std.out("Processing cancelled");
    //     // visitor.next_state = global.dialog;
    // }

    can speak{
        std.out("_________________Generating image Response___________________________________");
        data = file.load_json(global.train_state_path);
        responses = [];
        for obj in data{ 
            if("ask" == obj["name"]){
                data = obj;
            }
        }
        if("image" in data["responses"]){
            responses = data["responses"]["image"];
            visitor.response = rand.choice(responses);
        }
        response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
        visitor.dialogue_context["repeat_id"] = response["messages"][0]["id"];
        visitor.dialogue_context["repeat_report"] = true;
        visitor.response = null;
        std.out("_________________Finished Generating image Response____________________________");
    }

    can nlu with talk entry {
        ::image;
        ::nlg;
        ::speak;
    }
}

node confirmation:dialogue_state{
    can classify with talk entry{
        data = file.load_json(global.bi_train_path);
        classes = [];
        intent = "";
        match = "";
        classes.list::extend(data["yes"]);
        classes.list::extend(data["no"]);
        best_answer = use.text_classify(text = visitor.question, classes = classes);
        nn = best_answer['match_idx'];
        max_score = global.conv_score;
        if (best_answer['scores'][nn] > max_score){
            max_score = best_answer['scores'][nn];
            std.out("classified intent: ", classes[nn]);
            if(classes[nn] in data["yes"]){
                visitor.yes_or_no = "yes";
            }
            if(classes[nn] in data["no"]){
                visitor.yes_or_no = "no";
            }
        }
        std.out(visitor.yes_or_no);
    }

    can process with talk entry{
        std.out("Processing cancelled");
    }

    can confirm with talk entry{
        std.out("PPPPPPPPPPPPPP___Confirmation Node___PPPPPPPPPPPPPPPPPPPP");
        if(visitor.yes_or_no == "yes"){
            std.out("_________________Generating confirm with confirm request___________________________________");
            data = file.load_json(global.train_state_path);
            responses = [];
            for obj in data{ 
                if("confirm_user" == obj["name"]){
                    data = obj;
                }
            }
            if("yes" in data["responses"]){
                responses = data["responses"]["yes"];
                visitor.response = rand.choice(responses);
            }
            response = spawn here walker::traffic_report(description = visitor.dialogue_context["description"]);
            std.out(response);
            if("case_reference_number" in response["response"]){
                visitor.dialogue_context["case_number"] = response["response"]["case_reference_number"];
            }
            std.out("_____________before_____________________: ", visitor.response);
            visitor.response = visitor.response.str::replace("{case_number}", visitor.dialogue_context["case_number"]);
            std.out("_____________after_____________________: ", visitor.response);
            response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
            visitor.response = null;
            visitor.dialogue_context = {
                "image": [],
                "video": [],
                "audio": [],
                "description": "",
                "location": [],
                "asked": [],
                "last_node": "",
                "recieved": [],
                "case_number": visitor.dialogue_context["case_number"]
            };
            visitor.yes_or_no = null;
            visitor.right_away_transition = null;
        }
        elif(visitor.yes_or_no == "no"){
            std.out("_________________Generating Confirm with no confirm request___________________________________");
            data = file.load_json(global.train_state_path);
            responses = [];
            for obj in data{ 
                if("confirm_user" == obj["name"]){
                    data = obj;
                }
            }
            if("no" in data["responses"]){
                responses = data["responses"]["no"];
                visitor.response = rand.choice(responses);
            }
            response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
            visitor.response = null;
            visitor.yes_or_no = null;
            visitor.right_away_transition = null;
            visitor.dialogue_context = {
                "image": [],
                "video": [],
                "audio": [],
                "description": "",
                "location": [],
                "asked": [],
                "last_node": "",
                "recieved": [],
                "case_number": ""
            };
            std.out("_________________Generating Confirm with no confirm request___________________________________");
        }
        else{
            std.out("_________________Generating default Confirm request___________________________________");
            data = file.load_json(global.train_state_path);
            responses = [];
            for obj in data{ 
                if("confirm_user" == obj["name"]){
                    data = obj;
                }
            }
            if("default" in data["responses"]){
                responses = data["responses"]["default"];
                visitor.response = rand.choice(responses);
            }
            response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
            visitor.response = null;
            visitor.right_away_transition = here;
        }
        std.out("PPPPPPPPPPPPPP___Confirmation Node___PPPPPPPPPPPPPPPPPPPP");
    }
}

node cancellation:dialogue_state{
    can classify with talk entry{
        visitor.dialogue_context["last_node"] = here.name;
        data = file.load_json(global.bi_train_path);
        classes = [];
        intent = "";
        match = "";
        classes.list::extend(data["yes"]);
        classes.list::extend(data["no"]);
        best_answer = use.text_classify(text = visitor.question, classes = classes);
        nn = best_answer['match_idx'];
        max_score = global.conv_score;
        if (best_answer['scores'][nn] > max_score){
            max_score = best_answer['scores'][nn];
            std.out("classified intent: ", classes[nn]);
            if(classes[nn] in data["yes"]){
                visitor.yes_or_no = "yes";
            }
            if(classes[nn] in data["no"]){
                visitor.yes_or_no = "no";
            }
        }
        std.out(visitor.yes_or_no);
    }

    can process with talk entry{
        std.out("Processing cancelled");
    }

    can cancel with talk entry{
        std.out("PPPPPPPPPPPPPP___Cancellation Node___PPPPPPPPPPPPPPPPPPPP");
        if(!visitor.dialogue_context["recieved"]){
            std.out("_________________Generating Cancell without nothing recieved request___________________________________");
            data = file.load_json(global.train_state_path);
            responses = [];
            for obj in data{ 
                if("cancel_user" == obj["name"]){
                    data = obj;
                }
            }
            if("no_report" in data["responses"]){
                responses = data["responses"]["no_report"];
                visitor.response = rand.choice(responses);
            }
            response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
            visitor.response = null;
        }
        elif(visitor.dialogue_context["recieved"] && visitor.yes_or_no != "yes"){
            std.out("_________________Generating Cancell default request___________________________________");
            data = file.load_json(global.train_state_path);
            responses = [];
            for obj in data{ 
                if("cancel_user" == obj["name"]){
                    data = obj;
                }
            }
            if("default" in data["responses"]){
                responses = data["responses"]["default"];
                visitor.response = rand.choice(responses);
            }
            response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
            visitor.response = null;
            visitor.right_away_transition = here;
        }
        elif(visitor.yes_or_no == "no"){
            std.out("_________________Generating Cancell without no cancell request___________________________________");
            data = file.load_json(global.train_state_path);
            responses = [];
            for obj in data{ 
                if("cancel_user" == obj["name"]){
                    data = obj;
                }
            }
            if("no" in data["responses"]){
                responses = data["responses"]["no"];
                visitor.response = rand.choice(responses);
            }
            response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
            visitor.response = null;
            visitor.yes_or_no = null;
            visitor.right_away_transition = null;
        }
        elif(visitor.yes_or_no == "yes"){
            std.out("_________________Generating Cancell without yes cancell request___________________________________");
            data = file.load_json(global.train_state_path);
            responses = [];
            for obj in data{ 
                if("cancel_user" == obj["name"]){
                    data = obj;
                }
            }
            if("yes" in data["responses"]){
                responses = data["responses"]["yes"];
                visitor.response = rand.choice(responses);
            }
            response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
            visitor.response = null;
            visitor.dialogue_context = {
                "image": [],
                "video": [],
                "audio": [],
                "description": "",
                "location": [],
                "asked": [],
                "last_node": "",
                "recieved": [],
                "case_number": ""
            };
            visitor.yes_or_no = null;
            visitor.right_away_transition = null;
        }
        else{
            std.out("_________________________User made a rare exeption___________________________");
            data = file.load_json(global.train_state_path);
            responses = [];
            for obj in data{ 
                if("cancel_user" == obj["name"]){
                    data = obj;
                }
            }
            if("default" in data["responses"]){
                responses = data["responses"]["default"];
                visitor.response = rand.choice(responses);
            }
            response = spawn here walker::send_message(phone_number = visitor.phone_number, answer = visitor.response);
            visitor.response = null;
            visitor.right_away_transition = here;
        }
        std.out("PPPPPPPPPPPPPP___Cancellation Node___PPPPPPPPPPPPPPPPPPPP");
    }
}

node faqs:dialogue_state{
    has name;
    has classifier;

    can use.qa_classify;

    can nlu with talk entry{
        answers = -[faq]->.answer;
        best_answer = use.qa_classify(
            text = visitor.question,
            classes = answers
        );
        max_score = global.faq_score;
        nn = best_answer['match_idx'];
        std.log( "FAQ: " + " MATCH: ",best_answer['match'],"   SCORE: " ,best_answer['scores'][nn]);

        if (best_answer['scores'][nn] > max_score){
            visitor.response = best_answer['match'];
        }
    }

    can process with talk entry{
        visitor.dialogue_context["last_node"] = here.name;
        if(visitor.prev_state){
            // std.out('fr process if 1');
            visitor.next_state = *(visitor.prev_state);
            // std.out("check with previous state visitor.next_state\n");
            // std.out(visitor.next_state);
            // visitor.next_state= -[intent_transition(intent==visitor.prev_state)]->;
        }
        else{ 
            // std.out('fr process if 2');
            visitor.next_state = global.dialog;
        }
    }
    can cleanup with talk entry{

    }

}

node faq{
    has name;
    has answer;
}


node conv_root;

node user {
    has id;
    has prev_state = null;
    // has skip_state = null;
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
        "repeat_id": ""
    };

    can start_conv with talk entry {
        if (here.prev_state == null) {
            here.prev_state = global.dialog;
        }
        visitor.cont_state = here.prev_state;
        visitor.dialogue_context = here.dialogue_context;
        // visitor.skip_state = here.skip_state;
    }

    can update_with_conv with maintainer entry {
        here.prev_state = visitor.prev_state;
        // here.skip_state = visitor.skip_state;
        here.dialogue_context = visitor.dialogue_context;
    }
}

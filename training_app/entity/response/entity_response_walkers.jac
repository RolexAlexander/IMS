walker create_entity_response{
    has jid;
    has response;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_entities]-> node::_entities;
    // _entities: take --> node::_entity;
    _entities: take -[_entity(id==jid)]-> node::_entity else: report:custom = {"error": "jid not found!"};
    _entity{
        take -[_prompts]-> node::_prompts else { 
            spawn here +[_prompts]+> node::_prompts; 
            take -[_prompts]-> node::_prompts;
        }
    }
    _prompts{
        response_list = -[_prompt]->.response;
        if !(response){
            report:custom = "Missing required!";
        }
        elif(response in response_list){
            report:custom = {"error": "response already exist! " + response};
        }
        else{
            nd = spawn node::_prompt(response = response);
            here +[_prompt(id=nd.info['jid'])]+>nd;
            report:custom = {"jid":nd.info['jid'], "response": nd.context.response};
        }
    }

}

walker update_entity_response{
    has jid;
    has response;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_entities]-> node::_entities;
    _entities: take -[_entity]-> node::_entity;
    _entity: take -[_prompts]-> node::_prompts;
    _prompts{
        response_list = -[_prompt]->.response;
        if !(response){
            report:custom = "Missing required!";
        }
        elif(response in response_list){
            report:custom = {"error": "response already exist! " + response};
        }
        else: take -[_prompt(id==jid)]-> node::_prompt else: report:custom = {"error": "jid not found!"};
    }
    _prompt{
        here.response = response;
        report:custom = {"jid":here.info['jid'], "response": here.response};
    }
}

walker list_entity_response{
    has payload = [];
    has intents;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    // _intent: take --> node::_entities;
    _intent{
        intents = here.intent;
        take -[_entities]-> node::_entities;
    }
    _entities: take -[_entity]-> node::_entity;
    _entity: take -[_prompts]-> node::_prompts;
    _prompts: take -[_prompt]-> node::_prompt;
    _prompt{
        data={};
        data['jid']=here.info['jid'];
        data['intent']=intents;
        data['response']=here.response;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = payload;
        }
        else: report:custom = {"error": "No response found!"};   
    }
}

walker get_entity_response{
    has jid;
    has payload = [];

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent: take -[_entities]-> node::_entities;
    _entities: take -[_entity]-> node::_entity;
    _entity: take -[_prompts]-> node::_prompts;
    _prompts: take -[_prompt]-> node::_prompt;
    _prompt{
        entity = <-[_prompt]-<-[_prompts]-.entity;
        data={};
        data['jid']=here.info['jid'];
        data['intent']=entity[0];
        data['response']=here.response;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = {"payload": payload, "error": ""};  
        }
        else: report:custom = {"payload": [], "error": "No Entity Response Found!"};  
    }
}

walker get_entity_response_list{
    has jid;
    has anchor payload = [];

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent: take -[_entities]-> node::_entities;
    _entities: take -[_entity]-> node::_entity;
    _entity: take -[_prompts]-> node::_prompts;
    _prompts{
        res = -[_prompt]->.response;
        payload.list::append(res);
    }
    with exit{
        if(payload){
            report:custom = payload;
        }
        else: report:custom = {"error": "No response found!"};   
    }
}

walker delete_entity_response{
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_entities]-> node::_entities;
    _entities: take -[_entity]-> node::_entity;
    _entity: take -[_prompts]-> node::_prompts;
    _prompts: take -[_prompt(id==jid)]-> node::_prompt else: report:custom = {"error": "jid not found!"};
    _prompt{
        report:custom = "response deleted!";
        destroy here;
        disengage;
    }
}


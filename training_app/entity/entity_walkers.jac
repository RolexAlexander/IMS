walker create_intent_entity{
    has jid;
    has entity;
    has anchor load_response;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent{
        take -[_entities]-> node::_entities else { 
            spawn here +[_entities]+> node::_entities; 
            take -[_entities]-> node::_entities;
        }
    }
    _entities{
        entity_list = -[_entity]->.entity;
        if !(entity){
            report:custom = "Missing required!";
        }
        elif(entity in entity_list){
            report:custom = {"error": "entity already exist! " + entity};
        }
        else{
            nd = spawn node::_entity(entity = entity);
            here +[_entity(id=nd.info['jid'])]+>nd;
            report:custom = {"jid":nd.info['jid'], "entity": nd.context.entity};
            if (load_response){
                for response in load_response[entity]{
                    // std.out("entity response\n\n");
                    // std.out(response);
                    spawn *(global.main_root) walker::create_entity_response(jid=nd.info['jid'], response=response);
                }
            }
        }
    }
}

walker update_intent_entity{
    has jid;
    has entity;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_entities]-> node::_entities;
    _entities{ 
        entity_list = -[_entity]->.entity;

        if !(entity){
            report:custom = "Missing required!";
        }
        elif(entity in entity_list){
            report:custom = {"error": "entity already exist! " + entity};
        }
        else: take -[_entity(id==jid)]->node::_entity else: report:custom = {"error": "jid not found!"};

    }
    _entity{
        here.entity = entity;
        report:custom = custom = {"jid":here.info['jid'], "entity": here.entity};
    }
}

walker list_intent_entity{
    has payload = [];

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent else: report:custom = {"error": "intent not found!"};
    _intent: take -[_entities]-> node::_entities else: report:custom = {"error": "entity not found!"};
    _entities: take -[_entity]-> node::_entity;
    _entity{
        data={};
        data['jid']=here.info['jid'];
        data['entity']=here.entity;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = {"payload": payload, "error": ""};  
        }
        else: report:custom = {"payload": [], "error": "No Entity Found!"};  
    }
}

walker get_intent_entity{
    has payload = [];
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent: take -[_entities]-> node::_entities else: report:custom = {"error": "entity not found!"};
    _entities: take -[_entity]-> node::_entity;
    _entity{
        data={};
        data['jid']=here.info['jid'];
        data['entity']=here.entity;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = {"payload": payload, "error": ""};  
        }
        else: report:custom = {"payload": [], "error": "No Entity Found!"};  
        
    }
}

walker get_intent_entity_list{
    has anchor payload = [];
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent: take -[_entities]-> node::_entities else: report:custom = {"error": "entity not found!"};
    _entities: take -[_entity]-> node::_entity;
    _entity{
        // data={};
        // data['jid']=here.info['jid'];
        // data['entity']=here.entity;
        payload.list::append(here.entity);
    }
    with exit{
        if(payload){
            report:custom = {"payload": payload, "error": ""};  
        }
        else: report:custom = {"payload": [], "error": "No Entity Found!"};  
        
    }
}

walker delete_intent_entity{
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_entities]-> node::_entities;
    _entities: take -[_entity(id==jid)]-> node::_entity else: report:custom = {"error": "jid not found!"};
    _entity{
        report:custom = "entity deleted!";
        destroy here;
        disengage;
    }
}

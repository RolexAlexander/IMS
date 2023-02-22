walker create_intent{
    has intent;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents{
        intent_list = -[_intent]->.intent;
        if !(intent){
            report:custom = {"payload": [], "error": "Intent required!"};  
        }
        elif(intent in intent_list){
            report:custom = {"error": "Intent already exist! " + intent, "payload": []};
        }
        else{
            nd = spawn node::_intent(intent = intent);
            here +[_intent(id=nd.info['jid'])]+>nd;
            payload = {"jid":nd.info['jid'], "intent": nd.context.intent};
            report:custom = {"payload": [payload], "error": ""};  
        }
    }
}

walker update_intent{
    has intent;
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents{ 
        intent_list = -[_intent]->.intent;
        std.out(intent_list);
        if !(intent){
            report:custom = "Missing required!";
        }
        elif(intent in intent_list){
            report:custom = {"error": "Intent already exist! " + intent};
        }
        else: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    }
    _intent{
        here.intent = intent;
        report:custom = custom = {"jid":here.info['jid'], "intent": here.intent};
    }
}

walker list_intent{
    has private payload = [];
    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take --> node::_intent;
    _intent{
        data = {};
        data['jid']=here.info['jid'];
        data["intent"]=here.intent;
        utterance_list = -[utterance_root]->;
        if(utterance_list): payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = {"payload": payload, "error": ""};  
        }
        else: report:custom = {"payload": [], "error": "No Intent Found!"};  
        
    }
}

walker list_all_intent{
    has private payload = [];
    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take --> node::_intent;
    _intent{
        data = {};
        data['jid']=here.info['jid'];
        data["intent"]=here.intent;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = {"payload": payload, "error": ""};  
        }
        else: report:custom = {"payload": [], "error": "No Intent Found!"};  
    }
}

walker get_intent{
    has jid;
    has private payload = [];
    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent;
    _intent{
        data = {};
        data['jid']=here.info['jid'];
        data["intent"]=here.intent;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = {"payload": payload, "error": ""};  
        }
        else: report:custom = {"payload": [], "error": "No Intent Found!"};  
    }
}

walker delete_intent{
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent{
        report:custom = "Intent deleted!";
        destroy here;
        disengage;
    }
}

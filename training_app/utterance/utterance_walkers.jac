walker create_intent_utterance{
    has jid;
    has utterance;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent{
        take -[_utterances]-> node::_utterances else { 
            spawn here +[_utterances]+> node::_utterances; 
            take -[_utterances]-> node::_utterances;
        }
    }
    _utterances{
        utterance_list = -[_utterance]->.utterance;
        if !(utterance){
            report:custom = "Missing required!";
        }
        elif(utterance in utterance_list){
            report:custom = {"error": "Utterance already exist! " + utterance};
        }
        else{
            nd = spawn node::_utterance(utterance = utterance);
            here +[_utterance(id=nd.info['jid'])]+>nd;
            report:custom = {"jid":nd.info['jid'], "utterance": nd.context.utterance};
        }
    }
}

walker update_intent_utterance{
    has jid;
    has utterance;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_utterances]-> node::_utterances;
    _utterances{ 
        utterance_list = -[_utterance]->.utterance;

        if !(utterance){
            report:custom = "Missing required!";
        }
        elif(utterance in utterance_list){
            report:custom = {"error": "Utterance already exist! " + utterance};
        }
        else: take -[_utterance(id==jid)]->node::_utterance else: report:custom = {"error": "jid not found!"};

    }
    _utterance{
        here.utterance = utterance;
        report:custom = custom = {"jid":here.info['jid'], "utterance": here.utterance};
    }
}

walker list_intent_utterance{
    has payload = [];

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent else: report:custom = {"error": "intent not found!"};
    _intent: take -[_utterances]-> node::_utterances else: report:custom = {"error": "Utterance not found!"};
    _utterances: take --> node::_utterance;
    _utterance{
        data={};
        data['jid']=here.info['jid'];
        data['utterance']=here.utterance;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = payload;
        }
        else: report:custom = {"error": "No utterance found!"};
        
    }
}

walker get_intent_utterance{
    has payload = [];
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent: take -[_utterances]-> node::_utterances else: report:custom = {"error": "Utterance not found!"};
    _utterances: take --> node::_utterance;
    _utterance{
        data={};
        data['jid']=here.info['jid'];
        data['utterance']=here.utterance;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = {"payload": payload, "error": ""};  
        }
        else: report:custom = {"payload": [], "error": "No Utterance Found!"};  
    }
}

walker delete_intent_utterance{
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_utterances]-> node::_utterances;
    _utterances: take -[_utterance(id==jid)]-> node::_utterance else: report:custom = {"error": "jid not found!"};
    _utterance{
        report:custom = "Utterance deleted!";
        destroy here;
        disengage;
    }
}

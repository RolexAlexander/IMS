
## response
walker create_intent_response{
    has jid;
    has response;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent{
        take -[_responses]-> node::_responses else { 
            spawn here +[_responses]+> node::_responses; 
            take -[_responses]-> node::_responses;
        }
    }
    _responses{
        response_list = -[_response]->.response;
        if !(response){
            report:custom = "Missing required!";
        }
        elif(response in response_list){
            report:custom = {"error": "response already exist! " + response};
        }
        else{
            nd = spawn node::_response(response = response);
            here +[_response(id=nd.info['jid'])]+>nd;
            report:custom = {"jid":nd.info['jid'], "response": nd.context.response};
        }
    }
}

walker update_intent_response{
    has jid;
    has response;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_responses]-> node::_responses;
    _responses{ 
        response_list = -[_response]->.response;

        if !(response){
            report:custom = "Missing required!";
        }
        elif(response in response_list){
            report:custom = {"error": "response already exist! " + response};
        }
        else: take -[_response(id==jid)]->node::_response else: report:custom = {"error": "jid not found!"};

    }
    _response{
        here.response = response;
        report:custom = custom = {"jid":here.info['jid'], "response": here.response};
    }
}

walker list_intent_response{
    has payload = [];

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent else: report:custom = {"error": "intent not found!"};
    _intent: take -[_responses]-> node::_responses else: report:custom = {"error": "response not found!"};
    _responses: take -[_response]-> node::_response;
    _response{
        intent = <-[_response]-<-[_responses]-.intent;
        data={};
        data['jid']=here.info['jid'];
        data['intent']=intent[0];
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

walker get_intent_response{
    has payload = [];
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent: take -[_responses]-> node::_responses else: report:custom = {"error": "response not found!"};
    _responses: take -[_response]-> node::_response;
    _response{
        intent = <-[_response]-<-[_responses]-.intent;
        data={};
        data['jid']=here.info['jid'];
        data['intent']=intent[0];
        data['response']=here.response;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = {"payload": payload, "error": ""};  
        }
        else: report:custom = {"payload": [], "error": "No Response Found!"};  
        
    }
}

walker get_intent_response_list{
    has anchor payload = [];
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent: take -[_responses]-> node::_responses else: report:custom = {"error": "response not found!"};
    _responses: take --> node::_response;
    _response{
        // data={};
        // data['jid']=here.info['jid'];
        // data['response']=here.response;
        payload.list::append(here.response);
    }
    with exit{
        if(payload){
            report:custom = payload;
        }
        else: report:custom = {"error": "No response found!"};
        
    }
}

walker delete_intent_response{
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_responses]-> node::_responses;
    _responses: take -[_response(id==jid)]-> node::_response else: report:custom = {"error": "jid not found!"};
    _response{
        report:custom = "response deleted!";
        destroy here;
        disengage;
    }
}
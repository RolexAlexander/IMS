
## resource
walker create_variable{
    has jid;
    has variable;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_resource(id==jid)]-> node::_resource else: report:custom = {"error": "jid not found!"};
    _resource{
        variable_list = -[_variable]->.variable;
        if !(variable){
            report:custom = "Missing required!";
        }
        elif(variable in variable_list){
            report:custom = {"error": "variable already exist! " + variable};
        }
        else{
            nd = spawn node::_variable(variable = variable);
            here +[_variable(id=nd.info['jid'])]+>nd;
            report:custom = {"jid":nd.info['jid'], "variable": nd.context.variable};
        }
    }
}

walker update_variable{
    has jid;
    has variable;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_resource]-> node::_resource;
    _resource{ 
        variable_list = -[_variable]->.variable;

        if !(variable){
            report:custom = "Missing required!";
        }
        elif(variable in variable_list){
            report:custom = {"error": "variable already exist! " + variable};
        }
        else: take -[_variable(id==jid)]->node::_variable else: report:custom = {"error": "jid not found!"};

    }
    _variable{
        here.variable = variable;
        report:custom = custom = {"jid":here.info['jid'], "variable": here.variable};
    }
}

walker list_variable{
    has payload = [];

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent else: report:custom = {"error": "intent not found!"};
    _intent: take -[_resource]-> node::_resource else: report:custom = {"error": "variable not found!"};
    _resource: take -[_variable]-> node::_variable;
    _variable{
        data={};
        data['jid']=here.info['jid'];
        data['variable']=here.variable;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = payload;
        }
        else: report:custom = {"error": "No variable found!"};
        
    }
}

walker get_variable{
    has payload = [];
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent: take -[_resource]-> node::_resource else: report:custom = {"error": "variable not found!"};
    _resource: take -[_variable]-> node::_variable;
    _variable{
        data={};
        data['jid']=here.info['jid'];
        data['variable']=here.variable;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = payload;
        }
        else: report:custom = {"error": "No variable found!"};
        
    }
}

walker get_variable_list{
    has anchor payload = [];
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent: take -[_resource]-> node::_resource else: report:custom = {"error": "variable not found!"};
    _resource: take -[_variable]-> node::_variable;
    _variable{
        payload.list::append(here.variable);
    }
    with exit{
        if(payload){
            report:custom = payload;
        }
        else: report:custom = {"error": "No variable found!"};
        
    }
}

walker delete_variable{
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_resource]-> node::_resource;
    _resource: take -[_variable(id==jid)]-> node::_variable else: report:custom = {"error": "jid not found!"};
    _variable{
        report:custom = "variable deleted!";
        destroy here;
        disengage;
    }
}

## info item root
walker create_intent_resource_root{
    has anchor jid;
    has resource;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent{
        resource_list = -[_resource]->.resource;
        if !(resource){
            report:custom = "Missing required!";
        }
        elif(resource in resource_list){
            report:custom = {"error": "resource already exist! " + resource};
        }
        elif(resource_list.length >= 1){
            report:custom = {"error": "more than one resource exist! Please update the previous one." + resource_list[0].str};
        }
        else{
            nd = spawn node::_resource(resource = resource);
            here +[_resource(id=nd.info['jid'])]+>nd;
            report:custom = {"jid":nd.info['jid'], "resource": nd.context.resource};
            std.out("nd.info['jid']");
            std.out(nd.info['jid']);
        }
    }
}

walker update_intent_resource_root{
    has jid;
    has resource;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent{
        resource_list = -[_resource]->.resource;
        if !(resource){
            report:custom = "Missing required!";
        }
        elif(resource in resource_list){
            report:custom = {"error": "resource already exist! " + resource};
        }
        else{
            take -[_resource(id==jid)]-> node::_resource else: report:custom = {"error": "jid not found!"};
        }
    }
    _resource{
        here.resource = resource;
        report:custom = custom = {"jid":here.info['jid'], "resource": here.resource};
    }
}

walker list_intent_resource_root{
    has payload = [];

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_resource]-> node::_resource;
    _resource{
        data = {};
        data['jid']=here.info['jid'];
        data["resource"]=here.resource;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = payload;
        }
        else: report:custom = {"error": "No resource found!"};
    }
}

walker get_intent_resource_root{
    has payload = [];
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent;
    _intent: take -[_resource]-> node::_resource;
    _resource{
        data = {};
        data['jid']=here.info['jid'];
        data["resource"]=here.resource;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = payload;
        }
        else: report:custom = {"error": "No resource found!"};
    }
}

walker get_intent_resource_root_str{
    has anchor payload = "";
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent;
    _intent: take -[_resource]-> node::_resource;
    _resource{
        // data = {};
        // data['jid']=here.info['jid'];
        // data["resource"]=here.resource;
        // payload.list::append(data);
        payload=here.resource;
    }
    with exit{
        if(payload){
            report:custom = payload;
        }
        else: report:custom = {"error": "No resource found!"};
    }
}

walker delete_intent_resource_root{
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_resource(id==jid)]-> node::_resource else: report:custom = {"error": "jid not found!"};
    _resource{
        report:custom = "resource deleted!";
        destroy here;
        disengage;
    }
}



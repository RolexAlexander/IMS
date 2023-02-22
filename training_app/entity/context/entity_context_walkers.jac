// walker create_entity_context{
//     has jid;
//     has entity_value;
//     has utterance;

//     root: take -[_train]-> node::_train;
//     _train: take -[_intents]-> node::_intents;
//     _intents: take -[_intent]-> node::_intent;
//     _intent: take -[_entities]-> node::_entities;
//     _entities: take -[_entity(id==jid)]-> node::_entity else: report:custom = {"error": "jid not found!"};
//     _entity{
//         take -[entity_context_root_t]-> node::entity_context_root_t else { 
//             spawn here +[entity_context_root_t]+> node::entity_context_root_t; 
//             take -[entity_context_root_t]-> node::entity_context_root_t;
//         }
//     }
//     entity_context_root_t{
//         utterance_list = -[entity_context_t]->.utterance;
//         entity_value_list = -[entity_context_t]->.entity_value;
//         std.out(utterance_list);
//         std.out(entity_value_list);
//         if !(entity_value and utterance){
//             report:custom = "Missing required!";
//         }
//         elif(utterance in utterance_list){
//             report:custom = {"error": "utterance already exist! " + utterance};
//         }
//         elif(entity_value in entity_value_list and utterance in utterance_list){
//             report:custom = {"error": "utterance and entity already exist! " + entity_value};
//         }
//         else{
//             nd = spawn node::entity_context_t(utterance = utterance, entity_value= entity_value);
//             here +[entity_context_t(id=nd.info['jid'])]+>nd;
//             report:custom = {"jid":nd.info['jid'], "utterance": nd.context.utterance, "entity_value": nd.context.entity_value};
//         }
//     }
// }

// walker update_entity_context{
//     has jid;
//     has entity_value;
//     has utterance;

//     root: take -[_train]-> node::_train;
//     _train: take -[_intents]-> node::_intents;
//     _intents: take -[_intent]-> node::_intent;
//     _intent: take -[_entities]-> node::_entities;
//     _entities: take -[_entity]-> node::_entity;
//     _entity: take -[entity_context_root_t]-> node::entity_context_root_t;
//     entity_context_root_t{
//         utterance_list = -[entity_context_t]->.utterance;
//         entity_value_list = -[entity_context_t]->.entity_value;
//         if !(entity_value or utterance){
//             report:custom = "Missing required!";
//         }
//         elif(utterance in utterance_list){
//             report:custom = {"error": "utterance already exist! " + utterance};
//         }
//         elif(entity_value in entity_value_list){
//             report:custom = {"error": "entity_value already exist! " + entity_value};
//         }
//         else: take -[entity_context_t(id==jid)]-> node::entity_context_t else: report:custom = {"error": "jid not found!"};
//     }
//     entity_context_t{
//         if(utterance): here.utterance = utterance;
//         if(entity_value): here.entity_value = entity_value;
//         report:custom = {"jid":here.info['jid'], "utterance": here.utterance, "entity_value": here.entity_value};
//     }
// }

// walker list_entity_context{
//     has payload = [];

//     root: take -[_train]-> node::_train;
//     _train: take -[_intents]-> node::_intents;
//     _intents: take -[_intent]-> node::_intent;
//     _intent: take -[_entities]-> node::_entities;
//     _entities: take -[_entity]-> node::_entity;
//     _entity: take -[entity_context_root_t]-> node::entity_context_root_t;
//     entity_context_root_t: take -[entity_context_t]-> node:: entity_context_t;
//     entity_context_t{
//         data={};
//         data['jid']=here.info['jid'];
//         data['entity_value']=here.entity_value;
//         data['utterance']=here.utterance;
//         payload.list::append(data);


//         // entity = <-[entity_context_t]-<-[entity_context_root_t]-.entity;
//         // utt = here.utterance;
//         // value = '['+here.entity_value.str+']'+'('+entity[0].str+')';
//         // utt.str::replace(here.entity_value, value);
//         // payload.list::append(utt);
//     }
//     with exit{
//         if(payload){
//             report:custom = payload;
//         }
//         else: report:custom = {"error": "No context found!"};
//     }
// }

// walker get_entity_context{
//     has payload = [];
//     has jid;

//     root: take -[_train]-> node::_train;
//     _train: take -[_intents]-> node::_intents;
//     _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
//     _intent: take -[_entities]-> node::_entities;
//     _entities: take -[_entity]-> node::_entity;
//     _entity: take -[entity_context_root_t]-> node::entity_context_root_t;
//     entity_context_root_t: take -[entity_context_t]-> node:: entity_context_t;
//     entity_context_t{
//         entities = <-[entity_context_t]-<-[entity_context_root_t]-.entity;
//         data={};
//         data['jid']=here.info['jid'];
//         data['entity']= entities[0];
//         data['entity_value']=here.entity_value;
//         data['utterance']=here.utterance;
//         payload.list::append(data);
//     }
//     with exit{
//         if(payload){
//             report:custom = {"payload": payload, "error": ""};  
//         }
//         else: report:custom = {"payload": [], "error": "No Entity Context Found!"};  
        
//     }
// }

// walker delete_entity_context{
//     has jid;

//     root: take -[_train]-> node::_train;
//     _train: take -[_intents]-> node::_intents;
//     _intents: take -[_intent]-> node::_intent;
//     _intent: take -[_entities]-> node::_entities;
//     _entities: take -[_entity]-> node::_entity;
//     _entity: take -[entity_context_root_t]-> node::entity_context_root_t;
//     entity_context_root_t: take -[entity_context_t(id==jid)]-> node::entity_context_t else: report:custom = {"error": "jid not found!"};
//     entity_context_t{
//         report:custom = "response deleted!";
//         destroy here;
//         disengage;
//     }
// }


walker create_entity_context{
    has jid;
    has entity_type;
    has entity_value;
    has utterance;

    can local.entity_value;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent{
        take -[_contexts]-> node::_contexts else {
            spawn here +[_contexts]+> node::_contexts;
            take -[_contexts]-> node::_contexts;
        }
    }
    _contexts{
        utterance_list = -[_context]->.utterance;
        entity_value_list = -[_context]->.entity_value;
        
        if !( utterance ){
            report:custom = "Missing required parameter!";
        }

        // elif(entity_value not in entity_value_list and utterance in utterance_list){
        elif(utterance in utterance_list){
            std.out(entity_value);
            std.out(utterance);
            take -[_context]-> node::_context;
        }
        else{
            utt = utterance;

            if!(entity_type){
                tfm = local.entity_value( utterance ,null);
                std.out("tfm\n");
                std.out(tfm);

                nd = spawn node::_context(utterance= tfm[0].utterance, entity_type=tfm[0].entity, entity_value= tfm[0].value);
                here +[_context(id=nd.info['jid'])]+>nd;
                report:custom = {"jid":nd.info['jid'], "utterance": nd.context.utterance, "entity_type": nd.context.entity_type, "entity_value": nd.context.entity_value};

            }
            else{
                nd = spawn node::_context(utterance = utt, entity_type=[entity_type], entity_value= [entity_value]);
                here +[_context(id=nd.info['jid'])]+>nd;
                report:custom = {"jid":nd.info['jid'], "utterance": nd.context.utterance, "entity_type": nd.context.entity_type, "entity_value": nd.context.entity_value};
            }
        }
    }
    _context{
        if(here.utterance == utterance){
            std.out("utterance match");
            std.out(utterance);
            tfm = local.entity_value( utterance ,null);


            spawn *(global.main_root) walker::update_entity_context(jid= here.info['jid'], utterance= utterance, entity_type=tfm[0].entity, entity_value= tfm[0].value);
        }
    }
}

walker update_entity_context{
    has jid;
    has entity_type;
    has entity_value;
    has utterance;
    can local.entity_value;

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_contexts]-> node::_contexts;
    _contexts{
        utterance_list = -[_context]->.utterance;
        entity_type_list = -[_context]->.entity_type;
        
        // if !(entity_type or utterance or entity_value){
        //     report:custom = "Missing required parameter!";
        // }
        // elif(entity_type in entity_type_list and utterance in utterance_list){
        //     report:custom = {"error": "utterance and entity already exist! " + entity_type};
        // }
        // else: take -[_context(id==jid)]-> node::_context else: report:custom = {"error": "jid not found!"};
        take -[_context(id==jid)]-> node::_context else: report:custom = {"error": "jid not found!"};
    }
    _context{
        
        // value = '['+entity_value.str+']'+'('+entity_type.str+')';
        // value2 = '['+entity_value.str+']';

        // a = utt.str::find(value2);
        // std.out("asss\n\n");
        // std.out(a);
        // std.out(utterance);

        // if (0 > a){
        //     std.out('if a ran');
        //     utt = utt.str::replace(entity_value, value);
        //     std.out(utt);
        // }
        utt = utterance;
        new_entity_type = [];
        new_entity_value = [];
        
        // utt.str::replace(entity_value, value);
        if!(entity_type){
            tfm = local.entity_value( utterance ,null);
            std.out("tfm\n");
            std.out(tfm);

            nd = spawn node::_context(utterance= tfm[0].utterance, entity_type=tfm[0].entity, entity_value= tfm[0].value);
            here +[_context(id=nd.info['jid'])]+>nd;
            // report:custom = {"jid":nd.info['jid'], "utterance": nd.context.utterance, "entity_type": nd.context.entity_type, "entity_value": nd.context.entity_value};
            
            utt = utterance;
            new_entity_type = tfm[0].entity;
            new_entity_value = tfm[0].value;
        }
        else{
            new_entity_type = here.entity_type;
            new_entity_type.list::append(entity_type);

            new_entity_value = here.entity_value;
            new_entity_value.list::append(entity_value);

        }



        

        
        if(utterance): here.utterance = utt;
        if(new_entity_type): here.entity_type = new_entity_type;
        if(new_entity_value): here.entity_value = new_entity_value;
        report:custom = {"jid":here.info['jid'], "utterance": here.utterance, "entity_type": here.entity_type, "entity_value": here.entity_value};   
    }
}

walker list_entity_context{
    has payload = [];

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_contexts]-> node::_contexts;
    _contexts: take -[_context]-> node::_context;
    _context{
        data={};
        data['jid']=here.info['jid'];
        data['entity_type']=here.entity_type;
        data['entity_value']=here.entity_value;
        data['utterance']=here.utterance;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = {"payload": payload, "error": ""};  
        }
        else: report:custom = {"payload": [], "error": "No Entity Context Found!"};  
    }
}

walker get_entity_context{
    has payload = [];

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent(id==jid)]-> node::_intent else: report:custom = {"error": "jid not found!"};
    _intent: take -[_contexts]-> node::_contexts;
    _contexts: take -[_context]-> node::_context;
    _context{
        data={};
        data['jid']=here.info['jid'];
        data['entity_type']=here.entity_type;
        data['entity_value']=here.entity_value;
        data['utterance']=here.utterance;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = {"payload": payload, "error": ""};  
        }
        else: report:custom = {"payload": [], "error": "No Entity Context Found!"};  
    }
}

walker delete_entity_context{
    has payload = [];

    root: take -[_train]-> node::_train;
    _train: take -[_intents]-> node::_intents;
    _intents: take -[_intent]-> node::_intent;
    _intent: take -[_contexts]-> node::_contexts;
    _contexts: take -[_context(id==jid)]-> node::_context else: report:custom = {"error": "jid not found!"};
    _context{
        report:custom = "response deleted!";
        destroy here;
        disengage;
    }
    with exit{
        if(payload){
            report:custom = {"payload": payload, "error": ""};  
        }
        else: report:custom = {"payload": [], "error": "No Entity Context Found!"};  
    }
}


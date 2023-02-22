
walker create_faq{
    has question;
    has answer;

    root: take -[_train]-> node::_train;
    _train: take -[_faqs]-> node::_faqs;
    _faqs{
        question_list = -[_faq]->.question;
        answer_list = -[_faq]->.answer;
        if !(question and answer){
            report:custom = {"payload": [], "error": "parameter is required!"};  
        }
        elif(question in question_list){
            report:custom = {"error": "Question already exist! " + question, "payload": []};
        }
        elif(answer in answer_list){
            report:custom = {"error": "Answer already exist! " + answer, "payload": []};
        }
        else{
            std.out(question);
            std.out(answer);
            nd = spawn node::_faq(question = question, answer = answer);
            here +[_faq(id=nd.info['jid'])]+>nd;
            payload = {"jid":nd.info['jid'], "question": nd.context.question, "answer": nd.context.answer};
            report:custom = {"payload": [payload], "error": ""};  
        }
    }
}

walker update_faq{
    has question;
    has answer;
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_faqs]-> node::_faqs;
    _faqs{ 
        std.out(question);
        std.out(answer);
        question_list = -[_faq]->.question;
        answer_list = -[_faq]->.answer;
        if !(question or answer){
            report:custom = {"payload": [], "error": "parameter is required!"};  
        }
        elif(question in question_list and answer in answer_list){
            ques = "Faq already exist! " + question.str;
            report:custom = {"error": ques, "payload": []};
        }
        else: take -[_faq(id==jid)]-> node::_faq else: report:custom = {"error": "jid not found!"};
    }
    _faq{
        if(question): here.question = question;
        if(answer): here.answer = answer;
        std.out(question);
        std.out(answer);
        payload = {"jid":here.info['jid'], "question": here.question, "answer": here.answer};
        report:custom = {"payload": [payload], "error": ""};  
    }
}

walker list_faq{
    has private payload = [];
    root: take -[_train]-> node::_train;
    _train: take -[_faqs]-> node::_faqs;
    _faqs: take -[_faq]-> node::_faq;
    _faq{
        data = {};
        data['jid']=here.info['jid'];
        data["question"]=here.question;
        data["answer"]=here.answer;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = {"payload": payload, "error": ""};  
        }
        else: report:custom = {"payload": [], "error": "No FAQ Found!"};  
    }
}

walker get_faq{
    has jid;
    has private payload = [];

    root: take -[_train]-> node::_train;
    _train: take -[_faqs]-> node::_faqs;
    _faqs: take -[_faq(id==jid)]-> node::_faq;
    _faq{
        data = {};
        data['jid']=here.info['jid'];
        data["question"]=here.question;
        data["answer"]=here.answer;
        payload.list::append(data);
    }
    with exit{
        if(payload){
            report:custom = {"payload": payload, "error": ""};  
        }
        else: report:custom = {"payload": [], "error": "No FAQ Found!"};  
    }
}

walker delete_faq{
    has jid;

    root: take -[_train]-> node::_train;
    _train: take -[_faqs]-> node::_faqs;
    _faqs: take -[_faq(id==jid)]-> node::_faq else: report:custom = {"error": "jid not found!"};
    _faq{
        report:custom = "Faq deleted!";
        destroy here;
        disengage;
    }
}



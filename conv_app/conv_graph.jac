import {*} with "./conv_node.jac";
import {*} with "./conv_edge.jac";


graph dialogue_system {
    has anchor dialog;

    // can file.load_json;
    spawn {
        bienc = file.load_json(global.train_classifer_path);

        dialog = spawn node::dialog;

        faq_root = spawn node::faqs(imprint = [{"list_imprint": bienc['faq_root'], "name": "faq_root"}], name="faq_root");
        dialog +[intent_transition(intent="faq_root")]+>faq_root;

        soc = spawn node::response_only_template(imprint = [{"list_imprint":bienc['greetings'], "name": "greetings"}], name="greetings");
        dialog +[intent_transition(intent="greetings")]+>soc;

        eoc = spawn node::response_only_template(imprint = [{"list_imprint":bienc['goodbye'], "name": "goodbye"}], name="goodbye");
        dialog +[intent_transition(intent="goodbye")]+>eoc;

        subscribe = spawn node::subscribe(imprint = [{"list_imprint":bienc['subscribe'], "name": "subscribe"}], name="subscribe");
        dialog +[intent_transition(intent="subscribe")]+>subscribe;

        unsubscribe = spawn node::unsubscribe(imprint = [{"list_imprint":bienc['unsubscribe'], "name": "unsubscribe"}], name="unsubscribe");
        dialog +[intent_transition(intent="unsubscribe")]+>unsubscribe;

        traffic_alert = spawn node::traffic_alert(imprint = [{"list_imprint":bienc['traffic_alert'], "name": "traffic_alert"}], name="traffic_alert");
        dialog +[intent_transition(intent="traffic_alert")]+>traffic_alert;

        // traffic_report = spawn node::traffic_report(imprint = [{"list_imprint":bienc['traffic_report'], "name": "traffic_report"}], name="traffic_report");
        // dialog +[intent_transition(intent="traffic_report")]+>traffic_report;

        // status = spawn node::status(imprint = [{"list_imprint":bienc['status'], "name": "status"}], name="status");
        // dialog +[intent_transition(intent="status")]+>status;

        // location = spawn node::location(name = "location");
        // traffic_report +[intent_transition(intent="location")]+>location;

        // description = spawn node::description(name = "description");
        // traffic_report +[intent_transition(intent="description")]+>description;

        // image = spawn node::image(name = "image");
        // traffic_report +[intent_transition(intent="image")]+>image;

        // cancellation = spawn node::cancellation(imprint = [{"list_imprint":bienc['cancellation'], "name": "cancellation"}], name="cancellation");
        // traffic_report +[intent_transition(intent="cancellation")]+>cancellation;
        // dialog +[intent_transition(intent="cancellation")]+>cancellation;

        // confirmation = spawn node::confirmation(name = "confirmation");
        // traffic_report +[intent_transition(intent="confirmation")]+>confirmation;
    }
}



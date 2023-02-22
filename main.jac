import {*} with "./graphs.jac";
import {*} with "./globals.jac";
// import {*} with "./training_app/training_walkers.jac";
import {*} with "./conv_app/conv_walkers.jac";

import {*} with './utils/model/kit/bi_enc.jac';
import {*} with './utils/model/kit/tfm_ner.jac';
import {*} with './utils/model/kit/zs_classifier.jac';


walker init {
    root{
        global.main_root = here.info["jid"];

        take -[_train]-> node::_train else {
            spawn here +[_train]+> graph::training_graph;
        }

        take -[conv_root]-> node::conv_root else {
            spawn here +[conv_root]+> node::conv_root;
            take -[conv_root]-> node::conv_root;
        }
    }

    conv_root{
        take -[dialog]-> node::dialog else{
            spawn here +[dialog]+> graph::dialogue_system;
            spawn here +[user]+> node::user;
            spawn here walker::ingest_faq;
            take -[dialog]-> node::dialog;
        }
    }
    dialog{
        std.out("_____________________________We are on the Dialog Node________________________________________");
        global.dialog = here.info['jid'];
    }
}
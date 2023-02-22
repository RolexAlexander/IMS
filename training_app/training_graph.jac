import {*} with "./utterance/utterance_graph.jac";
import {*} with "./faq/faq_graph.jac";
import {*} with "./state/response/response_graph.jac";
import {*} with "./state/resource/resource_graph.jac";
import {*} with "./state/intent/intent_graph.jac";
import {*} with "./entity/entity_graph.jac";
import {*} with "./entity/context/entity_context_graph.jac";
import {*} with "./entity/response/entity_response_graph.jac";


node _train;
edge _train;




graph training_graph {
    has anchor _train;
    spawn {
        _train = spawn node::_train;

        _intents = spawn _train +[_intents]+> node::_intents;
        _faqs = spawn _train +[_faqs]+> node::_faqs;
    }
}

edge dialog;
edge user;
edge conv_root;

edge intent_transition {
    has intent;
}

edge redirect_transition {
    has name;
}

edge redirect_confirm_transition {
    has name;
}

edge entity_transition {
    has entities;
}

edge faqs;
edge faq;



edge dialog;
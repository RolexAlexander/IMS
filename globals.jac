
global main_root = '';
global dialog = '';

global faq_score = 0.2;
global conv_score = 0.3;
global describe_score = 0.6;

global train_state_path = 'utils/data/state.json';
global train_faq_answer_path = 'utils/data/faq_answer.json';
global train_classifer_path = 'utils/data/classifer_data.json';
global train_tfn_ner_path = 'utils/data/tfm_train.json';
global bi_train_path = "utils/data/bi_train.json";

// global entity_label =['number', 'account_name', 'month'];
global entity_label =[];

// Whatsapp API Globals
global whatsapp_url  = "https://graph.facebook.com/v15.0/114616771548131/messages";
global authorisation = "EAANXymhwFzEBAC3bbDrizg3qJwCgEUTP6LpgzlZBcTYZAv1jd1ZBV95ib7ZBnQRkAcPYpD6PZAH0fNhTUkwSVLofyZBLZAicXtxusLU0is9gBDSsx1vdVipFFFc9AGrcKwqlvU9JBvPKIvU0oGhxsbXDOLvKSTK8ZAPbdJXYaF2hgscQBCXbQ08RLdShNXsl81ZCeZAyUijUPAswZDZD";

global main_root = '';
global dialog = '';

global faq_score = 0.2;
global conv_score = 0.3;
global describe_score = 0.5;
global title_words = 5;

global train_state_path = 'utils/data/state.json';
global train_faq_answer_path = 'utils/data/faq_answer.json';
global train_classifer_path = 'utils/data/classifer_data.json';
global train_tfn_ner_path = 'utils/data/tfm_train.json';
global bi_train_path = "utils/data/bi_train.json";

// global entity_label =['number', 'account_name', 'month'];
global entity_label =[];

// Whatsapp API Globals
global whatsapp_url  = "https://graph.facebook.com/v15.0/114616771548131/messages";
global authorisation = "EAANXymhwFzEBAM2nYGwueVvAvFb3RXZCSKJnTIXAlOsZCNMSBHy0RGOUD7UZCVWWZB5iuxRZCsccmNQ8qdA8ddOsZAaq84JSXyChoKW0wRz7OFwe8dXCmepRzJU6yzdutlumCtHdujVUVmo36oQEZAzlAbK0cAdij4GkheufOQvRk9e0VUmtzgjT8pkWCE4KU6OaZA54k3U1PQZDZD";
global message_id = "";
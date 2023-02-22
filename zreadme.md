jsserv makemigrations base
jsserv migrate
jsserv runserver 0.0.0.0:8099

login http://0.0.0.0:8099/

jac build main.jac
sentinel set -snt active:sentinel -mode ir main.jir
walker run init

actions load module jaseci_ai_kit.zs_classifier
actions load module jaseci_ai_kit.use_qa
actions load module jaseci_ai_kit.bi_enc
actions load module jaseci_ai_kit.tfm_ner
actions load module jaseci_ai_kit.use_enc
actions load local utils/model/local/flow.py
actions load local utils/model/local/twilio_bot.py
actions load local utils/model/local/local_module.py
actions load local utils/model/local/latest.py
actions load local utils/model/local/send_media.py
actions load local utils/model/local/get_media.py


graph delete active:graph
jac build main.jac
graph create -set_active true
sentinel register -set_active true -mode ir main.jir

walker run bi_enc_load_model -ctx "{\"model_path\": \"saved_bi_encoder\"}"
walker run tfm_ner_load_model -ctx "{\"model_path\": \"saved_tfm_ner\"}"


graph get -mode dot -o .main.dot
dot -Tpng .main.dot -o .main.png

pip install jaseci --upgrade
pip install jaseci-ai-kit --upgrade
pip install jaseci-serv --upgrade



walker run ingest_faq

walker run create_node_and_edge -ctx "{ \"intent\":\"greetings\",   \"template\":\"response_only\"}"
walker run create_node_and_edge -ctx "{ \"intent\":\"goodbye\",     \"template\":\"response_only\"}"
walker run create_node_and_edge -ctx "{ \"intent\":\"account\",     \"template\":\"collect_info\"}"

walker run create_node_and_edge -ctx "{ \"first_node\":\"urn:uuid:450c75d7-1f02-43e0-970b-89e456a3e4eb\",   \"name\":\"number\", \"template\":\"extract_info\"}"
walker run create_node_and_edge -ctx "{ \"first_node\":\"urn:uuid:99cf4389-a6a3-43d5-8819-5deb532a9415\",   \"second_node\":\"urn:uuid:d9424273-2966-465c-9c99-a40efd0a3a64\", \"intent\":\"faq_root\"}"

walker run create_node_and_edge -ctx "{ \"first_node\":\"urn:uuid:99cf4389-a6a3-43d5-8819-5deb532a9415\",   \"second_node\":\"urn:uuid:99cf4389-a6a3-43d5-8819-5deb532a9415\", \"name\":\"number\"}"
walker run create_node_and_edge -ctx "{ \"first_node\":\"urn:uuid:99cf4389-a6a3-43d5-8819-5deb532a9415\",   \"second_node\":\"urn:uuid:450c75d7-1f02-43e0-970b-89e456a3e4eb\", \"entities\": [\"number\"]}"



pip install jaseci --upgrade
pip install jaseci-ai-kit --upgrade
pip install jaseci-serv --upgrade

Jsserv makemigrations base
Jsserv migrate
Jsserv runserver 0.0.0.0:8008

login http://0.0.0.0:8008/

actions load local serv.py
actions load local i.py
actions load local o.py
actions load local speak.py
actions load local location_distance.py
actions load local swmg.py
actions load local whatsapp_actions.py
actions load local uploading.py





actions load module jaseci_ai_kit.tfm_ner
actions load module jaseci_ai_kit.use_qa
actions load module jaseci_ai_kit.use_enc
actions load module jaseci_ai_kit.bi_enc
actions load module jaseci_ai_kit.stt



graph delete active:graph
jac build main.jac
graph create -set_active true
sentinel register -set_active true -mode ir main.jir

sentinel set -snt active:sentinel -mode ir main.jir

walker run init

jac build Main.jac
sentinel set -snt active:sentinel -mode ir Main.jir
walker run init

graph get -mode dot -o .main.dot 
dot -Tpng .main.dot -o .main.png



## tfm_ner
jac run Modules/tfm_ner.jac -walk tfm_ner_train -ctx "{\"train_file\": \"Data/tfm_data.json\"}"
jac run Modules/tfm_ner.jac -walk tfm_ner_save_model -ctx "{\"model_path\": \"Modules/saved_tfm_ner\"}"
jac run Modules/tfm_ner.jac -walk tfm_ner_load_model -ctx "{\"model_path\": \"Modules/saved_tfm_ner\"}"
jac run Modules/tfm_ner.jac -walk tfm_ner_infer

-- serv
walker run tfm_ner_load_model -ctx "{\"model_path\": \"Modules/saved_tfm_ner\"}"
waler run .tfm_ner.jac -walk train -ctx "{\"train_file\": \"local_app/data/ner_train.json\"}"
walker run .tfm_ner.jac -walk infer tfm_ner_infer
walker run tfm_ner_train -ctx "{\"train_file\": \"utils/data/tfm_train.json\"}"
walker run tfm_ner_infer
walker run tfm_ner_save_model -ctx "{\"model_path\": \"saved_tfm_ner\"}"
walker run tfm_ner_load_model -ctx "{\"model_path\": \"saved_tfm_ner\"}"




// ## ent_ext use tfm_ner 
// jac run .ent_ext.jac -walk train_and_val_flair -ctx "{\"train_file\":\"local_app/data/que_dataset.json\",\"val_file\":\"local_app/data/que_dataset.json\",\"test_file\":\"local_app/data/que_dataset.json\",\"model_name\":\"prajjwal1/bert-tiny\",\"model_type\":\"trfmodel\",\"num_train_epochs\":\"10\",\"batch_size\":\"8\",\"learning_rate\":\"0.02\"}"
// jac run .ent_ext.jac -walk predict_flair -ctx "{\"text\":\"I would like to create an appointment. my son needs a manbun on saturday at 4 pm. \"}"

// -- serv
// walker run train_and_val_flair -ctx "{\"train_file\":\"local_app/data/que_dataset.json\",\"val_file\":\"local_app/data/que_dataset.json\",\"test_file\":\"local_app/data/que_dataset.json\",\"model_name\":\"prajjwal1/bert-tiny\",\"model_type\":\"trfmodel\",\"num_train_epochs\":\"20\",\"batch_size\":\"8\",\"learning_rate\":\"0.02\"}"
// walker run predict_flair -ctx "{\"text\":\"I would like to create an appointment. my son needs a manbun on saturday at 4 pm. \"}"


## bi_enc
jac run utils/model/kit/bi_enc.jac -walk bi_enc_train -ctx "{\"train_file\": \"utils/data/bi_train.json\"}"
jac run utils/model/kit/bi_enc.jac -walk bi_enc_infer -ctx "{\"labels\": [\"traffic_report\", \"not_traffic_report\"]}"
jac run utils/model/kit/bi_enc.jac -walk bi_enc_save_model -ctx "{\"model_path\": \"saved_bi_encoder\"}"
jac run Modules/bi_enc.jac -walk bi_enc_load_model -ctx "{\"model_path\": \"Modules/saved_bi_encoder\"}"

--serv
walker run bi_enc_load_model -ctx "{\"model_path\": \"modules/saved_bi_encoder\"}"
walker run bi_encoder_train -ctx "{\"train_file\": \"local_app/data/_clf_dataset.json\"}"
walker run bi_encoder_infer -ctx "{\"labels\": [\"appointment\", \"i have a question\", \"cost of service\",\"yes\",\"no\"]}"
walker run bi_encoder_save_model -ctx "{\"model_path\": \"dialogue_intent_model\"}"
walker run bi_enc_load_model -ctx "{\"model_path\": \"saved_bi_encoder\"}"


walker run talk -ctx "{\"question\": \"hello\", \"phone_number\": \"6136206\"}"
walker run talker -ctx "{\"question\": \"what time do you open\"}"
walker run talker -ctx "{\"question\": \"yes\"}"
walker run talker -ctx "{\"question\": \"hi\"}"
walker run talker -ctx "{\"question\": \"my son also want a haircut. I think he want a buzzcut on sunday at 5 pm. Can you set that up too\"}"




// walker run createGraph -ctx "{\"intent\": [\"greetings\", \"goodbye\", \"faq_question\"]}"
// walker run createGraph -ctx "{\"intent\": [\"greetings\", \"goodbye\", \"cost\",\"faq_question\",\"cancel\",\"appointment\"]}"
// walker run createGraph -ctx "{\"intent\": [\"greetings\", \"goodbye\", \"cost\"]}"
// walker run createGraph -ctx "{\"intent\": [\"greetings\", \"goodbye\", \"appointment\", \"cost\"]}"

walker run tfm_load_model -ctx "{\"model_path\": \"tfm_ner_saved\"}"
walker run bi_encoder_load_model -ctx "{\"model_path\": \"saved_models\"}"
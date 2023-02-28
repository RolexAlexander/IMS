# How to run this Project

## Login to server

docker exec -it ims_project jsctl -m
login http://localhost:9000
email: admin@gmail.com
password: password
'PLease store the token you will receive for later use somewhere safe'

## Load all the required NLP packages

- actions load module jac_nlp.use_qa
- actions load module jac_nlp.use_enc
- actions load module jac_nlp.tfm_ner
- actions load local utils/model/local/flow.py
- actions load local utils/model/local/local_module.py
- actions load local utils/model/local/get_media.py

walker run bi_enc_load_model -ctx "{\"model_path\": \"saved_bi_encoder\"}"
walker run tfm_ner_load_model -ctx "{\"model_path\": \"saved_tfm_ner\"}"

## Build and Reagister the Program

graph delete active:graph
jac build main.jac
graph create -set_active true
sentinel register -set_active true -mode ir main.jir
'Save the sentinel ID somewhere safe for later use'
'use the following command to get a visualisation of your graph'
'Use the following command to get a visualisation of the graph. Alternatively, you cna utilise jaseci studio.'
graph get -mode dot -o .main.dot

## FAQ Questions

"What is intelligent transportation system (ITS)?",
"How does weather affect traffic?",
"What are some ways to alleviate traffic during rush hour?",
"How can traffic be reduced?",
"What causes traffic congestion?",
"How long will it take to reach my destination during rush hour traffic?",
"What is the best time to leave to avoid the traffic?",
"Is there a way to avoid the traffic?"


e10eb4cbd7dd4206c4780c8cdf7dbc3e12a8c20420bbf2e2a6cb0c2fa3c8e12b
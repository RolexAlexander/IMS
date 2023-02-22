node entity_context_root_t;
node entity_context_t{
    has entity_value;
    has entity_type;
    has utterance;
}

edge entity_context_root_t;
edge entity_context_t: has id;


node _contexts;
node _context{
    has entity_value= [];
    has entity_type= [];
    has utterance;
}

edge _contexts;
edge _context: has id;


import re
from jaseci.actions.live_actions import jaseci_action  # step 1

@jaseci_action(act_group=["local"], allow_remote=True)
def entity_value(utterance:str, utterance_list:list):
    lis = []
    if utterance_list:
        for utterance in utterance_list:
            m = re.findall(r"\[([A-Za-z0-9_-]+)\]", utterance)
            n = re.findall(r"\(([A-Za-z0-9_-]+)\)", utterance)

            data = {"value": m, "entity": n, "utterance": utterance}
            lis.append(data)
    else:
        m = re.findall(r"\[([A-Za-z0-9_-]+)\]", utterance)
        n = re.findall(r"\(([A-Za-z0-9_-]+)\)", utterance)

        data = {"value": m, "entity": n, "utterance": utterance}
        lis.append(data)
    return lis

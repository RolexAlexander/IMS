import re

# s = "I am [Alvin](name). the number is [23111](number)"
# s = "the number is [23111](number)"


# def entity_value(utterance:str, utterance_list:list):
#     lis = []
#     if utterance_list:
#         for utterance in utterance_list:
#             m = re.findall(r"\[([A-Za-z0-9_-]+)\]", s)
#             n = re.findall(r"\(([A-Za-z0-9_-]+)\)", s)

#             data = {"value": m, "entity": n, "utterance": utterance}
#             lis.append(data)
#     else:
#         m = re.findall(r"\[([A-Za-z0-9_-]+)\]", s)
#         n = re.findall(r"\(([A-Za-z0-9_-]+)\)", s)

#         data = {"value": m, "entity": n, "utterance": utterance}
#         lis.append(data)
#     return lis

# report = entity_value(s, None)
# print(report)


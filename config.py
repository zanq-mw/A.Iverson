import configparser

config = configparser.ConfigParser()

config["api_keys"] = {
    "generate_answers": "UdTVXCMnL32EEYb85EA8q9bJee92nVke4QVXa9o9",
    "teams": "UdTVXCMnL32EEYb85EA8q9bJee92nVke4QVXa9o9",
    "points": "5mA2w2L0Z0ySFKCC23XAiAJeaLJTTb2dq23UH79K",
    "prices": "s1jvD0hXSVagqr4xxCo2wO9WGosYttDhRoytAX6h",
    "classify_question": "5mA2w2L0Z0ySFKCC23XAiAJeaLJTTb2dq23UH79K",
}

config["models"] = {
    "generate_answers": "fce2cb16-c7ef-4d68-8f59-12696b268dbd-ft",
    "teams": "6c1b308b-95f6-4604-ab32-ea8364c127b6-ft",
    "points": "6ff555ab-8547-449a-ad8b-75c94d3ad4da-ft",
    "prices": "d2aa6c60-00f7-472b-a706-2cf00fd875bb-ft"
}
with open("config.ini", "w") as configfile:
    config.write(configfile)
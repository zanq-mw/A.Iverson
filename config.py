import configparser

config = configparser.ConfigParser()

config["api_keys"] = {
    "generate_answers": "UdTVXCMnL32EEYb85EA8q9bJee92nVke4QVXa9o9",
    "teams": "UdTVXCMnL32EEYb85EA8q9bJee92nVke4QVXa9o9",
    "points": "5mA2w2L0Z0ySFKCC23XAiAJeaLJTTb2dq23UH79K",
    "prices": "s1jvD0hXSVagqr4xxCo2wO9WGosYttDhRoytAX6h",
    "classify_question": "5mA2w2L0Z0ySFKCC23XAiAJeaLJTTb2dq23UH79K",
    "win": "6XRMX7IZkWtY5NnBg7MNoyy5wcHouRL3ew37i2PD"
}

config["models"] = {
    "generate_answers": "cf0924a2-7c7f-43a3-962f-4c83403d92fe-ft",
    "teams": "6c1b308b-95f6-4604-ab32-ea8364c127b6-ft",
    "points": "6ff555ab-8547-449a-ad8b-75c94d3ad4da-ft",
    "prices": "fd79bd6e-0036-492c-88ed-60ec4395d1f3-ft"
}
with open("config.ini", "w") as configfile:
    config.write(configfile)

import configparser

config = configparser.ConfigParser()

config["api_keys"] = {
    "generate_answers": "UdTVXCMnL32EEYb85EA8q9bJee92nVke4QVXa9o9",
    "teams": "bdQPcFmvsx2X1u08axXLk11DcsCt47ckO8Sxmm03",
    "points": "5mA2w2L0Z0ySFKCC23XAiAJeaLJTTb2dq23UH79K",
    "prices": "s1jvD0hXSVagqr4xxCo2wO9WGosYttDhRoytAX6h",
    "classify_question": "4Bnc7EKGSVz3EPE2EXCFP8xzjC8eKTC3LMdNksjB",
    "win": "6XRMX7IZkWtY5NnBg7MNoyy5wcHouRL3ew37i2PD"
}

config["models"] = {
    "generate_answers": "cf0924a2-7c7f-43a3-962f-4c83403d92fe-ft",
    "teams": "ccaf2c54-69a1-4584-9cb1-e4145d8b9e48-ft",
    "points": "6ff555ab-8547-449a-ad8b-75c94d3ad4da-ft",
    "prices": "fd79bd6e-0036-492c-88ed-60ec4395d1f3-ft"
}
with open("config.ini", "w") as configfile:
    config.write(configfile)

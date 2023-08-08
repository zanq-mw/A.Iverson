import configparser

config = configparser.ConfigParser()

config["api_keys"] = {
    "generate_answers": "UdTVXCMnL32EEYb85EA8q9bJee92nVke4QVXa9o9",
    "teams": "bdQPcFmvsx2X1u08axXLk11DcsCt47ckO8Sxmm03",
    "points": "5mA2w2L0Z0ySFKCC23XAiAJeaLJTTb2dq23UH79K",
    "prices": "s1jvD0hXSVagqr4xxCo2wO9WGosYttDhRoytAX6h",
    "classify_question": "4Bnc7EKGSVz3EPE2EXCFP8xzjC8eKTC3LMdNksjB",
    "win": "6XRMX7IZkWtY5NnBg7MNoyy5wcHouRL3ew37i2PD",
    "sports": "cQmQ79u03QO8HOR1iXLlNzkw0vd3I5MJuCBy9zK6"
}

config["models"] = {
    "generate_answers": "2bfe0e6c-5004-4524-9cb2-68c3ea2376cf-ft",
    "teams": "ccaf2c54-69a1-4584-9cb1-e4145d8b9e48-ft",
    "points": "6ff555ab-8547-449a-ad8b-75c94d3ad4da-ft",
    "prices": "601dff4c-0a32-426e-b409-f9f5a7e3efd8-ft"
}
with open("config.ini", "w") as configfile:
    config.write(configfile)

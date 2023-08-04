import cohere
import configparser

config_read = configparser.ConfigParser()
config_read.read("config.ini")


api_key = config_read.get("api_keys", "points")
co = cohere.Client(api_key)


def answer(prompt):
    pre_prompt = "You are an AI chatbot that helps users navigate and use theScore Bet app. Assume that all questions are asked in the context of theScore Bet app. The user is placing a bet, please extract how many points they are predicting"
    response = co.generate(
        pre_prompt + prompt,
        max_tokens=1000,
        model=config_read.get("models", "points")
    )
    return (response[0].text)

prompt = input()
print(answer(prompt))

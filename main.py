import classify_question
import cohere
import configparser
import api

config_read = configparser.ConfigParser()
config_read.read("config.ini")
api_key = config_read.get("api_keys", "generate_answers")
co = cohere.Client(api_key)


def send_message(bot_response):
    message = api.send_message(bot_response)
    print(message)


def bet_workflow():
    print('bet')


def question_workflow(prompt):
    pre_prompt = "You are an AI chatbot that helps users navigate and use theScore Bet app. Assume that all questions are asked in the context of theScore Bet app. To start, please answer this user's question: "
    response = co.generate(
        pre_prompt + prompt,
        max_tokens=1000,
        model=config_read.get("models", "generate_answers")
    )
    return (response[0].text)


def start():
    print("Hi I'm A.Iverson. How can I help you?")
    quit  = False
    while not quit:
        user_input = input()
        prompt = api.receive_message({"user_message": user_input})
        req_type = classify_question.bet_or_question(prompt["user_message"])
        if prompt["user_message"].lower() == "quit":
            print("Goodbye! I hope I was helpful.")
            quit = True
        elif req_type == "Bet":
            bet_workflow()
        elif req_type == "Question":
            answer = question_workflow(prompt["user_message"])
            bot_response = {
                "bot_message": answer,
                "bet_mode": False,
                "bet": None
            }
            send_message(bot_response)
        else:
            print("I can't understand your question, please be more specific.")


start()

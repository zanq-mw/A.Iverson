import classify_question
import cohere
import configparser

config_read = configparser.ConfigParser()
config_read.read("config.ini")
api_key = config_read.get("api_keys", "generate_answers")
co = cohere.Client(api_key)


def send_message(msg):
    print(msg)


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
        prompt = input()
        req_type = classify_question.bet_or_question(prompt)
        if prompt.lower() == "quit":
            print("Goodbye! I hope I was helpful.")
            quit = True
        elif req_type == "Bet":
            bet_workflow()
        elif req_type == "Question":
            answer = question_workflow(prompt)
            send_message(answer)
        else:
            print("I can't understand your question, please be more specific.")


start()

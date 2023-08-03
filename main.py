import classify_question


def send_message(msg):
    print(msg)


def bet_worflow():
    print('bet')


def question_workflow():
    print('question')


def start():
    initial = input("Hi I'm A.Iverson. How can I help you?\n")
    req_type = classify_question.bet_or_question(initial)
    if req_type == "bet":
        bet_workflow()
    elif req_type == "question":
        question_workflow()

    send_message(answer)


start()

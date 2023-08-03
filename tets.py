import cohere

api_key = 'UdTVXCMnL32EEYb85EA8q9bJee92nVke4QVXa9o9'
co = cohere.Client(api_key)


def answer(prompt):
    pre_prompt = "You are an AI chatbot that helps users navigate and use theScore Bet app. Assume that all questions are asked in the context of theScore Bet app. To start, please answer this user's question: "
    response = co.generate(
        pre_prompt + prompt,
        max_tokens=1000,
        model="6c1b308b-95f6-4604-ab32-ea8364c127b6-ft"
    )
    return (response[0].text)


prompt = input("hey")
print(answer(prompt))

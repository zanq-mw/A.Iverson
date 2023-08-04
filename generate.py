import cohere

api_key = config_read.get("api_keys", "generate_answers")

co = cohere.Client(api_key)


def answer(prompt):
    pre_prompt = "You are an AI chatbot that helps users navigate and use theScore Bet app. Assume that all questions are asked in the context of theScore Bet app. To start, please answer this user's question: "
    response = co.generate(
        pre_prompt + prompt,
        max_tokens=1000,
        model=config_read.get("models", "generate_answers")
    )
    return (response[0].text)

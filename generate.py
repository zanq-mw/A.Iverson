import cohere

api_key = 'UdTVXCMnL32EEYb85EA8q9bJee92nVke4QVXa9o9'
co = cohere.Client(api_key)

pre_prompt = "You are an AI chatbot that helps users navigate and use theScore Bet app. Assume that all questions are asked in the context of theScore Bet app. To start, please answer this user's question: "

prompt = input("Prompt: ")

response = co.generate(
  pre_prompt + prompt,
  max_tokens= 1000,
  model="fce2cb16-c7ef-4d68-8f59-12696b268dbd-ft"
)
print(response[0].text)

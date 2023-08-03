import cohere
api_key = 's1jvD0hXSVagqr4xxCo2wO9WGosYttDhRoytAX6h'
co = cohere.Client(api_key)

pre_prompt = "If money is referenced in the following prompt, please output only that amount prepended with a dollar sign and nothing else. Otherwise, say 'N/A'. Here is the prompt: "

prompt = input("Prompt: ")

response = co.generate(
    pre_prompt + prompt,
    max_tokens=1000
)
print(response[0].text)


pre_prompt = "If an NBA is referenced in the following prompt, please output only the full name and nothing else. Otherwise, say 'N/A'. Here is the prompt: "

prompt = input("Prompt: ")

response = co.generate(
    pre_prompt + prompt,
    max_tokens=1000
)
print(response[0].text)

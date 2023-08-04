import cohere
api_key = config_read.get("api_keys", "prices")

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

pre_prompt = "If a sport is referenced in the following prompt, please output the name of the sport and nothing else. Otherwise, say 'N/A'. Here is the prompt: "

prompt = input("Prompt: ")

response = co.generate(
    pre_prompt + prompt,
    max_tokens=1000
)
print(response[0].text)

pre_prompt = "If game statistics are referenced in the following prompt, please output the name of the game statistic and nothing else. Otherwise, say 'N/A'. Here is the prompt: "

prompt = input("Prompt: ")

response = co.generate(
    pre_prompt + prompt,
    max_tokens=1000
)
print(response[0].text)

pre_prompt = "If the name of an NBA player is referenced in the following prompt, please output the name of the player and nothing else. Otherwise, say 'N/A'. Here is the prompt: "

prompt = input("Prompt: ")

response = co.generate(
    pre_prompt + prompt,
    max_tokens=1000
)
print(response[0].text)

pre_prompt = "If winning referenced in the following prompt, please output 'Win'. Here is the prompt: "

prompt = input("Prompt: ")

response = co.generate(
    pre_prompt + prompt,
    max_tokens=1000
)
print(response[0].text)

pre_prompt = "If losing referenced in the following prompt, please output 'Loss'. Here is the prompt: "

prompt = input("Prompt: ")

response = co.generate(
    pre_prompt + prompt,
    max_tokens=1000
)
print(response[0].text)
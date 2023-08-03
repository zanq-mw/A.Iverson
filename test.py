import cohere
api_key = 's1jvD0hXSVagqr4xxCo2wO9WGosYttDhRoytAX6h'
co = cohere.Client(api_key)

response = co.generate(
  prompt='Explain what is moneyline betting?',
  max_tokens= 1000
)
print(response[0].text)
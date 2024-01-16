# A.Iverson
A.Iverson is a virtual betting assistant made for theScore Bet App. It uses natural language proccessing to communicate with users, lowering the barrier of entry into sports betting. Through studies it was found that many people that starting to get into sports betting struggle with the terminology and logisitcs so A.Iverson was made to combat that.

A.Iverson works as a chatbot where users can either ask it questions or ask it to place a bet for them. It will use its ever growing knowledge base to answer questions about betting or app navigation. If you ask it to place a bet, it will parse the text to get all the details of the bet to put together a bet slip, where the user can simply click confirm to place the bet. It was made using Python, Swift, Fast API, and Cohere APIs.
## Demo

https://github.com/zanq-mw/A.Iverson/assets/50245287/4abcd787-1d68-40de-9bde-e972a011d43a


## How to run this app
### Backend
1. run `uvicorn api:app --reload` to start server
2. go to http://127.0.0.1:8000/docs to test

### Frontend
1. Install Xcode (Developed on 14.3.1)
2. Open the `.xcodeproj` file at `\frontend\A.Iverson\`
3. Build and run (⌘ + R)

Note: The frontend will give and error message without the backend running!


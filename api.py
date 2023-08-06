from fastapi import FastAPI
from pydantic import BaseModel
import main
from api_responses import UserMessage

import main

app = FastAPI()

# run `uvicorn api:app --reload` to start server
# go to http://127.0.0.1:8000/docs to test
# use this every time the user sends a message
@app.post("/receive_message")
def receive_message(user_message: UserMessage):
    response = main.start_workflow(user_message)
    return response
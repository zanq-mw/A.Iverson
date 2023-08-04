from fastapi import FastAPI
from pydantic import BaseModel


class UserMessage(BaseModel):
    user_message: str

class Bet(BaseModel):
    game_title: str
    bet_title: str
    bet_description: str
    bet: float
    multiplier: float
    odds: float

class BotResponse(Bet, BaseModel):
    bot_message: str
    bet_mode: bool
    bet: Bet

app = FastAPI()

# run `uvicorn main:app --reload` to start server
# use this every time the user sends a message
@app.post("/receive_message")
def receive_message(user_message: UserMessage):

    return user_message

@app.post("/send_message")
def send_message(bot_response: BotResponse):

    return bot_response
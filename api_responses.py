from pydantic import BaseModel
from typing import Optional

class UserMessage(BaseModel):
    user_message: str

class Bet(BaseModel):
    game_title: str
    bet_title: str
    bet_description: str
    bet_amount: float
    to_win: float
    odds: float

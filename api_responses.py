from pydantic import BaseModel
from typing import Optional
from enum import Enum

class Mode(Enum):
    NO_TYPE = 1
    BET = 2
    QUESTION = 3


class BetData(BaseModel):
    sport: str | None = None
    team: str | None = None
    bet_amount: float | None = None
    points: int | None = None
    # bet_title: str | None = None
    # bet_description: str | None = None
    game_title: str | None = None
    multiplier: float | None = None
    odds: int | None = None

class Bet(BaseModel):
    game_title: str | None = None
    bet_title: str | None = None
    bet_description: str | None = None
    bet_amount: float | None = None
    to_win: float | None = None
    odds: float | None = None

class UserMessage(BetData, Bet):
    user_message: str
    mode: int
    bet: Bet | None = None
    bet_data: BetData | None = None


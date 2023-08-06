from pydantic import BaseModel
from typing import Optional

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
    bet_mode: bool
    bet: Bet | None = None
    bet_data: BetData | None = None


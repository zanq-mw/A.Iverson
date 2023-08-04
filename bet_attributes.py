import cohere
import configparser

config_read = configparser.ConfigParser()
config_read.read("config.ini")
api_key = config_read.get("api_keys", "prices")

co = cohere.Client(api_key)


def get_sport(prompt):
    pre_prompt = "If a sport is referenced in the following prompt, please output the name of the sport and nothing else. Otherwise, say 'N/A'. Here is the prompt: "
    response = co.generate(
        pre_prompt + prompt,
        max_tokens=1000
    )
    sport = response[0].text
    if "N/A" in sport:
        return None
    return sport


def get_bet(prompt):
    model = config_read.get("models", "prices")
    response = co.generate(
        prompt,
        model=model,
        max_tokens=1000
    )
    bet = response[0].text
    if bet == 'N/A':
        return None
    return float(bet)


def get_team(prompt):
    api_key = config_read.get("api_keys", "teams")
    co = cohere.Client(api_key)
    model = config_read.get("models", "teams")
    response = co.generate(
        prompt,
        model=model,
        max_tokens=1000
    )
    team = response[0].text
    return team


def get_points(prompt):
    api_key = config_read.get("api_keys", "points")
    co = cohere.Client(api_key)
    model = config_read.get("models", "points")
    response = co.generate(
        prompt,
        max_tokens=1000,
        model=model
    )
    points = response[0].text
    if points == "N/A":
        return None
    return int(points)


# print(get_points("I want to play Raptors scoring 70 points"))

import classify_question
import cohere
import configparser
import bet_attributes

config_read = configparser.ConfigParser()
config_read.read("config.ini")
api_key = config_read.get("api_keys", "generate_answers")
co = cohere.Client(api_key)

game_data = [
    {"home": "Raptors", "away": "Clippers",
        "name": "Raptors vs Clippers", "multiplier": 1.7, "odds": 157},
    {"home": "Raptors", "away": "Mavericks",
        "name": "Raptors vs Mavericks", "multiplier": 1.2, "odds": -157},
    {"home": "Hawks", "away": "Raptors",
        "name": "Hawks vs Raptors", "multiplier": 1.5, "odds": 198},
    {"home": "Lakers", "away": "Clippers",
        "name": "Lakers vs Clippers", "multiplier": 1.3, "odds": -198},
    {"home": "Lakerrs", "away": "Mavericks",
        "name": "Lakers vs Mavericks", "multiplier": 1.1, "odds": 62},
    {"home": "Hawks", "away": "Lakers", "name": "Hawks vs Lakers",
        "multiplier": 1.8, "odds": -62},
    {"home": "Warriors", "away": "Clippers",
        "name": "Warriors vs Clippers", "multiplier": 1.9, "odds": 81},
    {"home": "Warriors", "away": "Mavericks",
        "name": "Warriors vs Mavericks", "multiplier": 1.6, "odds": -17},
    {"home": "Hawks", "away": "Warriors",
        "name": "Hawks vs Warriors", "multiplier": 1.4, "odds": 101}
]


def send_message(msg):
    print(msg)


def bet_workflow(prompt):
    data = {'sport': bet_attributes.get_sport(prompt),
            'team': bet_attributes.get_team(prompt),
            'bet': bet_attributes.get_bet(prompt),
            'points': bet_attributes.get_points(prompt)}
    sport_q = 'What sport would you like to place your bet on?\n'
    team_q = 'What team would you like to place your bet on?\n'
    outcome_q = 'What outcome would you like to bet on?\n'
    game_q = 'What game do you want to bet on?\n'
    try_again = "Sorry I didn't get that. Try again.\n"

    while 'sport' not in data or data['sport'] is None:
        user_input = input(sport_q)
        data['sport'] = bet_attributes.get_sport(user_input)
        sport_q = try_again
    while 'team' not in data or data['team'] is None:
        user_input = input(team_q)
        data['team'] = bet_attributes.get_team(user_input)
        team_q = try_again

    while 'game_title' not in data or data['game_title'] is None:
        games = []
        multipliers = []
        odds = []
        msg = 'Here are the options:\n'
        for i in range(len(game_data)):
            game = game_data[i]
            if data['team'] in [game['home'], game['away']]:
                games.append(game['name'])
                multipliers.append(game['multiplier'])
                odds.append(game['odds'])
                msg += (f'{i+1}. {game["name"]}\n')
        user_input = input(game_q + msg)
        if user_input.isdigit() and int(user_input) < len(games):
            user_input = int(user_input)
            data['game_title'] = games[user_input]
            data['multiplier'] = multipliers[user_input]
            data['odds'] = odds[user_input]
        outcome_q = try_again

    while ('points' not in data or data['points'] is None) and ('win' not in data or data['win'] is None):
        user_input = input(outcome_q)
        data['points'] = bet_attributes.get_points(user_input)
        sport_q = try_again

    if 'points' in data and data['points'] is not None:
        data['bet_title'] = f"Over {data['points'] - 0.5}"
        data['bet_description'] = 'Total'
    else:
        data['bet_title'] = data['team']
        data['bet_description'] = 'Moneyline'

    send_message("Here is your bet slip\n")
    return data

    # what sport
    # what team
    # what outcome do you want to bet on


def question_workflow(prompt):
    pre_prompt = "You are an AI chatbot that helps users navigate and use theScore Bet app. Assume that all questions are asked in the context of theScore Bet app. To start, please answer this user's question: "
    response = co.generate(
        pre_prompt + prompt,
        max_tokens=1000,
        model=config_read.get("models", "generate_answers")
    )
    return (response[0].text)


def start():
    print("Hi I'm A.Iverson. How can I help you?")
    quit = False
    while not quit:
        prompt = input()
        req_type = classify_question.bet_or_question(prompt)
        if prompt.lower() == "quit":
            print("Goodbye! I hope I was helpful.")
            quit = True
        elif req_type == "Bet":
            bet = bet_workflow(prompt)
            print(bet)
        elif req_type == "Question":
            answer = question_workflow(prompt)
            send_message(answer)
        else:
            print("I can't understand your question, please be more specific.")


start()

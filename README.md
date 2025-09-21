# README

Project of the week, Week 4

Tic-Tac-Toe API 

This is a simple API-only Tic-Tac-Toe game.
You play as the client, the server plays back.
All game state lives in Redis.

## How It Works
1. Start a game → you get back a game id and token.
2. Make moves → send your move, the server will reply with its move. 
3. Game ends → when someone wins or it’s a draw.

## Setup
1. clone repository
2. cd tic-tac-toe
3. `bundle install`
4. `docker compose up -d`

## Start a Game
`curl -X POST http://localhost:3401/games`

## Play a move
`curl -X POST http://localhost:3401/games/<game_id> \
  -H "X-Game-Token: <your_token>" \
  -H "Idempotency-Key: move-1"
  -H "Content-Type: application/json" \
  -d '{"position":0}'`

extends Node

@export var initial_lives: int = 3

signal restart_level

var player_lives: int
var player_score: int = 0

func _ready() -> void:
  reset_game()

func reset_game() -> void:
  # Initialize player lives
  player_lives = initial_lives
  player_score = 0
  restart_level.emit()

func add_score(points: int) -> void:
  player_score += points

func player_lost_life() -> void:
  player_lives -= 1
  if player_lives <= 0:
    game_over()
  else:
    restart_level.emit()

func game_over() -> void:
  # Handle game over logic here
  print("Game Over! Final Score: ", player_score)
  # Optionally, you can reset the game or show a game over screen
  reset_game()
extends Node


class Score extends Resource:
  var score: int
  var initials: String

  func _init(score_: int, initials_: String) -> void:
    self.score = score_
    self.initials = initials_

@export var initial_lives: int = 3
@export var high_scores: Array[Score] = []

signal respawn_ball
signal game_over(player_won: bool)
signal player_scored

var player_lives: int
var player_score: int = 0
var player_last_score: int = 0

func _ready() -> void:
  load_high_scores()
  reset_game()

func load_high_scores() -> void:
  # TODO: implement loading logic
  # Load high scores from a file or database if needed
  # This is a placeholder for actual loading logic
  high_scores = [
    Score.new(1000, "AAA"),
    Score.new(900, "BBB"),
    Score.new(800, "CCC"),
  ]

func save_high_scores() -> void:
  # TODO: implement saving logic
  # Save high scores to a file or database if needed
  # This is a placeholder for actual saving logic
  pass

func is_player_eligible_for_high_score() -> bool:
  if high_scores.size() < 10:
    return true

  return player_last_score >= high_scores[high_scores.size() - 1].score

# Function to add a new high score, likely called from the game_over scene
func add_high_score(score: int, initials: String) -> void:
  var new_score = Score.new(score, initials)
  high_scores.append(new_score)
  high_scores.sort_custom(func(a, b): return b.score - a.score) # Sort in descending order
  if high_scores.size() > 10:
    high_scores.resize(10) # Keep only top 10 scores

  save_high_scores()

func reset_game() -> void:
  # Initialize player lives
  player_lives = initial_lives
  player_last_score = player_score
  player_score = 0
  respawn_ball.emit()

func restart_level() -> void:
  player_lost_life()

func add_score(points: int) -> void:
  player_score += points
  player_scored.emit()

func player_lost_life() -> void:
  player_lives -= 1
  if player_lives <= 0:
    _game_over()
  else:
    respawn_ball.emit()

func _game_over() -> void:
  # Reset the game state for the next game
  reset_game()
  # Emit the game over signal
  game_over.emit(false)

func player_won() -> void:
  reset_game()
  game_over.emit(true)
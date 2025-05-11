extends Node

var scores_path: String = "user://high_scores.cfg"

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
  # Load high scores from a file or database if needed
  var score_config = ConfigFile.new()
  if score_config.load(scores_path) == OK:
    var i = 0
    while true:
      var score = score_config.get_value("HighScores", "Score" + str(i), -1)
      if score == -1:
        break
      var initials = score_config.get_value("HighScores", "Initials" + str(i), "")
      high_scores.append(Score.new(score, initials))
      i += 1

  high_scores.sort_custom(compare_scores_descending) # Sort in descending order
  if high_scores.size() > 10:
    high_scores.resize(10) # Keep only top 10 scores

func save_high_scores() -> void:
  var score_config = ConfigFile.new()
  for i in range(high_scores.size()):
    score_config.set_value("HighScores", "Score" + str(i), high_scores[i].score)
    score_config.set_value("HighScores", "Initials" + str(i), high_scores[i].initials)

  score_config.save(scores_path)

func is_player_eligible_for_high_score() -> bool:
  if high_scores.size() < 10:
    return true

  return player_last_score >= high_scores[high_scores.size() - 1].score


func compare_scores_descending(a: Score, b: Score) -> int:
  return a.score > b.score

# Function to add a new high score, likely called from the game_over scene
func add_high_score(initials: String) -> void:
  var new_score = Score.new(player_last_score, initials)
  high_scores.append(new_score)
  high_scores.sort_custom(compare_scores_descending) # Sort in descending order
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
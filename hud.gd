extends Control

@onready var lives_label: Label = $LivesDisplay/Value
@onready var score_label: Label = $ScoreDisplay/Value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  lives_label.text = str(GameManager.player_lives)
  score_label.text = str(GameManager.player_score)
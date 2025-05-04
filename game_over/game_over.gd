extends Control

@export var score_label: Label

var player_won: bool = false

signal return_to_main_menu


func _ready() -> void:
  if player_won:
    score_label.text = "You Win! Final Score: " + str(GameManager.player_last_score)
  else:
    score_label.text = "Final Score: " + str(GameManager.player_last_score)

func _on_main_menu_button_pressed() -> void:
  print("Returning to main menu...")
  return_to_main_menu.emit()
  # Optionally, you can hide the game over screen if needed
  queue_free()
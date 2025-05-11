extends Control

@export var score_label: Label
@export var options_container: Control

var player_won: bool = false

signal return_to_main_menu


func _ready() -> void:
  if player_won:
    score_label.text = "You Win! Final Score: " + str(GameManager.player_last_score)
  else:
    score_label.text = "Final Score: " + str(GameManager.player_last_score)

  # If the player is eligible for a high score, show the input field
  if GameManager.is_player_eligible_for_high_score():
    # Add a label for initials input
    var initials_label = Label.new()
    initials_label.text = "Enter your initials (3 letters):"
    options_container.add_child(initials_label)
    # Create a LineEdit for initials input
    var initials_input = LineEdit.new()
    initials_input.max_length = 3
    initials_input.caret_blink = true
    initials_input.placeholder_text = "AAA"
    initials_input.grab_focus.call_deferred()

    options_container.add_child(initials_input)
    # Create a button to submit the initials
    var submit_button = Button.new()
    submit_button.text = "Submit High Score"
    submit_button.disabled = true
    submit_button.pressed.connect(
      func() -> void:
        var initials = initials_input.text
        if initials.length() == 3:
          GameManager.add_high_score(initials.to_upper())
          _on_main_menu_button_pressed()
    )
    options_container.add_child(submit_button)

    initials_input.text_changed.connect(
      func(_text: String) -> void:
        # Enable the button only if the input is exactly 3 characters
        submit_button.disabled = initials_input.text.length() != 3
    )
  else:
    # Else, show a button to return to the main menu
    var main_menu_button = Button.new()
    main_menu_button.text = "Return to Main Menu"
    main_menu_button.pressed.connect(_on_main_menu_button_pressed)
    options_container.add_child(main_menu_button)

func _on_main_menu_button_pressed() -> void:
  print("Returning to main menu...")
  return_to_main_menu.emit()
  queue_free()

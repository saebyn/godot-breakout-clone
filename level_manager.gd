extends Node2D

@export var levels: Array[Level] = []
@export var label: Label
@export var level_load_tween_duration: float = 1.0

var current_level_index: int = 0
var bricks_removed: int = 0

func _ready() -> void:
  assert(levels.size() > 0, "No levels defined in LevelManager.")
  load_level(current_level_index)

  GameManager.player_scored.connect(_on_player_scored)
  GameManager.game_over.connect(_on_game_over)

func _on_game_over(_player_won: bool) -> void:
  unload_level()
  load_level(0)

func _on_player_scored() -> void:
  bricks_removed += 1
  if bricks_removed >= levels[current_level_index].bricks_count:
    progress_to_next_level()


func progress_to_next_level() -> void:
  current_level_index += 1
  if current_level_index < levels.size():
    unload_level()

    var t := create_tween()

    # Tween to fade in the label
    label.modulate = Color(1, 1, 1, 0) # Start fully transparent
    label.text = levels[current_level_index].name
    label.show()
    get_tree().paused = true
    t.tween_property(label, "modulate", Color(1, 1, 1, 1), level_load_tween_duration)
    t.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)

    t.finished.connect(_on_level_load_tween_finished)
  else:
    # No more levels to load, handle game completion
    GameManager.player_won()


func _on_level_load_tween_finished() -> void:
  get_tree().paused = false
  load_level(current_level_index)
  label.hide()
  GameManager.respawn_ball.emit()


func load_level(level_index: int) -> void:
  assert(level_index >= 0 and level_index < levels.size(), "Invalid level index: " + str(level_index))
  current_level_index = level_index
  var level: Level = levels[current_level_index]
  # Load the level scene
  var level_scene: PackedScene = level.scene

  assert(level_scene != null, "Level scene is null for level: " + level.name)

  var level_instance: Node = level_scene.instantiate()

  # Reset bricks_removed for the new level
  bricks_removed = 0

  # Add the level instance under the current node
  call_deferred("add_child", level_instance)


func unload_level() -> void:
  # Remove all children (level instances) from this node
  for child in get_children():
    child.queue_free()

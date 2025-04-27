extends Area2D

func _on_deadzone_body_entered(body: Node) -> void:
  if body is Ball:
    GameManager.player_lost_life()
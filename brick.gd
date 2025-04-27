extends StaticBody2D

@export var points: int = 10

func on_ball_collision(_ball: Node) -> void:
  GameManager.add_score(points)
  queue_free() # Remove the brick after collision
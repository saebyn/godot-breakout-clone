extends CharacterBody2D


const SPEED = 900.0


func _physics_process(_delta: float) -> void:
  # Get the input direction and handle the movement/deceleration.
  var direction := Input.get_axis("move_left", "move_right")
  if direction:
    velocity.x = direction * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)

  move_and_slide()


func on_ball_collision(ball: Ball) -> void:
    # Influence the ball's velocity based on the paddle's speed
    # in the direction of the paddle's movement
    var paddle_velocity_influence := Vector2(velocity.x, 0)
    var current_speed := ball.velocity.length()
    ball.velocity += paddle_velocity_influence
    ball.velocity = ball.velocity.normalized() * current_speed
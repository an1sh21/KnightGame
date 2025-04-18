extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const GRAVITY = 980.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_timer: Timer = $Timer
var is_dying: bool = false  # Add a flag to track death state

func _physics_process(delta: float) -> void:
	if is_dying:
		return  # Skip all movement logic when dying
	
	# Normal movement code
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("Run")
	else:
		if velocity.y < 0:
			animated_sprite.play("Jumping")
		
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func die():
	if is_dying:  # Prevent multiple death triggers
		return
		
	is_dying = true
	velocity = Vector2.ZERO  # Stop all movement
	Engine.time_scale = 0.5
	animated_sprite.play("Dying")
	death_timer.start()

	# Debug print to confirm the function is called
	print("Death triggered! Playing dying animation")


		


func _on_death_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()


func _on_player_body_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		die()

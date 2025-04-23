extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const GRAVITY = 980.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_timer: Timer = $Timer

var is_dying: bool = false

func _ready():
	# Ensure timer is properly configured
	death_timer.one_shot = true
	death_timer.autostart = false
	death_timer.wait_time = 1.0  # Set this to your desired duration (in real seconds)
	death_timer.timeout.connect(_on_death_timer_timeout)

func _physics_process(delta: float) -> void:
	if is_dying:
		return
	
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
	if is_dying:
		return
	is_dying = true
	velocity = Vector2.ZERO
	Engine.time_scale = 0.5
	animated_sprite.play("Dying")
	death_timer.start()
	print("Death timer started with wait time: ", death_timer.wait_time)

func _on_death_timer_timeout():
	print("Death timer completed")
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

func _on_player_body_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		die()

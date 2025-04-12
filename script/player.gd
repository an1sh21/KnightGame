extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#This gets user direction, can be 1, 0  or -1
	var direction := Input.get_axis("move_left", "move_right")
	
	#Flips the sprite
	if direction > 0 :#Move right
		animated_sprite.flip_h = false
	elif direction < 0 :
		animated_sprite.flip_h = true
		
	#Play animations
	if is_on_floor():
		if direction == 0:
				animated_sprite.play("Idle")
		else:
			animated_sprite.play("Run")
			
	else:
		animated_sprite.play("Jumping")
			
	   
		
	
	
	
		
		
	
	
	
	
	#This applies the movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

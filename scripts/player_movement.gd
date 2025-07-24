extends CharacterBody2D


const SPEED = 240.0
const JUMP_VELOCITY = -500.0
const MOVE_ACCEL = 0.10
const STOP_ACCEL = 0.10
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_on_wall_only():
			velocity.y = JUMP_VELOCITY*0.5
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		#while abs(velocity.x) <= abs(direction*SPEED):
		velocity.x += SPEED*MOVE_ACCEL*direction
		if direction > 0:
			if velocity.x > direction*SPEED:
				velocity.x = direction*SPEED
		elif direction < 0:
			if velocity.x < direction*SPEED:
				velocity.x = direction*SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*STOP_ACCEL)

	move_and_slide()


#issues i have had quick access
# speed and gravity values weren't entirely right.
#
# Immediately getting to max speed / min speed
# min speed fixed first with speed*0.16 as delta rather than speed
# max speed fixed by adding acceleration
#
# Move accel did not work correctly in both directions or when switching directions
# split movement into different directions 
# the issue was that i used absolute max speed and velocity values, which caused direction issues due to having
# max speed in one direction when switching caused the code to immediately put me at full acceleration.
#
# stop accel was always the same no matter how fast you were going
# multiplied by speed.
#
# cannot jump on wall. added or is_on_wall()

# wall jump too powerful. separated is_on_wall()
# changed to is_on_wall_only() probably not much difference due to elif but better suited.

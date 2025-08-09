extends CharacterBody2D


const SPEED = 240.0
const JUMP_VELOCITY = -500.0
const MOVE_ACCEL = 0.10
const STOP_ACCEL = 0.10
var jumpTimer = 0.0
var jumpVelocity = 0.0
var coyote_timer = 0.0
func _physics_process(delta: float) -> void:
	# Add the gravity.
	# jump starts here now
	if is_on_floor():
		coyote_timer = 0.0
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer += delta
	if not Input.is_action_pressed("Jump"):
		jumpTimer = 0.01
		jumpVelocity = 0.0
	if Input.is_action_just_pressed("Jump"):
		if is_on_wall_only():
			velocity.y = JUMP_VELOCITY*0.5
		elif coyote_timer < 0.1:
			jumpVelocity = -4.2
	if Input.is_action_pressed("Jump"):
		jumpTimer += delta
		if not is_on_wall_only() and jumpTimer < 0.2:
			velocity.y += jumpVelocity*(1/jumpTimer) #jumpVelocity will be 0 if jump not started on ground
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

# i need to implement coyote time (for a few frames after falling you can still jump)
#
# implemented variable jump height
#
# Jumping on a ceiling gives height. This is not intended.

# Jumping in mid-air gave height. Added is_on_floor() to is_action_just_pressed("Jump") and is_action_pressed("Jump")

# Variable jumping no longer works as not on floor after jumping. Removing is_on_floor from is_action_pressed("Jump"). 
# This works as the change in velocity.y is multiplied by jump_velocity, which is 0.0 unless jumped from floor
# This broke wall jumping as it seems the infinite jump was causing it to work. 
# Fixed by moving is_on_floor to elif after wall jump.

# I think that jump height is too high. Lowering it.

# Refer to line 67
# How Coyote?
# Timer, for frames after fall
# is_on_floor, coyote_timer = 0.0
# not is_on_floor, coyote_timer += delta
# if coyote_timer < 10 or smtn jump
# 10 is too many frames

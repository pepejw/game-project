extends CharacterBody2D

const SPEED = 240.0
const WALL_JUMP_VELOCITY = -180.0
const MOVE_ACCEL = 0.10
const STOP_ACCEL = 0.10
var jump_timer = 0.0
var jump_velocity = 0.0
var coyote_timer = 0.0
var jump_in_progress = false
var device = "Keyboard0_"
enum DIRECTION {right, left}
var can_attack = true
var last_direction = DIRECTION.right
var move = false
var atk = false

	# GET ALL DEVICES tick
	# GET ALREADY USED DEVICES tick
	# IF ANY BUTTON PRESSED, CHECK IF CONTROLLER ALREADY USED
	# IF NOT SET THAT CONTROLLER TO THIS PLAYER'S tick
func _physics_process(delta: float) -> void:
	# Add the gravity.
	# jump starts here now
	if device != "":
		if is_on_floor():
			coyote_timer = 0.0
			jump_in_progress = false
		if not is_on_floor():
			velocity += get_gravity() * delta
			coyote_timer += delta
		if not Input.is_action_pressed(device+"Jump"):
			jump_timer = 0.01
			jump_velocity = 0.0
		if jump_timer != 0.01: # If you press jump, jump timer increases. It is 0.01 by default
			if is_on_wall_only():
				velocity.y = WALL_JUMP_VELOCITY
			elif jump_timer < 0.11:
				jump_velocity = -18
				if velocity.y > 0.0:
					velocity.y = 0.0
				velocity.y += jump_velocity*(0.55/(jump_timer*2)) #jumpVelocity will be 0 if jump not started on ground
				velocity.y = clamp(velocity.y,-425,510)
		if (Input.is_action_pressed(device+"Jump") and coyote_timer < 0.1) or (Input.is_action_pressed(device+"Jump") and is_on_wall_only()) or (jump_in_progress):
			jump_timer += delta
			jump_in_progress = true
			if not Input.is_action_pressed(device+"Jump"):
				jump_in_progress = false
		change_animation()
	# ok i found problem 
				# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis(device+"Left", device+"Right")
		if direction:
			#while abs(velocity.x) <= abs(direction*SPEED):
			velocity.x += SPEED*MOVE_ACCEL*direction
			
			if direction > 0: #right
				last_direction = DIRECTION.right
				if velocity.x > direction*SPEED:
					velocity.x = direction*SPEED
				$AnimatedSprite2D.flip_h = false
				$Attack_Hitbox.scale.x = abs($Attack_Hitbox.scale.x)
	
			elif direction < 0: #left
				last_direction = DIRECTION.left
				if velocity.x < direction*SPEED:
					velocity.x = direction*SPEED
				$AnimatedSprite2D.flip_h = true
				$Attack_Hitbox.scale.x = -abs($Attack_Hitbox.scale.x)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED*STOP_ACCEL)
		
		if Input.is_action_just_pressed(device+"Atk"):
			if can_attack:
				attack()
			
			
		move_and_slide()

func attack():
	$Attack_Hitbox.monitorable = true
	can_attack = false
	$Timer.start()
	

		
func _on_attack_timer_timeout() -> void:
	print("timer timeout")
	$Attack_Hitbox.monitorable = false
	can_attack = true
	$Timer.stop()

func change_animation():
	if velocity.x != 0:
		move = true
	else:
		move = false
	if !$Timer.is_stopped():
		atk = true
	else:
		atk = false
	
	match [move, atk]:
		[false, false]:
			$AnimatedSprite2D.animation = "idle"
			
		[false, true]:
			$AnimatedSprite2D.animation = "still_atk"
		[true, false]:
			$AnimatedSprite2D.animation = "move"
		[true, true]:
			$AnimatedSprite2D.animation = "move_atk"
			
		
	
		
		
		
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

# Jumping in mid-air gave height. Added is_on_floor() to is_action_just_pressed("Jump_1") and is_action_pressed("Jump_1")

# Variable jumping no longer works as not on floor after jumping. Removing is_on_floor from is_action_pressed("Jump_1"). 
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
# 0.1 is best value
# this worked !!

# Jumping right before hitting the ground does not jump
# Jump Buffers
# so i already have jump_timer which always goes up when jump pressed
# if jump_timer < 0.5 upon hitting floor, reset jump_timer to 0.01 and jump
# change if_action_just_pressed to add 'or jump_timer < 0.5'

# fixed numbers so jump feels better
# jump buffer was broken but i fixed it by
# jump_timer only starts increasing when on floor
# so add wall to possible start points

# made wall jump  

# coyote jump has less velocity after falling for longer
# start timer on jump rather on leave?
# Limiting jump to if coyote_timer < 0.1 bad, removed
# Same thing but 0.2 was bad for start as if jump started late in coyote, will have less jump
# jump_in_progress variable and now will also jump if jump_in_progress and jump button set.

# issue: timers and jump rely on consistent frame rates.

# issue: jumping adds to velocity, but if gravity, vertical velocity might be down. 
# fix: if velocity.y > 0.0, set to 0.0 before adding

#issue: how flip attack hitbox?:
#fix: different code to flip hitbox: use absolute values

#issue: hitbox only checks once when attack pressed
#fix: disable on hit or timer end, but keep it on until either of those happen

#issue: cannot get colliders on damage hitbox
#fix: change all hitboxes to area2d

func _on_damage_hitbox_area_entered(area):
	print(area)
	var damage_hitbox = $Damage_Hitbox
	for current_collider in damage_hitbox.get_overlapping_areas():
		print(0)
		if current_collider != $Attack_Hitbox and current_collider.name != "Damage_Hitbox":
			print(0)
			
func _on_attack_hitbox_area_entered(area) -> void:
	print(area)
	var attack_hitbox = $Attack_Hitbox
	for current_collider in attack_hitbox.get_overlapping_areas():
		if current_collider != $Damage_Hitbox and current_collider.name != "Attack_Hitbox":
			attack_hitbox.monitorable = false

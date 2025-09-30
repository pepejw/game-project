extends Node2D
var used_controller = []


var new_player_scene = preload("res://scenes/player.tscn")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if len(used_controller) <= 6:
		get_player_controller()

func get_player_controller() -> void:
	# 0 for keyboard, 1 for controller
	if Input.is_action_just_pressed("Keyboard0_Any"):
		check_controller_used(4,0)
	elif Input.is_action_just_pressed("Keyboard1_Any"):
		check_controller_used(5,0)
	elif Input.is_action_just_pressed("Controller0_Any"):
		check_controller_used(0,1)
	elif Input.is_action_just_pressed("Controller1_Any"):
		check_controller_used(1,1)
	elif Input.is_action_just_pressed("Controller2_Any"):
		check_controller_used(2,1)
	elif Input.is_action_just_pressed("Controller3_Any"):
		check_controller_used(3,1)

func check_controller_used(controller,type) -> void:
	var device = ""
	var nintendo = ""
	print("controller or type")
	print(controller)
	print(type)
	match type:
		0:
			print("keyboard")
			if controller not in used_controller:
				used_controller.append(controller)
				device = "Keyboard"+str(controller)+"_"
			if controller in used_controller:
				
		1:
			print("controller")
			print(used_controller)
			if controller not in used_controller:
				used_controller.append(controller)
				device = "Controller"+str(controller)+"_"
				if Input.get_joy_name(controller).contains("Nintendo"):
					nintendo = "Nintendo_"
	if device != "":
		print("new player start")
		
		var new_player = new_player_scene.instantiate()
		add_child(new_player)
		
		var player = get_child(len(used_controller)+2)
		player.set_script("res://scripts/player_movement.gd")
		player.set_process(true)
		player.position =  Vector2(-50, 144)

		

extends KinematicBody2D
#this is for controlling the mob as an entity NPC's in turn interact with this mob

#steering vars
export var max_speed: = 120.0
export var slow_radius: = 30.0
var _velocity: = Vector2.ZERO
const DISTANCE_THRESHOLD: = 3.0

var target_position: Vector2
var track_cursor := false

#stats holder for the mob
var stats = {"speed":100}

#list of npcs that makes up the mob? 
var members = []

#state of mob
var state = "idle"

func _ready():
	set_physics_process(false)

# MOVEMENT 

func _unhandled_input(event):
	#Mouse steering
	if event is InputEventMouseButton:
		if event.pressed: #follow cursor
			track_cursor = true
			set_physics_process(true)
		if event.is_action_released('click'): #reach click point
			#a target object may be placed on map upon mouse release
			track_cursor = false
			target_position = get_global_mouse_position() #GUI will add target on objective
			set_physics_process(true)

func _physics_process(delta):
	
	if track_cursor:
		target_position = get_global_mouse_position()
	var dist = global_position.distance_to(target_position)
	
	if dist < DISTANCE_THRESHOLD:
		set_physics_process(false)
		return
	
	_velocity = Steering.arrive_to(
		_velocity,
		global_position,
		target_position,
		max_speed,
		slow_radius)
	
	_velocity = move_and_slide(_velocity)

#GROUP

func chant(message):
	var nearby_bodies = $ChantArea.get_overlapping_bodies()
	for body in nearby_bodies:
		pass
	#for npc in bodies in ChantArea call 
	pass

func gain_member(npc):
	members.append(npc)

func lose_member(npc):
	pass

#changes the mobs state and acts accordingly	
func change_state(new_state):
	if state == "idle":
		pass
	pass

#trigger a npc to execute a random action?
func trigger_npc_action():
	pass

extends KinematicBody2D

# dictionary for any stats that may vary from NPC to NPC
var stats = { "speed" : 100 }
# *current* velocity of the NPC, used to move the NPC during _physics_process. To manually move the NPC, set this instead of calling a move function directly.
var velocity = Vector2.ZERO

func _ready():
	# random number generation will always result in the same values each time the script is restarted unless we call this function to generate a time-based seed
	randomize()
	
	# When MoveTimer is triggered, the NPC should start moving
	$MoveTimer.connect("timeout", self, "start_move")
	# When WaitTimer is triggered, the NPC should stop moving
	$WaitTimer.connect("timeout", self, "stop_move")
	# Each timer should start the other so the NPC alternates between moving and standing still
	$MoveTimer.connect("timeout", $WaitTimer, "start")
	$WaitTimer.connect("timeout", $MoveTimer, "start")

func _physics_process(delta):
	# move the NPC by whatever the velocity was set to in other functions
	move_and_slide(velocity)

func start_move():
	# start moving the NPC in a random cardinal direction. This could be easily changed to moving in a completely random direction if people would prefer.
	var dir = randf() # generate a random number to determine which of four directions we will go in
	# divide the possible values of dir into four equal parts, and assign a direction to each
	if dir < 0.25:
		velocity = Vector2.RIGHT * stats["speed"]
	elif dir < 0.5:
		velocity = Vector2.LEFT * stats["speed"]
	elif dir < 0.75:
		velocity = Vector2.UP * stats["speed"]
	else:
		velocity = Vector2.DOWN * stats["speed"]
	
func stop_move():
	# stop moving the NPC
	velocity = Vector2.ZERO
	
# begin an attack at the specified angle in radians
func attack_angle(angle):
	$Attack.rotation = angle
	$AnimationPlayer.play("attack")

# begin an attack in the direction of the specified vector; for example, attack_vector(Vector2.RIGHT) begins a right-facing attack
func attack_vector(direction):
	attack_angle(atan2(direction.y, direction.x))

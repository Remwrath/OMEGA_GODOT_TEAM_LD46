class_name NPC
extends KinematicBody2D

enum Type {
	INSTIGATOR,
	PAWN,
	DEMIHUMAN, # Can break down barricades.
	CLERIC, # Increase mob cohesion.
	ELF, # Increase mob agility.
	ALCHEMIST, # Ability to buff speed.
	SORCERER, # Wall spell to block knights.
	# Wizard(male) witch(female) sorcerer(agnostic)
	# Keep types agnostic
}

const SLOGANS = [
	"Eggs", #placeholder
	"Milk",
	"Bread"
]

var type_stats = {
	Type.INSTIGATOR : {"speed" : 50, "commitment" : 12, "in_mob" : true},
	Type.PAWN : {"speed" : 25},
	Type.DEMIHUMAN : {"speed" : 50},
	Type.CLERIC : {"speed" : 50},
	Type.ELF : {"speed" : 50},
	Type.ALCHEMIST : {"speed" : 50},
	Type.SORCERER : {"speed" : 50},
}

var in_mob = false
var speed = 25
var type = Type.PAWN
var commitment = 0
var trigger_slogans = []
var attack_range = 60

# Dictionary for any stats that may vary from NPC to NPC.
var stats = {}

# Current velocity of the NPC, used to move the NPC during _physics_process.
# To manually move the NPC, set this instead of calling a move function directly.
var velocity = Vector2.ZERO
var target = Vector2.ZERO

var roam_radius = 75
var slow_radius = 5.5
var arrive_distance = 35
var follow = false


func _ready():
	# Random number generation will always result in the same values each
	# time the script is restarted, unless we call this function to
	# generate a time-based seed.
	randomize()
	# Generate random slogans that the npc will react to.
	trigger_slogans = [SLOGANS[randi() % len(SLOGANS) - 1], SLOGANS[randi() % len(SLOGANS) - 1]]
	# When MoveTimer is triggered, the NPC should start moving.
	# warning-ignore-all:return_value_discarded
	$MoveTimer.connect("timeout", self, "start_move")
	# When WaitTimer is triggered, the NPC should stop moving.
	$WaitTimer.connect("timeout", self, "stop_move")
	#when the  AttackTimer triggered check for enemeies in range and attack if can.
	$AttackTimer.connect("timeout", self, "_on_attack_timer")
	$Attack.connect("body_entered", self, "_on_body_entered")
	# Each timer should start the other so the NPC alternates between moving and standing still.
	$MoveTimer.connect("timeout", $WaitTimer, "start")
	$WaitTimer.connect("timeout", $MoveTimer, "start")

	# Randomise the timers.
	$MoveTimer.wait_time = rand_range(0.0, 2.0)
	$WaitTimer.wait_time = rand_range(0.0, 2.0)
	$AttackTimer.wait_time = rand_range(0.0, 2.0)

	# Set states for type overriding defaults.
	set_stats(type_stats[type])
	test_commitment()
#	print(type," ", commitment," ", in_mob)

# Move the NPC by whatever the velocity was set to in other functions.
func _physics_process(_delta):
	if in_mob:
		#REPLACE if npc is already inside mobs' chant_ring, they don't need to move to the exact center!
		target = get_mob().global_position
	velocity = Steering.arrive_to(
		velocity,
		global_position,
		target,
		speed) # Add mass for dragging.
	move_and_slide(velocity)
	
	#this causes big issues
#	if global_position.distance_to(target) < arrive_distance and not follow:
#		set_physics_process(false)
#		$MoveTimer.start()
		# Set up timer and wander when not in_mob or for in_mob but with distance to mob larger than x.


func _process(delta):
	$Label.text = str(commitment)
	if in_mob:
		$TempSprite.default_color = Color(.2, .9, .2)
		
	if not in_mob:
		$TempSprite.default_color = Color(.2, .2, .2)


func set_stats(stats):
	for stat in stats:
		self[stat] = stats[stat]


func _follow_mob():
	follow = true
	set_physics_process(true)


func _unfollow_mob():
	# Check in which range it is, it may wander in a given radius.
	follow = false


func get_mob():
	var mob = get_node("../Mob")
	return mob


func chant(message):
	var nearby_bodies = $Attack.get_overlapping_bodies()
	for body in nearby_bodies:
		if body.is_in_group("npc"):
			body.react(message, self)


# Receive message from chant and decide if joining mob
func react(message, mob):
	if trigger_slogans.find(message):
		commitment += 5
#		print(name + " has increased his commitment to " + str(commitment))
	
	test_commitment()

	# Receive message from chant and decide if joining mob.
	# Mock code to join always and test following.
	#join_mob()


# Call to make the NPC join the mob.
func join_mob():
	#Global.get_mob().gain_member(self);
	if in_mob:
		return

	get_mob().gain_member(self);
	self.in_mob = true
	$TempSprite.default_color = "f80202" # temp


# Call to make the NPC leave the mob.
func leave_mob():
	get_mob().lose_member(self)
	self.in_mob = false
	$TempSprite.default_color = "6680ff" # temp


func start_move():
	$WaitTimer.wait_time = rand_range(0.0, 2.0)
	if self.in_mob:
		return

	randomize()
	var random_angle = randf() * TAU
	var random_radius = (randf() * roam_radius) / 2 + roam_radius / 2
	target = global_position + Vector2(cos(random_angle) * random_radius, sin(random_angle) * random_radius)
	slow_radius = target.distance_to(global_position) / 2
	_physics_process(true)


func stop_move():
	$MoveTimer.wait_time = rand_range(0.0, 2.0)
	_physics_process(false)


# Begin an attack at the specified angle in radians.
func attack_angle(angle):
	$Attack.rotation = angle
	$AnimationPlayer.play("attack")


# Begin an attack in the direction of the specified vector.
# For example, attack_vector(Vector2.RIGHT) begins a right-facing attack.
func attack_vector(direction):
	attack_angle(atan2(direction.y, direction.x))


func _on_attack_timer():
	$Attack.set_physics_process(true)
	$AttackTimer.wait_time = rand_range(1.0, 2.0)
	$AttackTimer.start()

func _on_body_entered(body):
	if body.get("in_mob") != null and in_mob != body.in_mob and ((in_mob and body.commitment < 0) or (!in_mob and body.commitment >= 10)):
		attack_vector(body.position - position)
		body._on_attacked(1) # Use specific NPC damage.
#	$Attack.set_physics_process(false)


func _on_attacked(damage):
	commitment -= damage
	test_commitment()


func test_commitment():
	if commitment < 10:
		if in_mob:
			leave_mob()
	elif commitment >= 10:
		if not in_mob:
			join_mob()
	

#NOT USED
func buff(buff_range):
	pass

extends Node2D

# Reference to level is saved as a variable so levels can be swapped out
# without needing to alter references elsewhere in code.
onready var level = $TestLevel

func _ready():
	# Thinking of an instagator as a NPC type that is always a mob member (there should only be one).
	for i in range(20):
		add_npc(Vector2(rand_range(-100, 100), rand_range(-100, 100)), NPC.Type.INSTIGATOR)
	generate_random_npcs(10)


func add_npc(position: Vector2, type):
	var new_npc = load("res://NPC.tscn")
	var npc_instance = new_npc.instance()
	npc_instance.type = type
	npc_instance.position = position
	add_child(npc_instance)
	if npc_instance.type == NPC.Type.INSTIGATOR:
		$Mob.gain_member(new_npc)


func generate_random_npcs(amount):
	for _i in range(amount):
		var type = NPC.Type.DEMIHUMAN if randf() < 0.5 else NPC.Type.CLERIC
		var npc_pos = Vector2(rand_range(-500, 500), rand_range(-500, 500))
		# If the NPC would spawn inside a wall, pick a different spawn point.
		while not is_valid_spawn_point(npc_pos):
			npc_pos = Vector2(rand_range(-500, 500), rand_range(-500, 500))
		add_npc(npc_pos, type)


# Checks whether a chosen spawn point is inside a wall.
func is_valid_spawn_point(coords):
	var tile_coords = level.get_node("Tilemap").world_to_map(coords)
	var cell = level.get_node("Tilemap").get_cellv(tile_coords)
	return (cell == -1) # If the cell has an index of -1, it's empty and therefore a valid spawn point.

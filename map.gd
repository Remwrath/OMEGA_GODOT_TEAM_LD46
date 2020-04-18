extends Node2D

func _ready():
	print("map file has been loaded lol")
	#thinking of an instagator as a npc type that is always a mob member (there should only be one)
	add_npc(Vector2(100, 100), Global.NPC_INSTIGATOR)
	generate_random_npcs(10)

func add_npc(position:Vector2, type:String):
	var new_npc = load("res://NPC.tscn")
	var npc_instance = new_npc.instance()
	npc_instance.stats.type = type
	npc_instance.position = position
	self.add_child(npc_instance)
	
func generate_random_npcs(amount):
	for i in range(amount):
		add_npc(Vector2(rand_range(1, 800), rand_range(1, 800)), Global.NPC_TYPES[rand_range(0,1)])

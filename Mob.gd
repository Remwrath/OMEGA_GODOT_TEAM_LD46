#this is for controlling the mob as an entity NPC's in turn interact with this mob
extends Node2D

#stats holder for the mob
var stats = {"speed":100}

#list of npcs that makes up the mob? 
var members = []

#state of mob
var state = "idle"

func _ready():
	pass # Replace with function body.
	
func _input(event):
   if event is InputEventMouseMotion:
	   self.position = event.position

func gain_member(npc):
	members.append(npc)

func lose_member(npc):
	pass

func move(direction:Vector2):
	pass

#changes the mobs state and acts accordingly	
func change_state(new_state):
	if state == "idle":
		pass
	pass

#trigger a npc to execute a random action?
func trigger_npc_action():
	pass

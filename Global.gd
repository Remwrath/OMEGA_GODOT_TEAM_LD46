# script for easy global access and sharing
#access from any script with Global.

extends Node

#npc types for consistency/autocomplete
const NPC_INSTIGATOR = "instigator"
const NPC_DEMIHUMAN = "demihuman" # Can break down barricades
const NPC_CLERIC = "cleric" #Increase mob cohesion
const NPC_ELF =  "elf" #Increase mob agility
const NPC_ALCHEMIST = "alchemist" #Ability to buff speed
const NPC_SORCERER = "sorcerer" #Wall spell to block knights
const NPC_TYPE = "?" #Spell to push back knights
#wizard(male) witch(female) sorcerer(agnostic)
#keep types agnostic
#define stats for each?
const NPC_TYPES = [NPC_DEMIHUMAN, NPC_CLERIC]

func _ready():
	pass # Replace with function body.

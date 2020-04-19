extends CanvasLayer

const icon = preload("res://Icon.tscn")
var abilityStack = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func registerAbility(ability):
	for icon in abilityStack:
		if icon.title == ability.title:
			icon.count += 1
			return
	for i in range(abilityStack.size()):
		if abilityStack[i].title == 'empty':
			abilityStack[i].parseAbility(ability)
			return
	var i = icon.instance()
	i.setButton(abilityStack.size())
	i.parseAbility(ability)
	abilityStack.insert(i)
	$Abilities.add_child(i)
	
func removeAbility(ability):
	for icon in abilityStack:
		if icon.title == ability.title:
			icon.removeAbility()

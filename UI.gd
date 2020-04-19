extends CanvasLayer

const icon = preload("res://Icon.tscn")

var ability_stack = []

func register_ability(ability):
	for icon in ability_stack:
		if icon.title == ability.title:
			icon.count += 1
			return
	for i in range(ability_stack.size()):
		if ability_stack[i].title == "empty":
			ability_stack[i].parse_ability(ability)
			return
	var i = icon.instance()
	i.set_button(ability_stack.size())
	i.parse_ability(ability)
	ability_stack.insert(i)
	$Abilities.add_child(i)


func remove_ability(ability):
	for icon in ability_stack:
		if icon.title == ability.title:
			icon.remove_ability()

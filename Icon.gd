extends Control

# fill this with names of the ui buttons
const buttons = []
const buttonNames = []
var buttonCode = ''

onready var cd = $cooldown
export var cooldown = 10
export var title = 'empty'
export var count = 0
signal clicked
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = cooldown
	cd.rect_size.x = 0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer = max(0, timer-delta)
	cd.rect_size.x = 32 * (timer/cooldown)

func startCooldown():
	timer = cooldown

func parseAbility(ability):
	cooldown = ability.cooldown
	title = ability.title
	$icon.disabled = false
	$icon.texture_normal = ability.get_node("icon").texture
	$icon.texture_hover = ability.get_node("iconHover").texture
	count = 1
	timer = 0

func removeAbility():
	count = max(0, count-1)
	if count == 0:
		title = 'empty'
		$icon.disabled = true

func setButton(n):
	$button.text = buttonNames[n]
	buttonCode = buttons[n]

func _input(event):
	if count>0 and (event.is_pressed() and event.is_action(buttonCode) or event is InputEventMouseButton and event.pressed):
		emit_signal("clicked")

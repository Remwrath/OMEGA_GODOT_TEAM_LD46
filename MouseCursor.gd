extends Position2D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$IdleSprite.visible = true
	$ClickSprite.visible = false
	$AnimationPlayer.playback_speed = 1.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		$AnimationPlayer.play("click")
#	if event.is_action_pressed("secondary_click"):
#		visible = false
#	if event.is_action_released("secondary_click"):
#		visible = true

func _process(delta: float) -> void:
	position = get_global_mouse_position()

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "click":
		$AnimationPlayer.play("idle")


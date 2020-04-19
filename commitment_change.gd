extends Node2D

var damage

func _ready():
	$Label.text = str(damage)
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_done")
	if damage > 0:
		$AnimationPlayer.assigned_animation = "commitment_increase"
	else:
		$AnimationPlayer.assigned_animation = "commitment_decrease"
	$AnimationPlayer.play()
	
func _on_animation_done():
	queue_free();


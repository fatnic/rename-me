extends Sprite

export (bool) var collect = true


func _ready():
	$AnimationPlayer.play("light_flash")
	

func on_collect(collector):
	$radio.play()
	$interactable.collect = false
	$AnimationPlayer.stop()
	remove_child($glow)
	remove_child($red_light)
extends Node2D


func _ready():
	$AnimationPlayer.play("explode")
	$bang.play()
	

func _on_bang_finished():
	queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	$Sprite.visible = false


func _on_aoe_body_entered(body):
	
	if body.is_in_group("explosive"):
		body.call_deferred("explode")
		
	
	if body.is_in_group("destructable"):
		body.call_deferred("destroy")
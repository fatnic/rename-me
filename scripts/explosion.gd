extends Node2D

var power = 20


func _ready():
	power = $aoe/CollisionShape2D.shape.radius
	$AnimationPlayer.play("explode")
	

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
	

func _on_aoe_body_entered(body):
	if body.is_in_group("explosive"): body.call_deferred("explode")
	if body.is_in_group("destructable"): body.call_deferred("destroy", position, power)
	
	if body.is_in_group("player"):
		body.integrated_rot = body.rotation
		var dxy = (body.position - position).normalized()
		body.apply_impulse(global_position, dxy * power)
		body.call_deferred("change_health", -power)
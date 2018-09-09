extends RigidBody2D

var power = 20
var tilemap

func _ready():
	power = $CollisionShape2D.shape.radius 
	tilemap = get_tree().get_root().get_node("main/level/environment")
	$AnimationPlayer.play("explode")
		

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


func _integrate_forces(state):
	
	for i in range(state.get_contact_count()):
		var obj = state.get_contact_collider_object(i)
		
		if obj.is_in_group("explosive"): obj.call_deferred("explode")
		if obj.is_in_group("destructable"): obj.call_deferred("destroy", position, power)
	
		if obj.is_in_group("player"):
			obj.integrated_rot = obj.rotation
			var dxy = (obj.position - position).normalized()
			obj.apply_impulse(global_position, dxy * power)
			obj.call_deferred("change_health", -power)
		
		if obj.is_in_group("environment"):
			var hit = tilemap.world_to_map(state.get_contact_local_position(i))
			tilemap.replace_tile(hit)	
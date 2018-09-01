extends RigidBody2D

export (int) var sight_range = 100
export (PackedScene) var ammo

var target = null
var on_cooldown = false

signal fire_weapon

func _ready():
	$range/CollisionShape2D.shape.radius = sight_range


func _process(delta):
				
	if not on_cooldown and target and $line_of_sight.seen:
		on_cooldown = true
		$cooldown.start()
		emit_signal("fire_weapon", ammo, target, position + Vector2(-4, 2), Vector2(1, 0))
		

func _on_range_body_entered(body):
	target = body
	$line_of_sight.target = body


func _on_range_body_exited(body):
	target = null
	$line_of_sight.target = null


func _on_cooldown_timeout():
	on_cooldown = false
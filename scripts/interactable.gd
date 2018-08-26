extends Area2D

var parent = null

var interacting = null

var collect = false
var grapple = false


func _ready():
	
	parent = get_parent()
	
	if parent.get("interact_radius"): 
		$CollisionShape2D.shape.radius = parent.interact_radius
	
	_check_parent_var("collect")
	_check_parent_var("grapple")
		
		
func _check_parent_var(name):
	if parent.get(name):
		assert(parent.has_method("on_%s" % name))
		set(name, true)
		
		
func _physics_process(delta):
		
		if interacting:
			
			if collect and Input.is_action_just_pressed("collect"):
				parent.call_deferred("on_collect", interacting)
			
			if grapple and Input.is_action_just_pressed("grapple"):
				parent.call_deferred("on_grapple", interacting)
				
		
func _on_interactable_body_entered(body):
	interacting = body
	print("%s is interacting with %s" % [body.get_name(), parent.get_name()])


func _on_interactable_body_exited(body):
	interacting = null
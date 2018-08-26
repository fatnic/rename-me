extends RigidBody2D

export (int) var interact_radius = 8

export (bool) var collect = true
export (bool) var grapple = false


func on_collect(collector):
	print("collected by %s" % collector.get_name())


func on_grapple(grappler):
	print("grappled by %s" % grappler.get_name())
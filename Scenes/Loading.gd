extends Position2D


func _physics_process(delta):
	rotation_degrees += delta * 300

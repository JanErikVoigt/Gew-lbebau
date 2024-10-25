@tool
extends Node3D

@export var shape: Vector2 = Vector2.ONE * 4
@export var circumcenter: Vector2 = -Vector2.ONE
@export var vis_dots : int = 120


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# 0. clamp exports
	circumcenter = circumcenter.clamp(Vector2.ONE * (-100), Vector2.ZERO)
	vis_dots = max(3,vis_dots)
	
	# 1. shape
	$Bogen.shape = Vector2(shape.x/2,shape.y)
	$Bogen2.shape = Vector2(shape.x/2,shape.y)

	# 2. circumcenter
	$Bogen.circumcenter = circumcenter
	$Bogen2.circumcenter = circumcenter
	
	# 3. vis dots
	var vis_dots_side = floor(vis_dots / 2)
	$Bogen.vis_dots = max(2, vis_dots_side)
	$Bogen2.vis_dots = max(2, vis_dots-vis_dots_side)

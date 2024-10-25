@tool
extends Node3D

@export var shape: Vector3 = Vector3.ONE * 4
@export var circumcenter: Vector2 = -Vector2.ONE
@export var vis_dots: int = 240




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# 0. clamp exports
	circumcenter = circumcenter.clamp(Vector2.ONE * (-100), Vector2.ZERO)
	vis_dots = max(3,vis_dots)
	
	$DoppelBogenBack.shape = Vector2(shape.x,shape.y)
	$DoppelBogenFront.shape = Vector2(shape.x,shape.y)
	$DoppelBogenFront.transform.origin = Vector3.FORWARD * shape.z/2
	$DoppelBogenBack.transform.origin  = Vector3.BACK * shape.z/2
	
	# 2. circumcenter
	$DoppelBogenFront.circumcenter = circumcenter
	$DoppelBogenBack.circumcenter = circumcenter
	
	# 3. vis dots
	$DoppelBogenFront.vis_dots = max(2, floor(vis_dots / 2))
	$DoppelBogenBack.vis_dots = max(2, vis_dots-floor(vis_dots / 2))

	#print($"DoppelBogenBack/Bogen".arc_len())
	#print($"DoppelBogenBack/Bogen".is_circle())
	

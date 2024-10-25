@tool
extends Node3D


@export var bricks_placed = 100
@export var brick_height_offset = 0.85
@export var radius = 8.0
#var backstein_transforms

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bricks_placed = 100
	#next_repeat_z_offset = 0.36
		
	
	
func replace_bricks():
	print("replace bricks")
	print($MultiMeshBackstein.multimesh.instance_count)
	$MultiMeshBackstein.multimesh.instance_count = 0


	var refpoint = -$arch_centerpoint_rightside.transform.origin
	
	var start_angle = asin(refpoint.y / radius)
	var angle_offset = atan(brick_height_offset/radius)
	var end_angle = acos(refpoint.x / radius )
	
	var bricks_until_at_top = floor((end_angle - start_angle) / angle_offset)
	bricks_placed = bricks_until_at_top
	$MultiMeshBackstein.multimesh.instance_count = bricks_placed
	for i in range(bricks_placed):
		var t  = Transform3D()
		t = t.translated(Vector3.RIGHT * radius)
		t = t.rotated(Vector3.BACK,i * angle_offset + start_angle)
		t = t.translated($arch_centerpoint_rightside.transform.origin)
		#t = t.translated(Vector3.RIGHT * radius)
	#	var t = backstein_transforms[i % backstein_transforms.size()]
	#	t = t.translated( Vector3.UP * (next_repeat_z_offset * (i / backstein_transforms.size() )))
		$MultiMeshBackstein.multimesh.set_instance_transform(i, t)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	#TODO condition also when anything changed...
	if $MultiMeshBackstein.multimesh.instance_count != bricks_placed:
		replace_bricks()

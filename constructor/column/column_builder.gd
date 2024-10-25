@tool
extends Node3D


@export var bricks_placed = 100
@export var next_repeat_z_offset = 0.36

var backstein_transforms

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass#replace_bricks()
	bricks_placed = 100
	next_repeat_z_offset = 0.36
		
	
	
func replace_bricks():
	print("replace bricks")
	print($MultiMeshBackstein.multimesh.instance_count)
	$MultiMeshBackstein.multimesh.instance_count = 0
	backstein_transforms = []
	for brick in $layers_scheme.get_children():
		backstein_transforms.push_back(brick.transform)
			
		
	$MultiMeshBackstein.multimesh.instance_count = bricks_placed
	for i in range(bricks_placed):
		var t = backstein_transforms[i % backstein_transforms.size()]
		t = t.translated( Vector3.UP * (next_repeat_z_offset * (i / backstein_transforms.size() )))
		$MultiMeshBackstein.multimesh.set_instance_transform(i, t)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	#TODO condition also when anything changed...
	if $MultiMeshBackstein.multimesh.instance_count != bricks_placed:
		replace_bricks()

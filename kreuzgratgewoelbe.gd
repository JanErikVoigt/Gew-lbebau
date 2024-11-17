@tool
extends Node3D

@export var shape : Vector3 = Vector3i(10.0,6.0,10.0)

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	update_shape()
	
	
func update_shape():
	pass
	#TODO assert height >= width,length 
	assert(shape.z > 0.0)
	assert(shape.x > 0.0)
	assert(shape.y > 0.0)
	assert(shape.y * 2.0 <= shape.x)
	assert(shape.y * 2.0 <= shape.z)
	
	$Bogen.transform.origin = Vector3.BACK * shape.z/2.0
	$Bogen4.transform.origin = Vector3.BACK * shape.z/2.0
	
	$Bogen3.transform.origin = Vector3.LEFT * shape.x/2.0
	$Bogen6.transform.origin = Vector3.LEFT * shape.x/2.0
	
	$Bogen5.transform.origin = Vector3.FORWARD * shape.z/2.0
	$Bogen8.transform.origin = Vector3.FORWARD * shape.z/2.0
	
	$Bogen7.transform.origin = Vector3.RIGHT * shape.x/2.0
	$Bogen2.transform.origin = Vector3.RIGHT * shape.x/2.0
	
	var bogen_shape = Vector2(shape.y,shape.y)
	
	$Bogen.shape = bogen_shape
	$Bogen2.shape = bogen_shape
	$Bogen3.shape = bogen_shape
	$Bogen4.shape = bogen_shape
	$Bogen5.shape = bogen_shape
	$Bogen6.shape = bogen_shape
	$Bogen7.shape = bogen_shape
	$Bogen8.shape = bogen_shape
	
	var fugen_offset_diag = 0.006 #TODO calc with angle!
	var fod = fugen_offset_diag
	
	$"Bogen Section Cut 2".length_arch = shape.z/2.0 - fod
	$"Bogen Section Cut 3".length_arch = -shape.x/2.0 + fod
	$"Bogen Section Cut 4".length_arch = shape.x/2.0 - fod
	$"Bogen Section Cut 5".length_arch = -shape.z/2.0 + fod
	$"Bogen Section Cut 6".length_arch = shape.z/2.0 - fod
	$"Bogen Section Cut 7".length_arch = -shape.x/2.0 + fod
	$"Bogen Section Cut 8".length_arch = -shape.z/2.0 + fod
	$"Bogen Section Cut 9".length_arch = shape.x/2.0 - fod
	
	
	

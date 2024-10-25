@tool
extends Node3D

## 0=round, greater -> flatter.
## Radius or Arch = max(control_shape.x/2,control_shape.y) + exp(roundness) - 1 
@export_range(0, 5,0.05,"or_greater") var roundness = 0.0

@export var control_shape = Vector2(16,4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Arch.roundness = roundness
	$Arch2.roundness = roundness
	
	$Arch.control_shape = Vector2(control_shape.x/2,control_shape.y)
	$Arch2.control_shape = Vector2(control_shape.x/2,control_shape.y)
	
	

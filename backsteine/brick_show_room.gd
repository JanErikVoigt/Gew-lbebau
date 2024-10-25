@tool
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var mm = $"Selected Showroom".multimesh
	
	for i in range(mm.instance_count):
		mm.set_instance_transform(i, Transform3D().translated(Vector3.RIGHT * i * 0.4))
		
		mm.set_instance_color(i, Color("#AC5939"))
		mm.set_instance_custom_data(i, Color(1,0,0,0))
		
	mm.set_instance_custom_data(1, Color(0.5,0,0))
	
	
	mm.set_instance_custom_data(2, Color(0.9,0.08,0))
	mm.set_instance_custom_data(3, Color(0.9,0,0.08))
	mm.set_instance_custom_data(4, Color(0.9,0.08,0.08))

#source: https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html
# shading:
# in vec4 INSTANCE_CUSTOM
# in int INSTANCE_ID

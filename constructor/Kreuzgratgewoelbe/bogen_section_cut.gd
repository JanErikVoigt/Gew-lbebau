@tool
extends MultiMeshInstance3D

@export_node_path var arch : NodePath
@export_range(-20,20,0.1) var length_arch : float = 6
@export_node_path var cut_surface : NodePath

func _ready():
	multimesh.instance_count = 10000
	for i in range(10000):
		multimesh.set_instance_transform(i, Transform3D())
		multimesh.set_instance_custom_data(i, Color(1,1,1,1))
		multimesh.set_instance_color(i, Color("a5512f"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if arch == null:
		multimesh.visible_instance_count = 0
		return
	
	var bogen = get_node(arch)
	var shape = Vector3(bogen.shape.x, bogen.shape.y, length_arch)
	
	#print("shape",shape)
	
	var arc_len_1 = bogen.arc_len()
	var brick_height = 0.08 + 0.01
	var brick_length = 0.3 + 0.01
	
	
	var i_brick = 0
			
	for i_arc in range(floor(arc_len_1 / brick_height)):
		var dist_from_bot = i_arc * brick_height
		#$"DoppelBogenBack".transform * $"DoppelBogenBack/Bogen2".transform * 
		var t_arc = bogen.pos_on_arc(dist_from_bot)
		
		var bricks_per_row = ceil(abs(shape.z) / brick_length)
		var bricks_per_row_offset = ceil((abs(shape.z)-0.5*brick_length) / brick_length)
		var bricks_more = bricks_per_row_offset - bricks_per_row
		var bricks_this_row = bricks_per_row + (i_arc%2)*bricks_more
		for i_row in range(bricks_this_row):
			
			var row_pos = brick_length * i_row + brick_length / 2 * (i_arc % 2)
			
			var t = t_arc.translated(Vector3.FORWARD * row_pos)
			
			if shape.z < 0:
				t = t.translated(Vector3.BACK * abs(shape.z))
			
			t = bogen.transform * t
			multimesh.set_instance_transform(i_brick, t)
			multimesh.set_instance_custom_data(i_brick, Color(1,0,0))

			var is_last = (i_row == bricks_this_row -1)
			if is_last:
				var remaining_wall = abs(shape.z) - i_row * brick_length - brick_length / 2 * ((i_arc) % 2)
				var brick_fraction = remaining_wall / brick_length
				multimesh.set_instance_custom_data(i_brick, Color(brick_fraction,0,0))
			
			i_brick += 1
		
		if (i_arc % 2) == 1:
			var t = t_arc
			if shape.z < 0:
				t = t.translated(Vector3.BACK * abs(shape.z))
			t = bogen.transform * t
			multimesh.set_instance_transform(i_brick, t)
			multimesh.set_instance_custom_data(i_brick, Color(0.5,0,0))
			i_brick += 1
			
			
	
	multimesh.visible_instance_count = i_brick

	cut_bricks_using_surface()


func cut_bricks_using_surface():
	pass
	#cut_surface
	if cut_surface != null:
		var cut_surface_transform_inv = get_node(cut_surface).transform.inverse()
		
		for i_brick in range(multimesh.instance_count):
			var brick_t = multimesh.get_instance_transform(i_brick)
			
			var t_along_cutsurface = cut_surface_transform_inv * brick_t.origin
			
			if t_along_cutsurface.z > 0:
				#var last_t = multimesh.get_instance_transform(multimesh.visible_instance_count-1)
				multimesh.set_instance_transform(i_brick, Transform3D())
				#multimesh.visible_instance_count -= 1
				#i_brick -= 1
			#print(t_along_cutsurface)
		#print(cut_surface_transform_inv)

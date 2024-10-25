@tool
extends MultiMeshInstance3D


@export_node_path var bogen1 
@export_node_path var bogen2


func _ready():
	multimesh.instance_count = 10000
	for i in range(10000):
		multimesh.set_instance_transform(i, Transform3D())
		multimesh.set_instance_custom_data(i, Color(1,1,1,1))
		multimesh.set_instance_color(i, Color("a5512f"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var shape = get_parent().shape
	
	var bogen = get_node(bogen1)
	
	#print("shape",shape)
	
	var arc_len_1 = bogen.arc_len()
	var brick_height = 0.08 + 0.01
	var brick_length = 0.3 + 0.01
	
	
	var i_brick = 0
	
	#for i_arc in range(floor(arc_len_1 / brick_height)):
		#var dist_from_bot = i_arc * brick_height
		#var t_arc = $"DoppelBogenBack/Bogen".pos_on_arc(dist_from_bot)
		#
		#var bricks_per_row = ceil(shape.z / brick_length)
		#var bricks_per_row_offset = ceil((shape.z-0.5*brick_length) / brick_length)
		#var bricks_more = bricks_per_row_offset - bricks_per_row
		#var bricks_this_row = bricks_per_row + (i_arc%2)*bricks_more
		#for i_row in range(bricks_this_row):
			#
			#var row_pos = - shape.z/2 + brick_length * i_row + brick_length / 2 * (i_arc % 2)
			#
			#var t = t_arc.translated(Vector3.FORWARD * row_pos)
			#
			#$bricks.multimesh.set_instance_transform(i_brick, t)
			#$bricks.multimesh.set_instance_custom_data(i_brick, Color(1,1,1))
#
			#var is_last = (i_row == bricks_this_row -1)
			#if is_last:
				#var remaining_wall = shape.z - i_row * brick_length - brick_length / 2 * ((i_arc) % 2)
				#var brick_fraction = remaining_wall / brick_length
				#$bricks.multimesh.set_instance_custom_data(i_brick, Color(brick_fraction,1,1))
			#
			#i_brick += 1
		#
		#if (i_arc % 2) == 1:
			#$bricks.multimesh.set_instance_transform(i_brick, t_arc.translated( -Vector3.FORWARD *shape.z/2))
			#$bricks.multimesh.set_instance_custom_data(i_brick, Color(0.5,1,1))
			#i_brick += 1
			#
			
	for i_arc in range(floor(arc_len_1 / brick_height)):
		var dist_from_bot = i_arc * brick_height
		#$"DoppelBogenBack".transform * $"DoppelBogenBack/Bogen2".transform * 
		var t_arc = bogen.pos_on_arc(dist_from_bot)
		
		var bricks_per_row = ceil(shape.z / brick_length)
		var bricks_per_row_offset = ceil((shape.z-0.5*brick_length) / brick_length)
		var bricks_more = bricks_per_row_offset - bricks_per_row
		var bricks_this_row = bricks_per_row + (i_arc%2)*bricks_more
		for i_row in range(bricks_this_row):
			
			var row_pos = - shape.z/2 + brick_length * i_row + brick_length / 2 * (i_arc % 2)
			
			var t = t_arc.translated(Vector3.BACK * row_pos)
			
			multimesh.set_instance_transform(i_brick, t)
			multimesh.set_instance_custom_data(i_brick, Color(1,1,1))

			var is_last = (i_row == bricks_this_row -1)
			if is_last:
				var remaining_wall = shape.z - i_row * brick_length - brick_length / 2 * ((i_arc) % 2)
				var brick_fraction = remaining_wall / brick_length
				multimesh.set_instance_custom_data(i_brick, Color(brick_fraction,1,1))
			
			i_brick += 1
		
		if (i_arc % 2) == 1:
			multimesh.set_instance_transform(i_brick, t_arc.translated( -Vector3.FORWARD *shape.z/2))
			multimesh.set_instance_custom_data(i_brick, Color(0.5,1,1))
			i_brick += 1
			
			
	
	multimesh.visible_instance_count = i_brick
	#pos_on_arc

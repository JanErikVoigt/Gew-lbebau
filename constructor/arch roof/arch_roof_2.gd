@tool
extends Node3D


@export var box = Vector3(16,8,6)
# back front left right
@export var height_sides_ratio = Vector4.ONE
@export var roundness_sides = Vector4.ZERO
@export var roundness_daigs = Vector2.ZERO
@export var roundness_uppercross = Vector4.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	height_sides_ratio = height_sides_ratio.clamp(Vector4.ZERO, Vector4.ONE)
	roundness_sides = roundness_sides.clamp(Vector4.ZERO, Vector4.ONE)
	roundness_daigs = roundness_daigs.clamp(Vector2.ZERO, Vector2.ONE)
	
	
	$controlshape.mesh.size = box
	$controlshape.transform = Transform3D().translated(Vector3.UP * box.y/2)
	
	$back.transform = Transform3D().translated(Vector3.BACK * box.z/2)
	$front.transform = Transform3D().translated(Vector3.FORWARD * box.z/2)
	$left.transform = Transform3D().rotated(Vector3.UP, PI/2).translated(Vector3.LEFT * box.x/2)
	$right.transform = Transform3D().rotated(Vector3.UP, PI/2).translated(Vector3.RIGHT * box.x/2)

	$back.control_shape.y = box.y * height_sides_ratio.x
	$back.control_shape.x = box.x
	$back.roundness = roundness_sides.x
	
	$front.control_shape.y = box.y * height_sides_ratio.y
	$front.control_shape.x = box.x
	$front.roundness = roundness_sides.y

	$left.control_shape.y = box.y * height_sides_ratio.z
	$left.control_shape.x = box.z
	$left.roundness = roundness_sides.z

	$right.control_shape.y = box.y * height_sides_ratio.w
	$right.control_shape.x = box.z
	$right.roundness = roundness_sides.w
	
	
	# dIAGONALS
	var diagv = Vector3(box.x,0,box.z)/2
	var diag1_len = diagv.length()*2
	$diag1.transform = Transform3D().looking_at(diagv).rotated(Vector3.UP,PI/2)
	$diag1.control_shape.x = diag1_len
	$diag1.control_shape.y = box.y
	$diag1.roundness = roundness_daigs.x
	
	var diag_flipped = diagv
	diag_flipped.x = -diag_flipped.x
	$diag2.transform = Transform3D().looking_at(diag_flipped).rotated(Vector3.UP,PI/2)
	$diag2.control_shape.x = diag1_len
	$diag2.control_shape.y = box.y
	$diag2.roundness = roundness_daigs.y
	
	# Kreuz Grat
	# start at top of side_arch and go to top center
	
	$"kreuzgrat back".transform.origin = Vector3.UP * box.y * height_sides_ratio.x
	$"kreuzgrat back".control_shape.y =  box.y * (1-height_sides_ratio.x)
	$"kreuzgrat back".control_shape.x = box.z/2
	
	$"kreuzgrat front".transform.origin = Vector3.UP * box.y * height_sides_ratio.y
	$"kreuzgrat front".control_shape.y =  box.y * (1-height_sides_ratio.y)
	$"kreuzgrat front".control_shape.x = box.z/2
	
	$"kreuzgrat left".transform.origin = Vector3.UP * box.y * height_sides_ratio.z
	$"kreuzgrat left".control_shape.y =  box.y * (1-height_sides_ratio.z)
	$"kreuzgrat left".control_shape.x = box.x/2
	
	$"kreuzgrat right".transform.origin = Vector3.UP * box.y * height_sides_ratio.w
	$"kreuzgrat right".control_shape.y =  box.y * (1-height_sides_ratio.w)
	$"kreuzgrat right".control_shape.x = box.x/2
	
	$"kreuzgrat back".roundness = roundness_uppercross.x
	$"kreuzgrat front".roundness = roundness_uppercross.y
	$"kreuzgrat left".roundness = roundness_uppercross.z
	$"kreuzgrat right".roundness = roundness_uppercross.w
	
	
	# PLACE BRICKS
	
	# 1. construct inbetween grat "filler curve 1"
	var krezgrat_halfway = $"kreuzgrat front".transform * $"kreuzgrat front".get_halfwaypoint()
	var lower_constriction_point = Vector3(box.x,0.0,-box.z)/2
	$"filler curve 1".transform = Transform3D().translated(Vector3(krezgrat_halfway.origin.x,0,krezgrat_halfway.origin.z)).looking_at(lower_constriction_point).rotated_local(Vector3.UP,PI/2)
	$"filler curve 1".control_shape.y = krezgrat_halfway.origin.y
	$"filler curve 1".control_shape.x = $"filler curve 1".transform.origin.distance_to(lower_constriction_point)
	$"filler curve 1".roundness = 0
	
	#2. params
	var brick_height = 0.085
	var brick_len = 0.305
	
	#build bricks
	var bricks_mm =$"Bricks in Triangle".multimesh
	bricks_mm.instance_count = 1000
	for i in range(1000):
		bricks_mm.set_instance_transform(i, Transform3D())
		
	var amount_rows_diag = int(floor($diag1/Arch.get_length_of_arch() / brick_height))
	var amount_rows_front = int(floor($front/Arch.get_length_of_arch() / brick_height))
	var amount_rows = min(amount_rows_diag,amount_rows_front)
	
	var i_brick = 0
	
	for i_col in range(amount_rows):
		var t1 = $diag2/Arch.get_pos_on_arch_from_bottom(i_col * brick_height)
		# OLd, probably wrong: var t1_in_scene = ( $diag1/Arch.transform.inverse() * $diag1.transform.inverse() * t1)
		var t1_in_scene = $diag2.transform * $diag2/Arch2.transform * t1
		
		var t2 = $front/Arch.get_pos_on_arch_from_bottom(i_col * brick_height)
		var t2_in_scene = $front.transform * $front/Arch.transform * t2

		#bricks_mm.set_instance_transform(i*2, t1_in_scene)
		#bricks_mm.set_instance_transform(i*2+1, t2_in_scene)

		# new: get point on same dist on filler_curve 1
		var t3 = $"filler curve 1".get_pos_on_arch_from_bottom(i_col * brick_height)
		var t3_in_scene = $"filler curve 1".transform * t3

		
		#print(t1_in_scene.origin, t2_in_scene.origin)
		var distance_origins = t1_in_scene.origin.distance_to(t2_in_scene.origin)
		if distance_origins > 0.000001:
			var bricks_in_row = ceil(distance_origins / brick_len)
			
			for row_i in range(bricks_in_row):
				var t1_to_t2 = t1_in_scene.looking_at(t2_in_scene.origin, t1_in_scene.basis.y)
				
				# OLD: in straight line:
				# OLD: var brick_t = t1_to_t2.translated_local(Vector3.FORWARD * brick_len * row_i)
			
				# in curve through filler_curve1:
				var ps = [
					t1_in_scene.origin,
					t3_in_scene.origin,
					t2_in_scene.origin
				]
				#var circle_origin = get_circle_from_three_points(t1_in_scene.origin,t3_in_scene.origin,t2_in_scene.origin)
				var circle = circumcenter(ps[2],ps[0],ps[1])
	
				#print(row_i)
				if i_col == 60:
					#$CircleMesh.transform = Transform3D().translated(circle["center"]).looking_at(ps[0], circle["normal"])
					#$CircleMesh.mesh.top_radius = circle["radius"]
					#$CircleMesh.mesh.bottom_radius = circle["radius"]
					pass #TODO
					# OLDER $CircleMesh.transform = Transform3D().translated(circle_origin["center"]).looking_at(circle_origin["center"]+circle_origin["normal"])
					#$CircleMesh.transform = Transform3D().translated(circle_origin["center"]).looking_at(t3_in_scene.origin, circle_origin["normal"])
				#print("circle_origin",circle_origin)
				#var brick_t = Transform3D().translated(circle_origin["center"]).looking_at(t1_in_scene.origin,circle_origin["normal"])
				#var total_angle = 
		
		
				#bricks_mm.set_instance_transform(i_brick, brick_t)
				#i_brick += 1
		else:
			bricks_mm.set_instance_transform(i_brick, t1_in_scene)
			i_brick += 1
		
	
func circumcenter(p1: Vector3, p2: Vector3, p3: Vector3) -> Dictionary:
	# Calculate the midpoints of the sides of the triangle
	var mid_ab = (p1 + p2) / 2
	var mid_bc = (p2 + p3) / 2

	# Vectors corresponding to the sides of the triangle
	var ab = p2 - p1
	var bc = p3 - p2
	var ca = p1 - p3
	var ac = p3 - p1
	
	# Cross product of AB and BC to get the normal to the plane
	var normal = ab.cross(ac) #abXac

	## Find the normal to AB and BC by taking the cross product
	#var ab_normal = normal.cross(ab).normalized()
	#var bc_normal = normal.cross(bc).normalized()
#
	## Parametric equation for the line through AB midpoint and normal to AB
	#var t = ((mid_bc - mid_ab).dot(bc_normal)) / (ab_normal.dot(bc_normal))
#
	## Circumcenter is along the line from the midpoint of AB
	#var circumcenter = mid_ab + ab_normal * t
	#var radius = circumcenter.distance_to(p1)
	#
	#return {
		#"center": circumcenter,
		#"radius": radius,
		#"normal": normal
	#}
	
	# from https://gamedev.stackexchange.com/questions/60630/how-do-i-find-the-circumcenter-of-a-triangle-in-3d
	# this is the vector from a TO the circumsphere center
	# TODO var toCircumsphereCenter = (normal.cross(ab )*ac.len2() + ac.cross( abXac )*ab.len2()) / (2.f*abXac.len2()) ;
	#float circumsphereRadius = toCircumsphereCenter.len() ;

	#// The 3 space coords of the circumsphere center then:
	#Vector3f ccs = a  +  toCircumsphereCenter ; // now this is the actual 3space location
	
	return {}
	

	
# Function to solve for the point P, such that its distance from points A, B, C is r
func get_point_in_sphere_numerically(a: Vector3, b: Vector3, c: Vector3, r: float) -> Vector3:
	var p = Vector3(0, 0, 0)  # Initial guess for the point P
	var learning_rate = 0.01   # Step size for updating P
	var tolerance = 0.001      # Tolerance for stopping the loop

	# Gradient descent to find the point
	while true:
		var da = p.distance_to(a) - r
		var db = p.distance_to(b) - r
		var dc = p.distance_to(c) - r

		var total_error = abs(da) + abs(db) + abs(dc)
		
		if total_error < tolerance:
			break

		# Compute the gradient with respect to x, y, z of p
		var grad_x = 2 * (p.x - a.x) * da + 2 * (p.x - b.x) * db + 2 * (p.x - c.x) * dc
		var grad_y = 2 * (p.y - a.y) * da + 2 * (p.y - b.y) * db + 2 * (p.y - c.y) * dc
		var grad_z = 2 * (p.z - a.z) * da + 2 * (p.z - b.z) * db + 2 * (p.z - c.z) * dc

		# Update p based on the gradient
		p.x -= learning_rate * grad_x
		p.y -= learning_rate * grad_y
		p.z -= learning_rate * grad_z

	return p
		
		
		
func get_circle_from_three_points(p1: Vector3, p2: Vector3, p3: Vector3) -> Dictionary:
	# Edge vectors
	var a = p2 - p1
	var b = p3 - p1

	# Normal vector to the plane containing the triangle
	var normal = a.cross(b).normalized()

	# Midpoints of two edges
	var mid_a = (p1 + p2) * 0.5
	var mid_b = (p1 + p3) * 0.5

	# Vectors perpendicular to the edges in the plane (direction of bisectors)
	var perp_a = a.cross(normal)
	var perp_b = b.cross(normal)

	# Cross product of the two edge vectors
	#var cross_v1_v2 = v1.cross(v2)
	#var cross_v1_v2_len_squared = cross_v1_v2.length_squared()

	# Compute circumcenter using vector algebra
	#var circumcenter = p1 + ((v2_len_squared * v1 - v1_len_squared * v2).cross(cross_v1_v2)) / (2 * cross_v1_v2_len_squared)

	# Radius is the distance from circumcenter to any point (e.g., p1)
	#var radius = circumcenter.distance_to(p1)


	# Solving the intersection of the bisectors (mid_a + t * perp_a = mid_b + s * perp_b)
	# This gives us a linear system to solve for t and s
	var d = mid_b - mid_a
	var matrix = Vector3(perp_a.dot(perp_b), -perp_b.dot(perp_a), 0)
	var rhs = Vector3(d.dot(perp_a), 0, 0)

	# Solve for t using dot products
	var t = rhs.x / matrix.x

	# The circumcenter is mid_a + t * perp_a
	var circumcenter = mid_a + perp_a * t

	# Radius is the distance from the circumcenter to any point (e.g., p1)
	var radius = circumcenter.distance_to(p1)

	return {
		"center": circumcenter,
		"radius": radius,
		"normal": normal
	}

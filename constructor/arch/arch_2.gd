@tool
extends Node3D


@export var control_shape = Vector2(4,4)
#@export var radius = 5.0
## 0=round, greater -> flatter.
## Radius or Arch = max(control_shape.x,control_shape.y) + exp(roundness) - 1 
@export_range(0, 5,0.05,"or_greater") var roundness = 0.0
@export var vis_dot_amounts = 60

var center_circle
var radius

func _process(delta: float) -> void:
	reconstruct()



func get_pos_on_arch_from_bottom(distance_from_bottom: float) -> Transform3D:
	var start_angle = -asin(center_circle.y / radius)
	var end_angle = PI - acos(center_circle.x / radius)
	var angle = distance_from_bottom / radius
	
	var t  = Transform3D()
	t = t.translated(Vector3.RIGHT * radius)
	t = t.rotated(Vector3.BACK, angle + start_angle)
	t = t.translated(center_circle)
	return t
	
func get_length_of_arch() -> float:
	var start_angle = -asin(center_circle.y / radius)
	var end_angle = PI - acos(center_circle.x / radius)
	var angle = end_angle - start_angle
	return angle * radius

func get_halfwaypoint() -> Transform3D:
	return get_pos_on_arch_from_bottom(get_length_of_arch()/2.0)

func reconstruct():
	var min_radius = (control_shape.x**2 + control_shape.y**2) / (2* control_shape.x)
	#print("min radius = ", min_radius)
	radius = min_radius + exp(roundness) -1 
	#print("radius:  ", radius)
	$Plane.mesh.size = control_shape
	$Plane.transform.origin = Vector3(control_shape.x,control_shape.y,0.0)/2.0
	
	#important points
	var centermid = Vector3.UP * control_shape.y
	var lower_corner = Vector3(control_shape.x,0,0)


	var mm = $"Construction Visualization".multimesh
	mm.instance_count = vis_dot_amounts #5 + 20
	
	
	#mm.set_instance_transform(0, Transform3D().translated(centermid))
	#mm.set_instance_transform(1, Transform3D().translated(lower_corner))
	
	var upper_mid = Vector3(0,control_shape.y,0.0)
	#mm.set_instance_transform(2, Transform3D().translated(upper_mid))
	
	var input_points = [
		Vector2(upper_mid.x,upper_mid.y),
		Vector2(lower_corner.x,lower_corner.y)
	]
	var centerpoint2d = find_center_negy(input_points[0],input_points[1], radius)
	var centerpoint3d = Vector3.UP * centerpoint2d.y + Vector3.RIGHT * centerpoint2d.x
	center_circle = centerpoint3d
	#mm.set_instance_transform(3, Transform3D().translated(centerpoint3d))
	
	#draw arch!
	#var start_angle = -asin(centerpoint3d.y / radius)
	#var end_angle = PI - acos(centerpoint3d.x / radius)
	#var angle_offset = (end_angle-start_angle) / (vis_dot_amounts-1)
	#
	#for i in range(vis_dot_amounts):
		#var t  = Transform3D()
		#t = t.translated(Vector3.RIGHT * radius)
		#t = t.rotated(Vector3.BACK, i * angle_offset + start_angle)
		#t = t.translated(centerpoint3d)
		#mm.set_instance_transform(i, t) #5+i with other points
	
	var archlen = get_length_of_arch()
	for i in range(vis_dot_amounts):
		var t = get_pos_on_arch_from_bottom(archlen * (i/(vis_dot_amounts-1.0)))
		mm.set_instance_transform(i, t)


func find_center_negy(p1: Vector2, p2: Vector2, r: float):
	var possible_solutions = find_circle_centers(p1,p2,r)
	#print("possible_solutions:  ",possible_solutions)
	#print(possible_solutions[1].y)
	if possible_solutions[0].y <= 0.000001:
		return possible_solutions[0]
	if possible_solutions[1].y <= 0.000001:
		return possible_solutions[1]
	print("ERROR: no sufficient solution!")

func find_circle_centers(p1: Vector2, p2: Vector2, r: float) -> Array:
	var x1 = p1.x
	var y1 = p1.y
	var x2 = p2.x
	var y2 = p2.y
	
	# Step 1: Midpoint
	var mx = (x1 + x2) / 2
	var my = (y1 + y2) / 2
	var midpoint = Vector2(mx, my)
	
	# Step 2: Distance between points
	var d = p1.distance_to(p2)
	
	# Step 3: Check if circle is possible
	if d > 2 * r:
		return []
	elif d == 2 * r:
		return [midpoint]
	
	# Step 4: Perpendicular distance h
	var h = sqrt(r * r - (d / 2) * (d / 2))
	
	# Step 5: Perpendicular bisector direction
	var dx = x2 - x1
	var dy = y2 - y1
	var nx = -dy / d
	var ny = dx / d
	
	# Step 6: Calculate the two center points
	var c1 = Vector2(mx + h * nx, my + h * ny)
	var c2 = Vector2(mx - h * nx, my - h * ny)
	
	return [c1, c2]
	
	
	

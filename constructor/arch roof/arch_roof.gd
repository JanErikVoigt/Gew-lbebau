@tool
extends Node3D


@export var control_shape = Vector3(8,4,4)
@export var radius_front1 = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	reconstruct()



var centermid
var lower_corners

func reconstruct():
	$"Control Shape".mesh.size = control_shape
	$"Control Shape".transform.origin = Vector3.UP * control_shape.y / 2
	
	#important points
	centermid = Vector3.UP * control_shape.y
	lower_corners = [
		Vector3(control_shape.x,0,control_shape.z)/2,
		Vector3(control_shape.x,0,-control_shape.z)/2,
		Vector3(-control_shape.x,0,-control_shape.z)/2,
		Vector3(-control_shape.x,0,control_shape.z)/2,
	]

	var mm = $"Construction Visualization".multimesh
	mm.instance_count = 7 + 20
	
	
	mm.set_instance_transform(0, Transform3D().translated(centermid))
	
	for i in range(4):
		#CORRECT: mm.set_instance_transform(1+i, Transform3D().translated(lower_corners[i]))
		# DELETE
		mm.set_instance_transform(1+i, Transform3D().translated(lower_corners[0]))
	
	# draw arches on fronts:
	#for now, fixed on top of box!
	var upper_mid = Vector3(0,control_shape.y,control_shape.z/2)
	mm.set_instance_transform(5, Transform3D().translated(upper_mid))
	
	var input_points = [
		Vector2(upper_mid.x,upper_mid.y),
		Vector2(lower_corners[0].x,lower_corners[1].y)
	]
	var centerpoint2d = find_center_negy(input_points[0],input_points[1], radius_front1)
	var centerpoint3d = Vector3.UP * centerpoint2d.y + Vector3.RIGHT * centerpoint2d.x + Vector3.BACK*lower_corners[0].z
	mm.set_instance_transform(6, Transform3D().translated(centerpoint3d))
	
	#draw arch!
	var start_angle = -asin(centerpoint3d.y / radius_front1)
	var end_angle = PI - acos(centerpoint3d.x / radius_front1)
	print(start_angle,"   ", end_angle)
	var angle_offset = (end_angle-start_angle) / 20.0
	
	for i in range(20):
		var t  = Transform3D()
		t = t.translated(Vector3.RIGHT * radius_front1)
		t = t.rotated(Vector3.BACK, i * angle_offset + start_angle)
		t = t.translated(centerpoint3d)
		mm.set_instance_transform(7+i, t)

	
	
	
	
	
	
	
	# draw diagonals: TRY 2
	#var input_points = [
	#	Vector2(upper_mid.x,upper_mid.y),
	#	Vector2(lower_corners[0].x,lower_corners[1].y)
	#]
	#var centerpoint2d = find_center_negy(input_points[0],input_points[1], radius_front1)
	#var centerpoint3d = Vector3.UP * centerpoint2d.y + lower_corners[0] * centerpoint2d.x

	#mm.set_instance_transform(6, Transform3D().translated(centerpoint3d))
	
	
	
	
	
	
	
	
	# draw diagonals:
	
	var diagonal_lower1 = Vector3(control_shape.x,0,control_shape.z)

func find_center_negy(p1: Vector2, p2: Vector2, r: float):
	var possible_solutions = find_circle_centers(p1,p2,r)
	if possible_solutions[0].y <= 0:
		return possible_solutions[0]
	if possible_solutions[1].y <= 0:
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
	
	
	

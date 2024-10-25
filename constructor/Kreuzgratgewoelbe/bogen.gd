@tool
extends Node3D


@export var shape = Vector2(4,4)
@export var vis_dots: int = 60
@export var circumcenter = Vector2(-4,-4)

func _process(delta: float) -> void:
	circumcenter = circumcenter.clamp(Vector2.ONE * -100, Vector2.ZERO)
	vis_dots = max(2,vis_dots)
	reconstruct()


var ellipse = null
var start_angle = null
var end_angle = null

func reconstruct():

	#important points
	var upper_mid = Vector3.UP * shape.y
	var lower_corner = Vector3(shape.x,0,0)
	var circumcenter3d = Vector3(circumcenter.x,circumcenter.y,0)

	var mm = $DottedLine.multimesh
	mm.instance_count = vis_dots # + 3
	
	#mm.set_instance_transform(0, Transform3D().translated(upper_mid))
	#mm.set_instance_transform(1, Transform3D().translated(lower_corner))
	#mm.set_instance_transform(2, Transform3D().translated(Vector3(circumcenter.x,circumcenter.y,0)))
	
	# 1. calculate radius r.x and r.y (or a and b in ellipse formula x²/a + y²/b = 1
	ellipse = ellipse_from_points(circumcenter, Vector2.DOWN * shape.y, Vector2.RIGHT * shape.x)
	#print("ellipse: ",ellipse)
	
	# 2. start angle
	var v1 =  (lower_corner - circumcenter3d)# / ellipse
	v1 = Vector3(v1.x / ellipse.x, v1.y / ellipse.y,0)
	start_angle = v1.angle_to(Vector3.RIGHT)
	
	# 3. end angle
	var v2 =  upper_mid - circumcenter3d
	v2 = Vector3(v2.x / ellipse.x, v2.y / ellipse.y,0)
	end_angle =  v2.angle_to(Vector3.RIGHT)# atan(v2.y / v2.x)
	
	# 4. subdivide
	var angle_offset = (end_angle-start_angle) / (vis_dots-1)
	#print(start_angle*180/PI,"°      ", end_angle*180/PI, "°      ", angle_offset*180/PI,)
	
	# 5. draw
	for i in range(vis_dots):
		var t  = Transform3D()
		var angle = i * angle_offset + start_angle
		
		t = t.translated(Vector3(cos(angle)*ellipse.x,sin(angle)*ellipse.y,0))
		t = t.translated(Vector3(circumcenter.x,circumcenter.y,0))
		
		mm.set_instance_transform(i, t) 
	



func is_circle():
	if ellipse == null:
		reconstruct()
	
	return abs(ellipse.x - ellipse.y) < 0.00001

func arc_len():
	if ellipse == null:
		reconstruct()
	
	if is_circle():
		return arc_len_circle()
	else:
		return arc_len_ellipse()

func arc_len_circle():
	# assume ellipse.x ~= ellipse.y
	return (end_angle - start_angle) * (ellipse.x + ellipse.y)/2

func arc_len_ellipse():
	# using Zafary from https://paulbourke.net/geometry/ellipsecirc/
	var a = ellipse.x
	var b = ellipse.y
	var h = ((a-b)**2) / ((a+b)**2)
	var perimeter = PI * (a+b) * (4/ PI)**h
	
	return perimeter
	# other source:
	# maybe look here, too: https://math.stackexchange.com/questions/433094/how-to-determine-the-arc-length-of-ellipse
	#var d= b * E(tan−1(a/btan(θ))∣∣1−(a/b)2)

func pos_on_arc(distance_from_bottom: float) -> Transform3D:
	if is_circle():
		# easy
		var radius = (ellipse.x + ellipse.y) / 2
		var angle = distance_from_bottom / radius
		
		var t  = Transform3D()
		t = t.translated(Vector3.RIGHT * radius)
		t = t.rotated(Vector3.BACK, angle + start_angle)
		t = t.translated(Vector3(circumcenter.x,circumcenter.y,0))
		return t
	else:
		# not easy
		return Transform3D() #TODO

	
func ellipse_from_points(center: Vector2, p1: Vector2, p2: Vector2):
	# 1. translate center to (0,0)
	p1 -= center
	p2 -= center
	
	# TODO assume here points are lin independent... works in my usecase, i think
	
	if p2.y == 0:
		var old_p2 = p2
		p2 = p1
		p1 = old_p2
	
	# 2. take ellipse equation and insert p1 and p2. solve for m = 1/a² and n = 1/b²
	var y1_sq = p1.y **2
	var y2_sq = p2.y **2
	var x1_sq = p1.x **2
	var x2_sq = p2.x **2
	
	var m = (1-(y1_sq/y2_sq)) / (x1_sq - x2_sq * y1_sq / y2_sq)
	var n = (1- x2_sq * m) / y2_sq
	
	# 3. m -> a amd n -> b
	var a = sqrt(1/m)
	var b = sqrt(1/n)
	
	
	return Vector2(a,b)

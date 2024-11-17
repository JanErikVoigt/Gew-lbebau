extends Camera3D

var camera_drag = false
var last_mousepos

var cam_angles = Vector2(5.0,1.0)
var cam_distance = 20.0

func _process(delta: float) -> void:
	var recalc = false
	
	if Input.is_action_just_pressed("drag_camera"):
		camera_drag = true
		last_mousepos = get_viewport().get_mouse_position()
	if Input.is_action_just_released("drag_camera"):
		camera_drag = false
		recalc = true
		
	if Input.is_action_just_pressed("move_camera_away"):
		cam_distance *= 1.1
		
		recalc = true
	if Input.is_action_just_pressed("move_camera_closer"):
		cam_distance *= 1.0 / 1.1
		recalc = true
	cam_distance = clamp(cam_distance,0.1,100.0)
		
	if camera_drag:
		var next_mousepos = get_viewport().get_mouse_position()
		
		# TODO take distance into account!
		cam_angles.x -= (next_mousepos.x - last_mousepos.x) * 0.1 * delta
		cam_angles.y -= (next_mousepos.y - last_mousepos.y) * 0.1 * delta
		cam_angles.y = clamp(cam_angles.y,-PI/2.0, 0.2)
		
		last_mousepos = next_mousepos
		recalc = true
		
	if recalc:
		get_parent().transform = Transform3D.IDENTITY.rotated(Vector3.RIGHT,cam_angles.y).rotated(Vector3.UP,cam_angles.x).translated(get_parent().transform.origin)
		transform.origin.z = cam_distance

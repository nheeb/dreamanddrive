extends Spatial

export var awake := false

func visual_steer(rotation_in_rad:float):
	$"%WheelPivotFR".rotation_degrees.y = rad2deg(rotation_in_rad)
	$"%WheelPivotFL".rotation_degrees.y = rad2deg(rotation_in_rad)

func _physics_process(delta):
	if (not Game.dead) and awake:
		var window_dir = Input.get_action_strength("fly_up") - Input.get_action_strength("fly_down")
		var new_pos_y = $CarWindow.translation.y + window_dir * delta * .4
		new_pos_y = clamp(new_pos_y, -.7, 0.0)
		$CarWindow.translation.y = new_pos_y

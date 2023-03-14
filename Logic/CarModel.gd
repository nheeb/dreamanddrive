extends Spatial

func visual_steer(rotation_in_rad:float):
	$"%WheelPivotFR".rotation_degrees.y = rad2deg(rotation_in_rad)
	$"%WheelPivotFL".rotation_degrees.y = rad2deg(rotation_in_rad)

extends Spatial

func connect_waypoints(last_waypoint):
	var use_other_side := sign(scale.z) > 0
	var use_wrong_order := sign(scale.x) > 0
	
	var waypoints := $Waypoints.get_children()
	for index in range

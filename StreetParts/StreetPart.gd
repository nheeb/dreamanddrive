extends Spatial

var use_other_side := true
var use_wrong_order := false

func connect_waypoints(connecting_waypoint):
	var waypoints := $Waypoints.get_children()
	var previous_waypoint = connecting_waypoint
	for index in range(len(waypoints)):
		var i = len(waypoints) - 1 - index if use_wrong_order else index
		var waypoint = waypoints[i]
		if waypoint.other_side == use_other_side:
			waypoint.next = previous_waypoint
			previous_waypoint = waypoint
	return previous_waypoint

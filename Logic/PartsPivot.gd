extends Spatial

var parts := []
var durations := []
var directions := []
var offsets := []
var origins := []
var max_duration := 3.0
var flying_speed := .1

func add_part(part:Spatial,local_offset: Vector3, direction: Vector3):
	yield(get_tree().create_timer(.3),"timeout")
	parts.append(part)
	durations.append(0.0)
	offsets.append(local_offset)
	directions.append(direction)
	origins.append(part.global_translation)

var time := 0.0
func _physics_process(delta):
	time += delta
	for i in range(len(parts)):
		durations[i] += delta
		var part: Spatial = parts[i]
		var end_pos := to_global(offsets[i] * (1.0+.3*sin(time)) + Vector3.FORWARD * .5 * cos(time))
		var middle_pos : Vector3 = origins[i] + durations[i] * flying_speed * directions[i]
		var eased_value = ease(min(durations[i]/max_duration, 1.0), .8)
		part.global_translation = lerp(middle_pos , end_pos, eased_value)

		part.global_rotate(Vector3.FORWARD, delta * deg2rad(80.0 + (1.0 - eased_value) * 500.0))

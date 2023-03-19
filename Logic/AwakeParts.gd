extends Spatial

var parts := []
var durations := []
var directions := []
var origins := []
var max_duration := 10.0
var flying_speed := 8.0
var gravity := 5.5

func add_part(part:Spatial, direction: Vector3):
	yield(get_tree().create_timer(.1),"timeout")
	parts.append(part)
	durations.append(0.0)
	directions.append(direction.normalized())
	origins.append(part.global_translation)

func _physics_process(delta):
	for i in range(len(parts)):
		if durations[i] >= max_duration:
			#parts[i].queue_free()
			continue
			
		durations[i] += delta
		var part: Spatial = parts[i]
		var fly_distance : Vector3 = durations[i] * directions[i] * flying_speed
		var gravity_distance : Vector3 = durations[i] * durations[i] * Vector3.DOWN * gravity
		part.global_translation = origins[i] + fly_distance + gravity_distance

		part.global_rotate(directions[i].cross(Vector3.UP).normalized(), delta * deg2rad(600.0 + ((max_duration - durations[i]) / max_duration) * 100.0))

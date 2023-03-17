extends Spatial

var speed := 10.0
var next_waypoint: Spatial

func setup(waypoint):
	global_translation = waypoint.global_translation
	next_waypoint = waypoint.next

func _physics_process(delta):
	if Game.car.global_translation.distance_to(self.global_translation) > 300.0:
		queue_free()
	if next_waypoint != null:
		var last_pos = global_translation
		global_translation += global_translation.direction_to(next_waypoint.global_translation) * speed * delta
		look_at(global_translation+global_translation-last_pos, Vector3.UP)
		if global_translation.distance_squared_to(next_waypoint.global_translation) < 1.0:
			next_waypoint = next_waypoint.next
	else:
		queue_free()

func _on_collide():
	halt()

var halt_tween : SceneTreeTween
func halt():
	speed = 0.0
	if is_instance_valid(halt_tween): halt_tween.kill()
	yield(get_tree().create_timer(2),"timeout")
	halt_tween = get_tree().create_tween()
	halt_tween.tween_property(self, "speed", 10.0, 4.0).from(0.0)

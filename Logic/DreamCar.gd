extends Spatial

var intro_mode := true
var intro_controls := 0.0

var horizontal_speed := 5.0
var vertical_speed := 0.0

var max_vertical_speed := 4.0
var max_rotation_degrees := 35.0
var borders := 3.8
var soft_border_width := .5

var input_direction := 0.0

var current_turn := 0.0
var turn_speed := 2.0
var turn_velocity := 0.0
var turn_acc := 3.0

func _ready():
	$CarModel/AnimationPlayer.stop()
	$CarModel/AnimationPlayer.queue_free()
	

func _physics_process(delta):
	get_input()
	change_direction(delta)
	fly(delta)

func get_input():
	input_direction = Input.get_action_strength("fly_up")-Input.get_action_strength("fly_down")
	if input_direction > 0.0 and global_translation.y > borders:
		input_direction = 0.0
	if input_direction < 0.0 and global_translation.y < -borders:
		input_direction = 0.0
	if intro_mode:
		input_direction = intro_controls

func change_direction(delta):
	#var turn_direction := sign(input_direction - current_turn)
	#var turn_movement := min(abs(input_direction - current_turn), turn_speed * delta)
	#current_turn += turn_direction * turn_movement
	var old_turn_value := current_turn
	
	var turn_dist := abs(input_direction - current_turn)
	var turn_direction := sign(input_direction - current_turn)
	turn_velocity *= pow(.5,delta * 2)
	turn_velocity += delta * turn_direction * turn_acc * (1.0 + turn_dist * abs(input_direction))
	turn_velocity = clamp(turn_velocity, -turn_speed, turn_speed)

	if abs(input_direction)<.1 and abs(current_turn) < .3:
		turn_velocity *= pow(.5,delta * 2)
	if abs(current_turn) < .1 and abs(turn_velocity) < .1 and abs(input_direction)<.1:
		turn_velocity *= pow(.2,delta * 10)
	if abs(current_turn) < .01 and abs(turn_velocity) < .01 and abs(input_direction)<.1:
		turn_velocity = 0.0
		current_turn = 0.0
		old_turn_value = 0.0
	
	current_turn += turn_velocity * delta
	
	current_turn = clamp(current_turn, -1, 1)
	
	turn_velocity = (current_turn - old_turn_value) / delta
	
	var eased_value := ease(current_turn / 2.0 + .5, -2.0) * 2.0 - 1.0
	$CarModel.rotation_degrees.z = -eased_value * max_rotation_degrees
	vertical_speed = eased_value * max_vertical_speed

func fly(delta):
	var border_extend := clamp(abs(global_translation.y) - borders, 0, soft_border_width) / soft_border_width
	var border_factor := 1.0
	if border_extend > .01 and sign(vertical_speed) == sign(global_translation.y):
		border_factor = 1.0 - pow(border_extend, 2.0)
	var velocity : Vector3 = Vector3.FORWARD * horizontal_speed + Vector3.UP * vertical_speed * border_factor
	global_translation += velocity * delta
	
	#print(global_translation.y)

func intro_movement():
	intro_controls = -1.0
	yield(get_tree().create_timer(1.0),"timeout")
	intro_controls = 1.0
	yield(get_tree().create_timer(1.5),"timeout")
	intro_controls = 0.0
	yield(get_tree().create_timer(.5),"timeout")
	intro_mode = false

func _on_Area_area_entered(area):
	handle_collision()

var collision_cooldown := 2.8
var has_collided := false
const EXPLOSION = preload("res://Effects/Explosion.tscn")
func handle_collision():
	if has_collided or Game.finish or Game.dead:
		return
	has_collided = true
	
	Sound.play_boom()
	
	var explosion := EXPLOSION.instance()
	Game.dream_world.add_child(explosion)
	explosion.global_translation = global_translation
	
	Game.cam_shake(1.4)
	Game.take_dream_damage()
	
	if Game.dream_health_points == 2:
		$PartsPivot.add_part($CarModel/WheelPivotFL/WheelFL, Vector3.LEFT, Vector3(-2, -20, -horizontal_speed*10))
		$PartsPivot.add_part($CarModel/WheelBR, Vector3.RIGHT, Vector3(2, -20, -horizontal_speed*10))
	elif Game.dream_health_points == 1:
		$PartsPivot.add_part($CarModel/WheelPivotFR/WheelFR, Vector3.UP, Vector3(2, -20, -horizontal_speed*10))
		$PartsPivot.add_part($CarModel/WheelBL, Vector3.DOWN, Vector3(-2, -20, -horizontal_speed*10))
	
	yield(get_tree().create_timer(collision_cooldown),"timeout")
	has_collided = false

extends KinematicBody


var max_steering_angle = 20
var steer_speed := 2.0

var acceleration := Vector3.ZERO
var velocity := Vector3.ZERO
var steer_angle := 0.0

var engine := 350.0
var engine_after_speed_up := 600.0
var engine_multiplicator := 1.0
var friction := -0.9
var drag := -0.0015

var collision_cooldown := 5.0

var on_dirt := false

func _physics_process(delta):
	test_for_dirt()
	update_engine_multiplicator()
	acceleration = Vector3.ZERO
	get_input(delta)
	acceleration = -global_transform.basis.z.normalized() * engine * engine_multiplicator * delta
	apply_friction()
	velocity += acceleration
	calculate_steering(delta)
	velocity = move_and_slide(velocity)
	var collision := get_last_slide_collision()
	if collision != null:
		handle_collision(collision)

var has_collided := false
const EXPLOSION = preload("res://Effects/Explosion.tscn")
func handle_collision(collision: KinematicCollision):
	if has_collided:
		return
	has_collided = true
	halt()
	Sound.play_boom()
	if collision.collider.get_parent().has_method("_on_collide"):
		collision.collider.get_parent()._on_collide()
	
	var normal := collision.normal
	var pos := collision.position
	
	velocity = pos.direction_to(global_translation) * 14.0
	
	var explosion := EXPLOSION.instance()
	Game.world.add_child(explosion)
	explosion.global_translation = pos
	
	Game.cam_shake()
	Game.take_awake_damage()
	
	yield(get_tree().create_timer(collision_cooldown),"timeout")
	has_collided = false

func get_input(delta):
	var turn : float = Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
	if Game.intro:
		turn = 0.0
	var steer_angle_target: float = turn * deg2rad(max_steering_angle)
	var steer_direction := sign(steer_angle_target - steer_angle)
	
	var steer_movement : float = min(abs(steer_angle - steer_angle_target), abs(steer_speed * delta))
	var new_angle = steer_angle + (steer_direction * steer_movement)
	steer_angle = new_angle
	
	# Visual steering
	$"%CarModel".visual_steer(steer_angle)
	#Game.dream_car.get_node("CarModel").visual_steer(steer_angle)

func apply_friction():
	if velocity.length() < .01:
		velocity = Vector3.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if engine_stop > 0.01:
		acceleration += (drag_force + friction_force)
	else:
		acceleration += friction_force * .1
	

func calculate_steering(delta):
	if engine_stop < .1:
		return
	
	var steer_factor : float = lerp(1.0, .4, engine_stop) if on_dirt else 1.0
	
	var back_wheel : Vector3 = $"%BackWheelBase".global_translation
	var front_wheel : Vector3 = $"%FrontWheelBase".global_translation
	back_wheel += velocity * delta
	front_wheel += velocity.rotated(Vector3.UP, steer_angle * steer_factor) * delta
	var new_heading = (front_wheel - back_wheel).normalized()
	velocity = new_heading * velocity.length()
	var angle := Vector2(new_heading.x, new_heading.z).angle_to(Vector2.UP)
	global_rotation.y = angle

func intro_speed_up():
	var tween := get_tree().create_tween()
	tween.tween_property(self, "engine", engine_after_speed_up, 1.5)

func turn_on_lights():
	$Model/SpotLight.visible = true
	$Model/SpotLight2.visible = true
	yield(get_tree().create_timer(.05),"timeout")
	$Model/SpotLight.visible = false
	$Model/SpotLight2.visible = false
	yield(get_tree().create_timer(.3),"timeout")
	$Model/SpotLight.visible = true
	$Model/SpotLight2.visible = true

var engine_stop := 1.0
var engine_boost := 1.0
var engine_dirt := 1.0
func update_engine_multiplicator():
	engine_multiplicator = 1.0
	engine_multiplicator *= engine_stop
	engine_multiplicator *= engine_boost
	engine_multiplicator *= engine_dirt
	if Game.dead:
		engine_multiplicator = 0.0

var currently_speed_boosting := false
func speed_boost():
	if currently_speed_boosting: return
	currently_speed_boosting = true
	var tween := get_tree().create_tween()
	tween.tween_property(self, "engine_boost", 1.4, .5).from(1.0)
	tween.tween_property(self, "engine_boost", 1.0, 4.0).from_current()
	yield(tween,"finished")
	currently_speed_boosting = false

var halt_tween: SceneTreeTween
func halt():
	engine_stop = 0.0
	if is_instance_valid(halt_tween):
		halt_tween.kill()
	yield(get_tree().create_timer(1.3),"timeout")
	halt_tween = get_tree().create_tween()#.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	halt_tween.tween_property(self, "engine_stop", 1.0, 5.0).from(0.0)

func test_for_dirt():
	on_dirt = len($Area.get_overlapping_areas()) == 0
	engine_dirt = .9 if on_dirt else 1.0
	$DirtParticles.emitting = on_dirt

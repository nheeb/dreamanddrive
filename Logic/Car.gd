extends KinematicBody


var steering_angle = 15
var steer_speed := 1.0

var acceleration := Vector3.ZERO
var velocity := Vector3.ZERO
var steer_angle := 0

var engine := 800
var friction := -0.9
var drag := -0.0015

func _physics_process(delta):
	acceleration = Vector3.ZERO
	get_input(delta)
	acceleration = -global_transform.basis.z.normalized() * engine * delta
	apply_friction()
	velocity += acceleration
	calculate_steering()
	velocity = move_and_slide(velocity)

func get_input(delta):
	var turn : float = Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
	var steer_angle_target: float = turn * deg2rad(steering_angle)
	var steer_movement : float = min(abs(steer_angle - steer_angle_target), abs(steer_speed * delta))
	steer_angle += sign(turn) * steer_movement
	
func apply_friction():
	pass

func calculate_steering():
	pass
#
#func _physics_process(delta):
#	acceleration = Vector3.ZERO
#	get_input(delta)
#
#	apply_friction(delta)
#	velocity += acceleration
#	calculate_steering(delta)
#
#	print(velocity)
#	print(velocity * delta)
#	velocity = move_and_slide(velocity * delta)
#
#func get_input(delta):
#	var turn : float = Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
#	steer_angle = turn * deg2rad(steering_angle)
#	acceleration = -global_transform.basis.z.normalized() * engine * delta
#
#func calculate_steering(delta):
#	var back_wheel : Vector3 = $"%BackWheelBase".global_translation
#	var front_wheel : Vector3 = $"%FrontWheelBase".global_translation
#	back_wheel += velocity * delta
#	front_wheel += velocity.rotated(Vector3.UP, steer_angle) * delta
#	var new_heading = (front_wheel - back_wheel).normalized()
#	velocity = new_heading * velocity.length()
#	var angle := Vector2(new_heading.x, new_heading.z).angle_to(Vector2.UP)
#	global_rotation.y = angle
#
#func apply_friction(delta):
#	if velocity.length() < .01:
#		velocity = Vector3.ZERO
#	var friction_force = velocity * friction
#	var drag_force = velocity * velocity.length() * drag
#	if velocity.length() < .3:
#		friction_force *= 3
#
#	acceleration += delta * (drag_force + friction_force)

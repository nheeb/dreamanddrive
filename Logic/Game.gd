extends Node

var car: KinematicBody
var map
var world
var dream_world
var dream_car
var main

var viewport_shader: ShaderMaterial

var dead := false
var intro := true


var health_points := 3
var damage := 0.0
var max_damage := 100.0

func _ready():
	randomize()

func start_intro():
	world.reduce_sky_energy()
	yield(get_tree().create_timer(2.0),"timeout")
	car.turn_on_lights()
	world.show_intro_texts()
	yield(get_tree().create_timer(2.5),"timeout")
	Sound.fade_out_engine()
	Sound.play_acc()
	yield(get_tree().create_timer(.2),"timeout")
	car.intro_speed_up()
	yield(get_tree().create_timer(9),"timeout")
	dream_world.cam_in()
	world.cam_out()
	dream_car.intro_movement()
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(viewport_shader, "shader_param/dream_start", 1.0, 5.0).from(0.0)

var time_survived := 0.0
var time_goal := 120.0
func _physics_process(delta):
	if not intro:
		time_survived += delta
		viewport_shader.set("shader_param/dream_progress", time_survived / time_goal)
		if time_survived > time_goal:
			trigger_end()

func trigger_end():
	pass

#func _process(delta):
#	print(Engine.get_frames_per_second())


const OBSTACLE_MOVER = preload("res://DreamObstacles/ObstacleMover.tscn")
func spawn_dream_obstacle():
	var pos = dream_world.global_translation
	pos.z = dream_car.global_translation.z - 30.0
	var o = OBSTACLE_MOVER.instance()
	dream_world.add_child(o)
	o.global_translation = pos
	if randi() % 2 == 0:
		o.global_rotate(Vector3.FORWARD, deg2rad(180.0))

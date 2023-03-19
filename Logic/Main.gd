extends Control

var click_to_restart := false
var click_to_start := false

func _ready():
	Game.main = self
	Game.viewport_shader = $ViewportContainer.material
	yield(get_tree().create_timer(.01),"timeout")
	refresh_size()
	yield(get_tree().create_timer(2.5),"timeout")
	fade_from_black_screen()
	yield(get_tree().create_timer(1),"timeout")
	click_to_start = true

func fade_from_black_screen():
	get_tree().create_tween().tween_property(Game.viewport_shader, "shader_param/black_screen", 0.0, 2).from(1.0)

func fade_to_black_screen():
	yield(get_tree().create_timer(1),"timeout")
	get_tree().create_tween().tween_property(Game.viewport_shader, "shader_param/black_screen", 1.0, 3).from(0.0)

func fade_fail_text():
	for label in [$UI/FailContainer/VBoxContainer/FailText, $UI/FailContainer/VBoxContainer/ClickToRestart]:
		get_tree().create_tween().tween_property(label, "modulate:a", 1.0, 2).from(0.0)
	yield(get_tree().create_timer(.1),"timeout")
	$UI/FailContainer.visible = true

func fade_finish_text():
	for label in [$UI/FinishContainer/VBoxContainer/FinishText]:
		get_tree().create_tween().tween_property(label, "modulate:a", 1.0, 2).from(0.0)
	yield(get_tree().create_timer(.1),"timeout")
	$UI/FinishContainer.visible = true

func _on_ViewportContainer_resized():
	refresh_size()

func refresh_size():
	$ViewportContainer.rect_size = get_viewport().size
	$ViewportContainer/ViewportAwake.size = $ViewportContainer.rect_size
	$ViewportDream.size = $ViewportContainer.rect_size

	$ViewportContainer.update()

#const ENEMY_CAR = preload("res://Logic/EnemyCar.tscn")
const EXPLOSION = preload("res://Effects/Explosion.tscn")
func _physics_process(_delta):
	$UI/Label.text = "FPS: " + str(Engine.get_frames_per_second())
	if Game.intro:
		if Input.is_action_just_pressed("click") and click_to_start:
			Game.intro = false
			Sound.start_music()
			Game.start_intro()
			$UI/CenterContainer.visible = false
	if click_to_restart:
		if Input.is_action_just_pressed("click"):
			Game.reset_game()
	if Input.is_action_just_pressed("cheat_spawn_car"):
		Game.spawn_truck()
#		var enemy_car = ENEMY_CAR.instance()
#		Game.world.add_child(enemy_car)
#		enemy_car.setup(Game.map.last_waypoint)
	if Input.is_action_just_pressed("cheat_spawn_obstacle"):
		Game.spawn_dream_obstacle()
	if Input.is_action_just_pressed("cheat_win"):
		Game.trigger_end()
	if Input.is_action_just_pressed("cheat_explosion"):
		var e = EXPLOSION.instance()
		Game.world.add_child(e)
		e.global_translation = Game.car.global_translation
		e = EXPLOSION.instance()
		Game.dream_world.add_child(e)
		e.global_translation = Game.dream_car.global_translation


func _on_Timer_timeout():
	refresh_size()

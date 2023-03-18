extends Control

var click_to_restart := false

func _ready():
	Game.main = self
	Game.viewport_shader = $ViewportContainer.material
	yield(get_tree().create_timer(.01),"timeout")
	refresh_size()

func _on_ViewportContainer_resized():
	refresh_size()

func refresh_size():
	$ViewportContainer.rect_size = get_viewport().size
	$ViewportContainer/ViewportAwake.size = $ViewportContainer.rect_size
	$ViewportDream.size = $ViewportContainer.rect_size

	$ViewportContainer.update()

#const ENEMY_CAR = preload("res://Logic/EnemyCar.tscn")
func _physics_process(_delta):
	$UI/Label.text = "FPS: " + str(Engine.get_frames_per_second())
	if Game.intro:
		if Input.is_action_just_pressed("click"):
			Game.intro = false
			Sound.start_music()
			Game.start_intro()
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


func _on_Timer_timeout():
	refresh_size()

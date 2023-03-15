extends Control

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
	
const ENEMY_CAR = preload("res://Logic/EnemyCar.tscn")
func _physics_process(delta):
	if Game.intro:
		if Input.is_action_just_pressed("click"):
			Game.intro = false
			Sound.start_music()
			Game.start_intro()
	if Input.is_action_just_pressed("cheat_spawn_car"):
		var enemy_car = ENEMY_CAR.instance()
		Game.world.add_child(enemy_car)
		enemy_car.setup(Game.map.last_waypoint)

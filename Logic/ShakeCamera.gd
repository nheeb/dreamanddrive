extends Camera

export var noise : OpenSimplexNoise
export var seed_offset := 0
var time := 0.0
var trauma := 0.0
var trauma_reduction := .75
var time_scale := 100.0

var base_deg_x: float
var base_deg_y: float
var base_deg_z: float
func _ready():
	base_deg_x = rotation_degrees.x
	base_deg_y = rotation_degrees.y
	base_deg_z = rotation_degrees.z


func screen_shake():
	trauma = .8

func _process(delta):
	if Input.is_action_just_pressed("cheat_screen_shake"):
		screen_shake()
	
	if trauma > 0.0:
		trauma = max(trauma - delta * trauma_reduction, 0.0)
		time += delta
		
		rotation_degrees.x = base_deg_x + 12.0 * get_shake_intensity() * get_noise_from_seed(1)
		rotation_degrees.y = base_deg_y + 12.0 * get_shake_intensity() * get_noise_from_seed(2)
		rotation_degrees.z = base_deg_z + 8.0 * get_shake_intensity() * get_noise_from_seed(3)


func get_shake_intensity() -> float:
	return min(trauma, 1.0) * min(trauma, 1.0)

func get_noise_from_seed(_seed: int) -> float:
	noise.seed = _seed + seed_offset
	return noise.get_noise_1d(time * time_scale)

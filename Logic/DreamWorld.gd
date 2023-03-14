extends Spatial

var cam_offset := Vector3.ZERO
var car_start := Vector3.ZERO

func _ready():
	Game.dream_world = self
	Game.dream_car = $DreamCar
	cam_offset = $CamPivot.global_translation - $DreamCar.global_translation
	car_start = $DreamCar.global_translation
	
func _process(_delta):
	$CamPivot.global_translation = car_start + Vector3.BACK * $DreamCar.global_translation.z + cam_offset

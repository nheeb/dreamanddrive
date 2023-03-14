extends Spatial

var cam_offset := Vector3.ZERO

func _ready():
	Game.dream_world = self
	Game.dream_car = $DreamCar
	cam_offset = $CamPivot.global_translation - $DreamCar.global_translation
	
func _process(delta):
	$CamPivot.global_translation = Vector3.BACK * $DreamCar.global_translation.z + cam_offset

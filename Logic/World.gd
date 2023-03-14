extends Spatial

var cam_offset: Vector3

func _ready():
	Game.world = self
	Game.car = $Car
	Game.map = $Map
	cam_offset = $CamPivot.global_translation - $Car.global_translation
	
func _process(delta):
	$CamPivot.global_translation = $Car.global_translation + cam_offset

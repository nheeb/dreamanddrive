extends Spatial

var cam_offset: Vector3

func _ready():
	Game.world = self
	Game.car = $Car
	Game.map = $Map
	Game.world_cam = $CamPivot/Camera
	cam_offset = $CamPivot.global_translation - $Car.global_translation
	$IntroTexts.visible = true
	yield(get_tree().create_timer(.1),"timeout")
	$IntroTexts.visible = false
	for i in range(10):
		yield(get_tree().create_timer(.1),"timeout")
		$IntroTexts.visible = false
	

var cam_follow := true
var rest_follow := 1.0
func _process(delta):
	if cam_follow:
		$CamPivot.global_translation = $Car.global_translation + cam_offset
	else:
		$CamPivot.global_translation += $Car.velocity * delta * rest_follow
		rest_follow -= delta * .3
		rest_follow = clamp(rest_follow, 0.0, 1.0)

func cam_out():
	$CamAnimation.play("intro")

func show_intro_texts():
	$IntroTexts.translation.x = Game.car.translation.x
	$IntroTexts.visible = true
	yield(get_tree().create_timer(15.5),"timeout")
	$IntroTexts.queue_free()

func reduce_sky_energy():
	$SunPlayer.play("sun")
	yield(get_tree().create_timer(2.5),"timeout")
	$DirectionalLight.visible = false
#	var tween := get_tree().create_tween()
#	#tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
#	tween.tween_property($WorldEnvironment.environment.background_sky, "sky_energy", .4, 2.0).from(1.0)

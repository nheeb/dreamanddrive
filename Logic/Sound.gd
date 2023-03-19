extends Node

func start_music():
	$MusicPlayer.play(0.0)

func fade_out_engine():
	var tween := get_tree().create_tween()
	tween.tween_property($CarEngine, "volume_db", -200.0, 2.0)
	yield(get_tree().create_timer(3.0),"timeout")
	$CarEngine.stop()

func play_acc(repeat := false):
	$CarAccel.play()
	if not repeat:
		return
	yield($CarAccel,"finished")
	$CarAccel.play()

func play_boom():
	$ExplosionPlayer.play(0.0)

func _ready():
	$MusicPlayer.stop()
	$GravelPlayer.stop()
	$CarEngine.play(0.0)

var first_trucks := 2
func play_truck():
	if randi()%3 == 0 and not Game.intro and first_trucks <= 0:
		yield(get_tree().create_timer(.4),"timeout")
		$TruckHornPlayer.play(0.0)
	else:
		$TruckPlayer.play(0.0)
		first_trucks -= 1

func set_gravel(on: bool):
	if Game.dead or Game.finish:
		$GravelPlayer.stop()
		return
	if $GravelPlayer.playing != on:
		if on:
			$GravelPlayer.play()
		else:
			$GravelPlayer.stop()

func play_engine_off():
	$EngineOffPlayer.play(0.0)

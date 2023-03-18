extends Node

func start_music():
	$MusicPlayer.play()

func fade_out_engine():
	var tween := get_tree().create_tween()
	tween.tween_property($CarEngine, "volume_db", -200.0, 2.0)
	yield(get_tree().create_timer(3.0),"timeout")
	$CarEngine.stop()

func play_acc():
	$CarAccel.play()
	yield($CarAccel,"finished")
	$CarAccel.play()

func play_boom():
	$ExplosionPlayer.play()

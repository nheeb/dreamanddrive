extends Spatial

func _ready():
	if Game.intro:
		$SpotLight.visible = true
		yield(get_tree().create_timer(.5),"timeout")
		$SpotLight.visible = false

func turn_on():
	yield(get_tree().create_timer(randf()*1.5),"timeout")
	$SpotLight.visible = true
	yield(get_tree().create_timer(.05),"timeout")
	$SpotLight.visible = false
	yield(get_tree().create_timer(.5),"timeout")
	$SpotLight.visible = true
	if randi() % 2 == 0:
		yield(get_tree().create_timer(.05),"timeout")
		$SpotLight.visible = false
		yield(get_tree().create_timer(.25),"timeout")
		$SpotLight.visible = true

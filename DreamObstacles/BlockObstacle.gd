extends Spatial

func _physics_process(delta):
	$Pivot.global_rotate(Vector3.ONE.normalized(), deg2rad(60)*delta)

func _ready():
	yield(get_tree().create_timer(15),"timeout")
	queue_free()

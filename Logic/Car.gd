extends KinematicBody

const MAX_SPEED = 3.0
const ACCELERATION = 1.0
const TURN_SPEED = 100.0

var speed := 0.0
var direction := Vector3.FORWARD

func _ready():
	pass

func _physics_process(delta):
	if speed < MAX_SPEED:
		speed += ACCELERATION * delta
		
	direction = direction.rotated(Vector3.UP, deg2rad(TURN_SPEED * (speed/MAX_SPEED) * delta * (Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right"))))
	$Model.look_at(to_global(direction), Vector3.UP)
	
	move_and_slide(direction.normalized() * speed, Vector3.UP)

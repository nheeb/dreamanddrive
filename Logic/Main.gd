extends Control

func _ready():
	yield(get_tree().create_timer(.01),"timeout")
	refresh_size()

func _on_ViewportContainer_resized():
	refresh_size()

func refresh_size():
	$ViewportContainer.rect_size = get_viewport().size
	$ViewportContainer/ViewportAwake.size = $ViewportContainer.rect_size
	$ViewportDream.size = $ViewportContainer.rect_size

	$ViewportContainer.update()
	

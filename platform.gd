extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Visibility_screen_exited():
	print_debug(name, " got out of screen! Despawning..")
	queue_free()

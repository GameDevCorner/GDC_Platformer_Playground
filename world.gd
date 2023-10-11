extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var player_vars = get_node("/root/Variables")
	player_vars.apples_left = get_node("Collectables").get_child_count()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_apple_body_entered(body):
	pass # Replace with function body.

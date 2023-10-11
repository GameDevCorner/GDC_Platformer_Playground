extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.apples = get_child_count()

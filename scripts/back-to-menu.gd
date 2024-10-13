extends Node

var tutorial_root
var menu_root

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tutorial_root = get_parent()
	menu_root = tutorial_root.get_parent().get_node("Mainmenu")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	tutorial_root.visible = false
	menu_root.visible = true

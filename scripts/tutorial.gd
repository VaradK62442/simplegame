extends Node

var tutorial_root
var menu_root

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_root = get_parent()
	tutorial_root = menu_root.get_parent().get_node("Tutorial")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	tutorial_root.visible = true
	menu_root.visible = false

extends "res://scripts/enemies/enemy_basic.gd"

var target

func _ready() -> void:
	super._ready()
	target = get_parent().get_node("Player")



func _process(delta: float) -> void:
	if target:
		var direction = (target.position - position).normalized()
		position += direction * 50 * delta

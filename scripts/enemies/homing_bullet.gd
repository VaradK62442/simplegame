extends "res://scripts/enemies/enemy_basic.gd"

var target
var spawntime
var direction
func _ready() -> void:
	super._ready()
	spawntime = 0
	target = get_parent().get_node("Player")



func _process(delta: float) -> void:
	spawntime += delta
	if target and spawntime < 10:
		direction = (target.position - position).normalized()
		rotation = direction.angle()
	position += direction * 50 * delta

extends EnemyBasic

var target

func _init() -> void:
	spawn_chance = 2

func _ready() -> void:
	super._ready()
	target = get_parent().get_node("Player")



func _process(delta: float) -> void:
	if target:
		var direction = (target.position - position).normalized()
		position += direction * 50 * delta

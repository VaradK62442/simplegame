extends Area2D
class_name EnemyBasic

var spawn_chance: int = Config.enemy_basic.spawn_chance
var speed: int = Config.enemy_basic.speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2(0, 1).rotated(rotation) * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# tell only player
	if body.name == "Player":
		body.take_damage(self)
		queue_free()

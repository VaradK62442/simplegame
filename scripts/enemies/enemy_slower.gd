extends EnemyBasic

var target
var spawntime
var direction = Vector2.ZERO


func _init() -> void:
	spawn_chance = 2
	speed = 200

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_body_entered(body: Node2D) -> void:
	# tell only player
	if body.name == "Player":
		body.slow_down(self)
		queue_free()

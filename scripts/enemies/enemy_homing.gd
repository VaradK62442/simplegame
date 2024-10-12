extends EnemyBasic

var target
var spawntime
var direction = Vector2.ZERO
var homing_time = 15

func _init() -> void:
	spawn_chance = 5
	speed = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	spawntime = 0
	target = get_parent().get_node("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target = get_parent().get_node("Player")
	spawntime += delta
	
	if target and spawntime < homing_time:
		direction = (target.position - position).normalized()
		rotation = direction.angle()
	else:
		var homing_sprite = get_node("Sprite2D")
		homing_sprite.modulate = Color(1,1,1)
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# tell only player
	if body.name == "Player":
		body.take_damage(self)
		queue_free()

extends EnemyBasic

var target
var spawntime
var direction = Vector2.ZERO
var screen
var collided = false
var sprite

var enemy = load("res://scenes/enemies/enemy_shooter_minion.tscn")

var minion_spawnrate = Config.enemy_flashbang.minion_spawnrate # seconds

func _init() -> void:
	spawn_chance = Config.enemy_flashbang.spawn_chance
	speed = Config.enemy_flashbang.speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	spawntime = 0
	screen = get_viewport_rect().size
	target = Vector2(randf_range(-500, 500), randf_range(-300, 300))
	direction = (target - position).normalized()
	rotation = direction.angle()
	sprite = get_node("Sprite2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (position.x > target.x + 50 or position.x < target.x - 50) and (position.y > target.y + 50 or position.y < target.y - 50):
		position += direction * speed * delta
	else:
		await get_tree().create_timer(5).timeout
		if collided == false:
			queue_free()
	

func _on_body_entered(body: Node2D) -> void:
	# tell only player
	if body.name == "Player" and collided == false:
		collided = true
		sprite.scale = Vector2(10000, 10000)
		sprite.z_index = 8
		sprite.modulate = Color(1, 1, 1, 0)
		for i in range(10, 0, -1):
			sprite.modulate = Color(255, 255, 255, 1.0/float(i))
			await get_tree().create_timer(0.01).timeout
		await get_tree().create_timer(0.1).timeout
		for i in range(1, 41, 1):
			sprite.modulate = Color(255, 255, 255, 1.0/float(i))
			await get_tree().create_timer(0.05).timeout
		queue_free()

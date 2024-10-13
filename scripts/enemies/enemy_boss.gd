extends EnemyBasic

var target
var spawntime
var direction
var turned = false

var enemy = load("res://scenes/enemies/enemy_homing.tscn")

var minion_spawnrate = 8 # seconds

func _init() -> void:
	spawn_chance = Config.enemy_boss.spawn_chance
	speed = Config.enemy_boss.speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	spawntime = 0
	target = get_parent().get_node("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not turned:
		direction = (target.position - position).normalized()
		rotation = direction.angle() - PI/2
		turned = true
	position += Vector2(0, 1).rotated(rotation) * speed * delta
	spawntime += delta
	if spawntime > minion_spawnrate and abs(position.x) < 500 and abs(position.y) < 500 :
		spawntime = 0
		var minion_one = enemy.instantiate()
		var minion_two = enemy.instantiate()
		var minion_three = enemy.instantiate()
		
		minion_one.position = position + Vector2(10, 0)
		minion_two.position = position + Vector2(-7, 7)
		minion_three.position = position + Vector2(-7, -7)
		minion_one.rotation = rotation + 60
		minion_two.rotation = rotation - 60
		minion_three.rotation = rotation - 120

		get_parent().add_child(minion_one)
		get_parent().add_child(minion_two)
		get_parent().add_child(minion_three)

func _on_body_entered(body: Node2D) -> void:
	# tell only player
	if body.name == "Player":
		body.take_damage(self)
		queue_free()

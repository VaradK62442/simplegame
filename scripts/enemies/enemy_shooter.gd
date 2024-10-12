extends EnemyBasic

var target
var spawntime
var direction = Vector2.ZERO

var enemy = load("res://scenes/enemies/enemy_shooter_minion.tscn")

@export var minion_spawnrate = 3 #seconds

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
	position += Vector2(0, 1).rotated(rotation) * speed * delta
	spawntime += delta
	if spawntime > minion_spawnrate:
		spawntime = 0
		var minion_one = enemy.instantiate()
		var minion_two = enemy.instantiate()
		
		minion_one.position = position
		minion_two.position = position
		minion_one.rotation = rotation + 90
		minion_two.rotation = rotation - 90

		get_parent().add_child(minion_one)
		get_parent().add_child(minion_two)

func _on_body_entered(body: Node2D) -> void:
	# tell only player
	if body.name == "Player":
		body.take_damage(self)
		queue_free()

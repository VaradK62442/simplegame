extends EnemyBasic
class_name EnemyShooter

var target
var spawntime
var direction
var turned = false

var enemy = load("res://scenes/enemies/enemy_shooter_minion.tscn")

var minion_spawnrate = Config.enemy_shooter.minion_spawnrate # seconds

func _init() -> void:
	spawn_chance = Config.enemy_shooter.spawn_chance
	speed = Config.enemy_shooter.speed

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
		
		minion_one.position = position
		minion_two.position = position
		minion_one.rotation = rotation + 90 + PI/2
		minion_two.rotation = rotation - 90 + PI/2

		get_parent().add_child(minion_one)
		get_parent().add_child(minion_two)

func _on_body_entered(body: Node2D) -> void:
	# tell only player
	if body.name == "Player":
		body.take_damage(self)
		queue_free()

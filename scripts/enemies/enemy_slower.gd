extends EnemyBasic

var target
var spawntime
var direction = Vector2.ZERO
var slow_down
var duration

func _init() -> void:
	slow_down = 0.5
	duration = 5
	spawn_chance = 10
	speed = 400

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	await get_tree().create_timer(0.1).timeout
	target = get_parent().get_node("Player")
	direction = (target.position - position).normalized()
	rotation = direction.angle() - PI/2
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_body_entered(body: Node2D) -> void:
	# tell only player
	if body.name == "Player":
		body.slow_down(self,slow_down,duration)

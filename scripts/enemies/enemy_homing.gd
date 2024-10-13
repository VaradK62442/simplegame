extends EnemyBasic

var target
var spawntime
var direction = Config.enemy_homing.direction
var homing_time = Config.enemy_homing.homing_time

func _init() -> void:
	spawn_chance = Config.enemy_homing.spawn_chance
	speed = Config.enemy_homing.speed

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
		homing_sprite.modulate = Config.enemy_homing.sprite_modulate
	position += direction * speed * delta
	

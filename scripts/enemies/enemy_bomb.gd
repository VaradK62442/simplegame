extends EnemyBasic

var direction = Vector2(0, 1).rotated(rotation)

var life_duration: int = Config.enemy_bomb.life_duration
var color_change_interval: float = Config.enemy_bomb.color_change_interval
var color_change_timer: float = 0
var flicker_duration: float = Config.enemy_bomb.flicker_duration
var ratio: float = Config.enemy_bomb.ratio

var sprite

var main_color = Config.enemy_bomb.main_color
var flicker_color = Config.enemy_bomb.flicker_color

var enemy = Config.enemy_bomb.enemy
var n_debris = Config.enemy_bomb.n_debris


func _init() -> void:
	spawn_chance = Config.enemy_bomb.spawn_chance
	speed = Config.enemy_bomb.speed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = self.get_node("Sprite2D")
	sprite.modulate = main_color
	
	await get_tree().create_timer(life_duration).timeout
	explode()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
	
	color_change_timer += delta
	if color_change_timer >= color_change_interval:	
		speed *= ratio
		color_change_interval *= ratio
		color_change_timer = 0
		flicker()
		

func flicker() -> void:
	sprite.modulate = flicker_color
	await get_tree().create_timer(flicker_duration).timeout
	sprite.modulate = main_color


func explode() -> void:
	for i in range(n_debris):
		var debris = enemy.instantiate()
		debris.position = self.position
		debris.rotation_degrees = self.rotation_degrees + i * (360.0/n_debris)
		debris.speed *= 2
		self.add_sibling(debris)
	queue_free()

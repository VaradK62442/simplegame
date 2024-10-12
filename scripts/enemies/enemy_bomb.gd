extends EnemyBasic

var direction = Vector2(0, 1).rotated(rotation)

var life_duration: int = 20
var color_change_interval: float = 5
var color_change_timer: float = 0
var flicker_duration: float = 0.1

var sprite

var main_color = Color(0, 1, 1)
var flicker_color = Color(1, 0, 0)



func _init() -> void:
	spawn_chance = 20
	speed = 50


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = self.get_node("Sprite2D")
	sprite.modulate = main_color
	await get_tree().create_timer(life_duration).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
	
	color_change_timer += delta
	if color_change_timer >= color_change_interval:	
		speed *= 0.75
		color_change_interval *= 0.75
		color_change_timer = 0
		flicker()
		

func flicker() -> void:
	sprite.modulate = flicker_color
	await get_tree().create_timer(flicker_duration).timeout
	sprite.modulate = main_color

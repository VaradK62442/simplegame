extends EnemyBasic

var spawn_time = randi_range(10, 15)
var direction = Vector2(0, 1).rotated(rotation)


func _init() -> void:
	spawn_chance = 20
	speed = 25


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var color_change_timer = 0.0
var color_change_interval = 1.0 # Change every 1 second

func _process(delta: float) -> void:
	position += direction * speed * delta
	var sprite = self.get_node("Sprite2D")
	
	color_change_timer += delta
	if color_change_timer >= color_change_interval:
		color_change_timer = 0.0
		if randi() % 2 == 0:
			sprite.modulate = Color(0, 1, 0) # Green
		else:
			sprite.modulate = Color(1, 0, 0) # Red

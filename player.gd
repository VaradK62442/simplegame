extends CollisionPolygon2D

@export var speed = 400
var screen_size
@export var rotation_degs = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO

	if Input.is_action_just_pressed("tilt_left"):
		rotation -= rotation_degs

	if Input.is_action_just_pressed("tilt_right"):
		rotation += rotation_degs

	if Input.is_action_pressed("flap"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

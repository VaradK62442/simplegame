extends CharacterBody2D

@export var speed = 400

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func process_input(delta: float):
	var vel = Vector2.ZERO

	if Input.is_action_pressed("right"):
		vel.x += 1
	if Input.is_action_pressed("left"):
		vel.x -= 1
	if Input.is_action_pressed("down"):
		vel.y += 1
	if Input.is_action_pressed("up"):
		vel.y -= 1

	if vel.length() > 0:
		vel = vel.normalized() * speed
	
	move_and_collide(vel * delta)


func take_damage(bullet):
	print("yeowch " + bullet.name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_input(delta)

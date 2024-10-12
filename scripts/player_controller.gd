extends CharacterBody2D

var health_label

@export var speed = 400
var slowdown = 1
var health = 3
var vulnerable = true
var player_sprite
var default_sprite_colour
var invinsible_colour

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_label = get_parent().get_node("Control").get_node("Health")
	player_sprite = get_node("Sprite2D")
	default_sprite_colour = player_sprite.modulate
	invinsible_colour = default_sprite_colour
	invinsible_colour[3] = 0.5
	invinsible_colour[0] = 155
	pass # Replace with function body.


func process_input(delta: float):
	if health > 0:
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
			vel = vel.normalized() * speed * slowdown
		
		move_and_collide(vel * delta)


func take_damage(bullet):
	if vulnerable:
		health -= 1
		health_label.text = "Health: %01d/3" % [health]
		if health <= 0:
			queue_free()
		else:
			vulnerable = false
			player_sprite.modulate = invinsible_colour
			await get_tree().create_timer(1.5).timeout
			vulnerable = true
			player_sprite.modulate = default_sprite_colour

func slow_down(bullet):
	var slowdown_duration = 5
	$slowdowntimer.start(slowdown_duration)
	slowdown = 0.5
	pass

func _on_slowdowntimer_timeout():
	print("fast again")
	slowdown = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_input(delta)

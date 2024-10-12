class_name EnemyBasic
extends CharacterBody2D

var spawn_chance = 10 # chance per frame of spawning an enemy (out of 100)
var screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# moves in a straight line in direction of facing
	position += Vector2(0, 1).rotated(rotation) * 100 * delta

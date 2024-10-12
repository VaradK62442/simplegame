extends Node2D

var screen
var enemy_dir_path = "res://scenes/enemies/"

# var straight_line_e = preload("res://scenes/enemies/straight_line_e.tscn")
var dir = DirAccess.open(enemy_dir_path)
@export var offset = 16


var all_enemies = []


func load_all_enemies():
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if file_name.ends_with(".tscn"):
			var enemy = load(enemy_dir_path + file_name)
			all_enemies.append(enemy)
		file_name = dir.get_next()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen = get_viewport_rect().size
	load_all_enemies()


func get_random_enemy():
	return all_enemies[randi() % all_enemies.size()]


func get_random_pos():
	var rand_x; var rand_y

	rand_x = randi_range(-screen.x - offset, screen.x + offset)
	rand_y = randi_range(-screen.y - offset, screen.y + offset)

	if randi() % 2 == 0:
		# spawn on the left or right side
		if randi() % 2 == 0:
			rand_x = -screen.x - offset
		else:
			rand_x = screen.x + offset
	else:
		# spawn on the top or bottom side
		if randi() % 2 == 0:
			rand_y = -screen.y - offset
		else:
			rand_y = screen.y + offset

	return [rand_x, rand_y]


func spawn_enemies():
	# spawn enemies at random
	# each frame has a chance of spawning a random enemy
	var enemy = get_random_enemy().instantiate()
	var spawn_chance = enemy.spawn_chance

	var rand_num = randi() % 100
	if rand_num < spawn_chance:

		var rand_pos = get_random_pos()
		enemy.position = Vector2(rand_pos[0], rand_pos[1])
		enemy.rotation = randi_range(0, 360)

		get_parent().add_child(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_enemies()

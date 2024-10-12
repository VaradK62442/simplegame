extends Node2D

var screen
var enemy_dir_path = "res://scenes/enemies/"

# var straight_line_e = preload("res://scenes/enemies/straight_line_e.tscn")
var dir = DirAccess.open(enemy_dir_path)

@export var offset = 16
@export var spawn_anything_chance = 10 # chance of spawning anything at all
@export var spawn_scale_chance = 10 # chance of scaling difficulty

@export var max_spawn_chance = 80 # maximum spawn chance
@export var spawn_midpoint = 150.0 # midpoint (seconds) (midpoint at 2.5 mins)
@export var spawn_growth_value = 0.5 # growth value

@export var difficulty_timer_wait_time = 5.0 # difficulty scales every timer_wait_time seconds
@export var spawning_timer_wait_time = 0.25 # difficulty scales every timer_wait_time seconds

var all_enemies = []


func load_all_enemies():
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if file_name.ends_with(".tscn"):
			var enemy = load(enemy_dir_path + file_name)
			all_enemies.append(enemy)
		file_name = dir.get_next()

var diffuclty_scaling_timer = Timer.new()
var spawning_timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen = get_viewport_rect().size
	load_all_enemies()

	diffuclty_scaling_timer.wait_time = difficulty_timer_wait_time
	diffuclty_scaling_timer.start()
	diffuclty_scaling_timer.connect("timeout", _on_difficulty_timer_timeout)
	
	spawning_timer.wait_time = spawning_timer_wait_time
	spawning_timer.start()
	spawning_timer.connect("timeout", _on_spawning_timer_timeout)


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


func spawn_random_enemy():
	var enemy = get_random_enemy().instantiate()
	var spawn_chance = enemy.spawn_chance

	var rand_num = randi() % 100
	if rand_num < spawn_chance:

		var rand_pos = get_random_pos()
		enemy.position = Vector2(rand_pos[0], rand_pos[1])
		enemy.rotation = randi_range(0, 360)

		get_parent().add_child(enemy)


func difficulty_scaling_function(x, midpoint_x=spawn_midpoint, maximum_value=max_spawn_chance, growth_value=spawn_growth_value):
	return maximum_value / (1 + exp(-growth_value * (x - midpoint_x)))


func _on_difficulty_timer_timeout():
	# scale difficulty
	diffuclty_scaling_timer.start()

	spawn_anything_chance = difficulty_scaling_function(diffuclty_scaling_timer.time_passed)


func _on_spawning_timer_timeout():
	spawning_timer.start()

	# spawn enemies at random
	# each frame has a chance of spawning a random enemy
	if randi() % 100 < spawn_anything_chance:
		spawn_random_enemy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(spawn_anything_chance)

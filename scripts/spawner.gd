extends Node2D

var max_difficulty = 0
var cumsum = []
var screen
var t
var current_time = 0.0
var prev_time = 0.0
const SPAWN_EVERY_MS = Config.spawning.SPAWN_EVERY_MS

func spawn_chance_to_difficulty(chance):
	if chance < Config.spawning.easy_diff_threshold:
		return EnemyDifficulty.INSANE
	elif chance < Config.spawning.medium_diff_threshold:
		return EnemyDifficulty.HARD
	elif chance < Config.spawning.hard_diff_threshold:
		return EnemyDifficulty.MEDIUM
	else:
		return EnemyDifficulty.EASY

@export var offset = Config.spawning.offset


var all_enemies = [
	preload("res://scenes/enemies/enemy_basic.tscn"), 
	preload("res://scenes/enemies/enemy_homing.tscn"),
	preload("res://scenes/enemies/enemy_shooter.tscn"),
	preload("res://scenes/enemies/enemy_flashbang.tscn"),
	preload("res://scenes/enemies/enemy_bomb.tscn"),
	preload("res://scenes/enemies/enemy_slower.tscn"),
]

func enemies_to_cumsum(enemies) -> Array:
	# THIS ALSO SETS max_difficulty, YOU HAVE BEEN WARNED
	for e in enemies:
		max_difficulty += e.instantiate().spawn_chance
		cumsum.append(max_difficulty)
	return cumsum

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	t = TimerTime.new()
	add_child(t)
	screen = get_viewport_rect().size
	cumsum = enemies_to_cumsum(all_enemies)


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
	var rand_num = randi_range(1, max_difficulty)
	var i = 0
	while i < cumsum.size() and rand_num > cumsum[i]:
		i += 1
		
	var enemy = all_enemies[i].instantiate()
	var rand_pos = get_random_pos()
	get_parent().add_child(enemy)
	enemy.position = Vector2(rand_pos[0], rand_pos[1])
	enemy.rotation_degrees = randi_range(0, 360)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_time = t.get_time()
	if (current_time - prev_time) > SPAWN_EVERY_MS:
		prev_time = current_time
		spawn_enemies()

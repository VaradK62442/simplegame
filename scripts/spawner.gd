extends Node2D

var max_difficulty = 0
var cumsum = []
var screen
var t
var current_time = 0.0
var prev_time = 0.0
const SPAWN_EVERY_MS = Config.spawning.SPAWN_EVERY_MS
var enemy_count = 0
var max_enemies = 10 # max number of enemies on screen at every spawn_every_ms time
const FINAL_MAX_ENEMIES = 40
const DIFFICULTY_INTERVAL = 60_000
var prev_max_enemy_time = 0.0
var prev_difficulty_time = 0.0
var current_difficulty = EnemyDifficulty.EASY
var MAX_ENEMY_INTERVAL = 10_000


func spawn_chance_to_difficulty(chance):
	if chance < Config.spawning.insane_difficulty_threshold:
		return EnemyDifficulty.INSANE
	elif chance < Config.spawning.hard_difficulty_threshold:
		return EnemyDifficulty.HARD
	elif chance < Config.spawning.medium_difficulty_threshold:
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
	preload("res://scenes/enemies/enemy_boss.tscn"),
]

var easy_enemies = []
var medium_enemies = []
var hard_enemies = []
var insane_enemies = []

var all_enemy_difficulties

func enemies_to_cumsum(enemies) -> Array:
	# THIS ALSO SETS max_difficulty, YOU HAVE BEEN WARNED
	cumsum = []
	max_difficulty = 0
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
	all_enemy_difficulties = process_enemy_difficulty(all_enemies)


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
	easy_enemies = all_enemy_difficulties[0]
	medium_enemies = all_enemy_difficulties[1]
	hard_enemies = all_enemy_difficulties[2]
	insane_enemies = all_enemy_difficulties[3]

	all_enemies = []
	if current_difficulty == EnemyDifficulty.EASY:
		all_enemies = easy_enemies
	elif current_difficulty == EnemyDifficulty.MEDIUM:
		all_enemies = easy_enemies + medium_enemies
	elif current_difficulty == EnemyDifficulty.HARD:
		all_enemies = easy_enemies + medium_enemies + hard_enemies
	elif current_difficulty == EnemyDifficulty.INSANE:
		all_enemies = easy_enemies + medium_enemies + hard_enemies + insane_enemies

	cumsum = enemies_to_cumsum(all_enemies)

	print("Current difficulty: ", current_difficulty)
	print("all_enmi_difficulties: ", all_enemy_difficulties)
	print("all_enemies: ", all_enemies)
	print("cumsum: ", cumsum)

	var rand_num = randi_range(1, max_difficulty)
	var i = 0
	while i < cumsum.size() and rand_num > cumsum[i]:
		i += 1
		
	var enemy = all_enemies[i].instantiate()
	enemy.add_to_group("enemies")
	var rand_pos = get_random_pos()
	get_parent().add_child(enemy)
	enemy.rotation_degrees = randi_range(0, 360)
	enemy.position = Vector2(rand_pos[0], rand_pos[1])
	if enemy.get_class() != "EnemyShooter":
		var rotation = randf_range(-Config.spawning.spawn_rotation_angle_deg, Config.spawning.spawn_rotation_angle_deg)
		enemy.set_global_transform(enemy.get_global_transform().looking_at($"../Player".global_position).rotated_local(deg_to_rad(rotation)))

func process_enemy_difficulty(all_enemies) -> Array:
	for e in all_enemies:
		var difficulty = spawn_chance_to_difficulty(e.instantiate().spawn_chance)
		match difficulty:
			EnemyDifficulty.EASY:
				easy_enemies.append(e)
			EnemyDifficulty.MEDIUM:
				medium_enemies.append(e)
			EnemyDifficulty.HARD:
				hard_enemies.append(e)
			EnemyDifficulty.INSANE:
				insane_enemies.append(e)

	return [easy_enemies, medium_enemies, hard_enemies, insane_enemies]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_time = t.get_time()
	enemy_count = get_tree().get_nodes_in_group("enemies").size()

	if (current_time - prev_time) > SPAWN_EVERY_MS and enemy_count < max_enemies:
		prev_time = current_time
		spawn_enemies()
	
	if (current_time - prev_max_enemy_time) > MAX_ENEMY_INTERVAL:
		prev_max_enemy_time = current_time
		max_enemies = min(max_enemies + 1, FINAL_MAX_ENEMIES)
	
	if (current_time - prev_difficulty_time) > DIFFICULTY_INTERVAL:
		prev_difficulty_time = current_time
		current_difficulty = min(current_difficulty + 1, EnemyDifficulty.INSANE)
		print("Current difficulty: ", current_difficulty)

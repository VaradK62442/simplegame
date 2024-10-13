extends Node2D


class enemy_basic:
	const spawn_chance = 110 # proportion of spawning in the enemy array, out of 100
	const speed = 100

class enemy_homing:
	const direction = Vector2.ZERO
	const homing_time = 15
	const spawn_chance = 30
	const speed = 50
	const sprite_modulate = Color(1,1,1)

class enemy_bomb:
	const life_duration = 20
	const color_change_interval = 5
	const flicker_duration = 0.1
	const ratio = 0.75

	const main_color = Color(0, 1, 1)
	const flicker_color = Color(1, 0, 0)

	const enemy = preload("res://scenes/enemies/enemy_shooter_minion.tscn")
	const n_debris = 10

	const spawn_chance = 29
	const speed = 50

class enemy_flashbang:
	const minion_spawnrate = 3

	const spawn_chance = 65
	const speed = 150

class enemy_shooter:
	const minion_spawnrate = 3

	const spawn_chance = 37
	const speed = 50

class enemy_slower:
	const spawn_chance = 72
	const speed = 400
	const duration = 5
	const slow_down = 0.33
	
class enemy_boss:
	const spawn_chance = 6
	const speed = 75

class spawning:
	const SPAWN_EVERY_MS = 250

	const insane_difficulty_threshold = 11
	const hard_difficulty_threshold = 31
	const medium_difficulty_threshold = 71

	const offset = 16
	
	const spawn_rotation_angle_deg = 50

class player_controller:
	const speed = 350
	const speed_multiplier = 1
	const health = 3
	const vulnerable = true
	const death_frames = 10

	const invinsible_colour_alpha = 0.5
	const invinsible_colour_red = 155

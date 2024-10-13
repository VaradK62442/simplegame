extends CharacterBody2D

var health_label

var speed = Config.player_controller.speed
var speed_multiplier = Config.player_controller.speed_multiplier
var health = Config.player_controller.health
var vulnerable = Config.player_controller.vulnerable
var player_sprite
var default_sprite_colour
var invinsible_colour
var death_frames = Config.player_controller.death_frames
var gameover_screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_label = get_parent().get_node("Control").get_node("Health")
	player_sprite = get_node("Sprite2D")
	default_sprite_colour = player_sprite.modulate
	invinsible_colour = default_sprite_colour
	invinsible_colour[3] = Config.player_controller.invinsible_colour_alpha
	invinsible_colour[0] = Config.player_controller.invinsible_colour_red
	gameover_screen = load("res://scenes/gameover.tscn").instantiate()


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
			vel = vel.normalized() * speed * speed_multiplier
		
		move_and_collide(vel * delta)


func take_damage(bullet):
	if vulnerable and health > 0:
		
		#decrease health and update label
		health -= 1
		get_parent().get_node("Control").update_health(health)
		
		if health <= 0:
			
			# stop timer
			get_parent().get_node("Control").get_node("Time").is_running = false
			var end_time = get_parent().get_node("Control").get_node("Time").text
			get_parent().get_node("Control").queue_free()
			
			# delete player sprite
			player_sprite.queue_free()
			position.x = 10_000
			
			# change music
			var music_player = get_parent().get_node("AudioStreamPlayer2D")
			music_player.switch_track("res://assets/endtheme.mp3")
			music_player.volume_db = 10
			
			# create death particles
			var directions = [Vector2(0, -1), Vector2(-0.5, -0.866), Vector2(-0.5, 0.866), Vector2(0, 1), Vector2(0.5, 0.866), Vector2(0.5, -0.866)]
			var bits = [Sprite2D.new(), Sprite2D.new(), Sprite2D.new(), Sprite2D.new(), Sprite2D.new(), Sprite2D.new()]
			
			for sprite in bits:
				sprite.scale = Vector2(2.0, 2.0)
				sprite.position = player_sprite.position
				sprite.texture = player_sprite.texture
				sprite.modulate = default_sprite_colour
				add_child(sprite)
			
			# animate death particles
			for i in range(death_frames):
				for index in range(len(bits)):
					bits[index].position += directions[index]
				await get_tree().create_timer(0.10).timeout
			
			# load gameover
			gameover_screen.z_index = 100
			gameover_screen.modulate.a = 0.0
			get_parent().add_child(gameover_screen)
			get_parent().get_node("Gameover").get_node("Score").text = "Time: " + end_time
			
			for i in range(10, 0, -1):
				gameover_screen.modulate.a = 1.0/i
				await get_tree().create_timer(0.10).timeout
				
			for sprite in bits:
				sprite.queue_free()
			
			
		else:
			
			#i-frames
			vulnerable = false
			player_sprite.modulate = invinsible_colour
			await get_tree().create_timer(1.5).timeout
			vulnerable = true
			player_sprite.modulate = default_sprite_colour

func slow_down(bullet,slow_down,duration):
	$slowdowntimer.start(duration)
	speed_multiplier = slow_down
	bullet.queue_free()

func _on_slowdowntimer_timeout():
	speed_multiplier = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_input(delta)

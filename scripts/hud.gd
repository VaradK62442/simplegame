extends Control


var hearts
var time = 0
var up = true
var cur = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hearts = []
	hearts.append($Heart1)
	hearts.append($Heart2)
	hearts.append($Heart3)

func update_health(health):
	for i in range(len(hearts)):
		if i > health - 1:
			hearts[i].modulate.a = 0.5
			hearts[i].modulate.r = 0.2
			hearts[i].modulate.b = 0.5
			hearts[i].modulate.g = 0.5
			
# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta: float) -> void:
	time += delta
	if time > 0.5 and up:
		hearts[cur].position.y -= 1
		time = 0
		up = false
	elif time > 0.5 and not up:
		hearts[cur].position.y += 1
		time = 0
		up = true
		cur = (cur + 1) % 3

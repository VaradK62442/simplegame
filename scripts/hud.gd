extends Control


var hearts
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hearts = []
	hearts.append($Heart1)
	hearts.append($Heart2)
	hearts.append($Heart3)

func update_health(health):
	for i in range(hearts.size()):
		hearts[i].visible = (i < health)
# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta: float) -> void:
	pass

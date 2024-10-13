extends AudioStreamPlayer2D

func switch_track(path):
	var new_stream = load(path)
	if new_stream:
		stream = new_stream
		play()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()

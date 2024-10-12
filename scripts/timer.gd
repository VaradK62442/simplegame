extends Label

var elapsed_time = 0.0

func _process(delta: float) -> void:
	# Update the elapsed time
	elapsed_time += delta
	
	# Format the elapsed time into hours, minutes, and seconds
	var minutes = int((int(elapsed_time) % 3600) / 60)
	var seconds = int(int(elapsed_time) % 60)
	var milliseconds = int(elapsed_time * 100) % 100

	# Update the Label with the formatted time
	text = "Time: %02d:%02d.%02d" % [minutes, seconds, milliseconds]

extends Node
class_name TimerTime

var elapsed_time = 0.0
var minutes = 0.0
var seconds = 0.0
var milliseconds = 0.0

func _process(delta: float) -> void:
	elapsed_time += delta

	minutes = int((int(elapsed_time) % 3600) / 60)
	seconds = int(int(elapsed_time) % 60)
	milliseconds = int(elapsed_time * 1000) % 1000

func get_time() -> float:
	return elapsed_time * 1000

func get_time_pretty() -> Array:
	return [minutes, seconds, int(milliseconds / 10)]

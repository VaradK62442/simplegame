extends Label

var t
var is_running = true

func _ready() -> void:
	t = TimerTime.new()
	add_child(t)

func _process(delta: float) -> void:
	if is_running:
		text = "%02d:%02d.%02d" % t.get_time_pretty()

extends Label

var t

func _ready() -> void:
	t = TimerTime.new()
	add_child(t)

func _process(delta: float) -> void:
	text = "Time: %02d:%02d.%02d" % t.get_time_pretty()

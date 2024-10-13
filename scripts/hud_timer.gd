extends Label

var t
var is_running = true
var diff
var time

func _ready() -> void:
	t = TimerTime.new()
	add_child(t)
	diff = get_parent().get_node("Difficulty")

func _process(delta: float) -> void:
	if is_running:
		time = t.get_time_pretty()
		text = "%02d:%02d.%02d" % time
		var cur_diff = $"../../Spawner".current_difficulty
		match (cur_diff):
			EnemyDifficulty.INSANE:
				diff.text = "Insane"
				diff.modulate = Color(1.0,0.0,0.0,0.8)
			EnemyDifficulty.HARD:
				diff.text = "Hard"
				diff.modulate = Color(1.0,0.0,0.0)
			EnemyDifficulty.MEDIUM:
				diff.text = "Medium"
				diff.modulate = Color(1.0,0.25,0.0)
			EnemyDifficulty.EASY:
				diff.text = "Easy"
				diff.modulate = Color(0.0,1.0,0.0)

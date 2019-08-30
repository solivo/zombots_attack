extends Control

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal game_started
signal game_restarted

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func update_seconds_label(seconds):
	var seconds_str = ""
	if seconds < 10:
		seconds_str = "0" + str(seconds)
	else:
		seconds_str = str(seconds)
	$MarginContainer/Panel/SecondsLabel.text = seconds_str

func update_minutes_label(minutes):
	var minutes_str = ""
	minutes_str = str(minutes)
	$MarginContainer/Panel/MinutesLabel.text = minutes_str

func show_game_over():
	$GameOverContainer.visible = true

func hide_game_over():
	$GameOverContainer.visible = false

func show_end_game():
	$EndGameContainer.visible = true

func hide_end_game():
	$EndGameContainer.visible = false

func _on_World_update_time(seconds, minutes) -> void:
	update_seconds_label(seconds)
	update_minutes_label(minutes)


func _on_World_game_over() -> void:
	show_game_over()


func _on_World_game_started() -> void:
	hide_game_over()


func _on_World_game_lost() -> void:
	show_end_game()
	hide_game_over()


func _on_RestartButton_pressed() -> void:
	emit_signal("game_restarted")
	$ClickAudio.play()
	$BackgroundMusic.play()
	hide_end_game()
	hide_game_over()

func _on_PlayButton_pressed() -> void:
	$ClickAudio.play()
	emit_signal("game_started")
	$BackgroundMusic.play()
	$MainMenuContainer.visible = false
	$Credits.visible = false

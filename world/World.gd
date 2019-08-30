extends Node2D
var Zombot = preload("res://scenes/zombot/Zombot.tscn")
var Player = preload("res://scenes/player/Player.tscn")
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var current_seconds = 0
var current_minutes = 3
signal zombot_on
signal shut_down
signal update_time(seconds, minutes)
signal game_over
signal game_started
signal game_lost
signal remove_bots

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

func activate_zombots():
	$ZombotSound.play()
	$AnimationPlayer.play("zombots_on")
	emit_signal("zombot_on")

func create_zombot():
	var zombot = Zombot.instance()
	var spawn_position = $SpawningPoints.get_child(int(rand_range(0, $SpawningPoints.get_child_count()))).position
	zombot.position = spawn_position
	add_child(zombot)
	#Signals
	connect("zombot_on", zombot, "activate_bot")
	connect("game_over", zombot, "shut_down_bot")
	connect("shut_down", zombot, "shut_down_bot")
	connect("remove_bots", zombot, "remove_zombot")
func _on_ZombotTimer_timeout() -> void:
	activate_zombots()


func _on_SpawningTimer_timeout() -> void:
	create_zombot()

func end_game():
	emit_signal("game_lost")
	$SpawningTimer.stop()
	$ZombotTimer.stop()
	$SecondsTimer.stop()
	emit_signal("update_time", current_seconds, current_minutes)
	emit_signal("shut_down")

func start_game():
	current_seconds = 0
	current_minutes = 3
	$SecondsTimer.start()
	$SpawningTimer.start()
	$ZombotTimer.start()
	#Create_player 
	var player = Player.instance()
	player.position = $PlayerSpawningPoint.position
	add_child(player)
	player.connect("player_died", self, "end_game")
	connect("game_over", player, "shut_down_player")
	connect("shut_down", player, "shut_down_player")
	connect("remove_bots", player, "remove_player")
	#Create the first zombot
	create_zombot()
	emit_signal("game_started")
	emit_signal("update_time", current_seconds, current_minutes)

func restart_game():
	emit_signal("remove_bots")
	start_game()

func finish_game():
	emit_signal("game_over")
	$SecondsTimer.stop()
	$SpawningTimer.stop()
	$ZombotTimer.stop()
	emit_signal("update_time", current_seconds, current_minutes)

func _on_SecondsTimer_timeout() -> void:
	if current_seconds == 0 and current_minutes >= 1:
		current_seconds = 59
		current_minutes -= 1
	elif current_seconds == 0 and current_minutes <= 0:
		print("game_over")
		finish_game()
	elif current_seconds > 0:
		current_seconds -= 1
	emit_signal("update_time", current_seconds, current_minutes)


func _on_GUI_game_started() -> void:
	start_game()


func _on_GUI_game_restarted() -> void:
	restart_game()

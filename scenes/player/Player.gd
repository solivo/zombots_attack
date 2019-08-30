extends KinematicBody2D

export (int) var speed = 2

var target = Vector2()
var velocity = Vector2()
var health = 3
var died = false
var shut_down = false

signal player_died

func _ready() -> void:
	health = 3
	shut_down = false
	$AnimationPlayer.play("player_normal")

func _input(event):
	if event.is_action_pressed('click'):
		speed = 340
		$CPUParticles2D.emitting = true
	elif event.is_action_released("click"):
		speed = 200
		$CPUParticles2D.emitting = false

func damage_player():
	health -= 1
	if health == 2:
		$DamageAudio.play()
		$AnimationPlayer.play("player_transforming_1")
	elif health == 1:
		$DamageAudio.play()
		$AnimationPlayer.play("player_transforming_2")
	elif health == 0:
		$DamageAudio.play()
		$AnimationPlayer.play("player_transforming_3")
		#Game over
		kill_player()

func kill_player():
	emit_signal("player_died")
	died = true

func shut_down_player():
	shut_down = true

func remove_player():
	queue_free()

func _physics_process(delta):
	if not died and not shut_down:
		target = get_global_mouse_position()
		velocity = (target - position).normalized() * speed
	    # rotation = velocity.angle()
		if (target - position).length() > 5:
			velocity = move_and_slide(velocity)
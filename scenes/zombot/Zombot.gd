extends KinematicBody2D

export (int) var speed = 140
var target = Vector2()
var velocity = Vector2()
#Flags
var is_on = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_on = false
	$AnimationPlayer.play("zombot_off")

func _process(delta: float) -> void:
	if is_on:
		target = get_tree().get_nodes_in_group("player")[0].get_global_position()
		velocity = (target - position).normalized() * speed
		if (target - position).length() > 5:
			velocity = move_and_slide(velocity)

func activate_bot():
	is_on = true
	$AnimationPlayer.play("zombot_on")
	$ActivationTimer.start()

func shut_down_bot():
	is_on = false

func _on_ActivationTimer_timeout() -> void:
	is_on = false
	$AnimationPlayer.play("zombot_off")


func _on_AttackArea_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("player"):
		body.damage_player()

func remove_zombot():
	queue_free()

extends CharacterBody2D

@export var SPEED:float = 100.0
@export var hp:float = 50.0
@export var attack_damage:int = 15



@onready var animation = $AnimatedSprite2D
@onready var attack_timer = $AttackCD

enum {
	IDLE,
	FOLLOW_PLAYER,
	ATTACK,
	TAKE_DMG,
	DEATH
}

var died = false
var state = IDLE
var player_in_range = false
var target = null;
var direction = Vector2.ZERO


func _ready():
	state = IDLE

func _process(_delta):
	if PlayerVariables.died:
		state = IDLE
		
	# flip movement animation
	if direction.x < 0:
		animation.flip_h = true
	else:
		animation.flip_h = false

	match state:
		IDLE:
			animation.play("idle")
		FOLLOW_PLAYER:
			animation.play("walk")
		ATTACK:
			animation.play("attack")
		TAKE_DMG:
			animation.play("take_damage")
		DEATH:
			animation.play("death")

func take_damage(value):
	hp -= value
	state = TAKE_DMG
	if hp <= 0:
		died = true
		state = DEATH

func _physics_process(_delta):
	match state:
		FOLLOW_PLAYER:
			direction = (target.global_position - global_position).normalized()
			velocity=direction*SPEED
			move_and_slide()
		

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		target = body
		state = FOLLOW_PLAYER


func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		target = null
		state = IDLE

func attack_player():
	if PlayerVariables.died:
		return
	state = ATTACK
	if target.has_method("update_health"):
		target.update_health(-attack_damage)
		attack_timer.start()
		

func _on_hit_box_body_entered(body):
	if body.is_in_group("player") and attack_timer.is_stopped() and not PlayerVariables.died:
		attack_timer.start()
		player_in_range = true

func _on_hit_box_body_exited(body):
	if body.is_in_group("player"):
		state = FOLLOW_PLAYER
		player_in_range = false
		attack_timer.stop()

func _on_attack_cd_timeout():
	if player_in_range and not PlayerVariables.died:
		attack_player()


func _on_animated_sprite_2d_animation_finished():
	if died:
		# Drop Items
		queue_free()
	state = FOLLOW_PLAYER

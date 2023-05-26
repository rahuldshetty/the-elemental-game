extends CharacterBody2D

@export var player_speed:float = 100.0

@onready var animation:AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	animation.play("idle")

func animate_movement(direction:Vector2):
	if direction.length() > 0:
		animation.play("run")
		if direction.x > 0:
			animation.flip_h = false
		elif direction.x < 0:
			animation.flip_h = true
	else:
		animation.play("idle")

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	velocity = input_direction * player_speed
	animate_movement(input_direction)

func _physics_process(_delta):
	get_input()
	move_and_slide()

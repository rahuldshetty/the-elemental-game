extends Area2D

@export var speed:float = 300

var target
var velocity = Vector2()

func _ready():
	target = get_global_mouse_position()
	velocity = -(position - target).normalized()
	rotation = target.angle_to(velocity)

func _process(delta):
	position += velocity

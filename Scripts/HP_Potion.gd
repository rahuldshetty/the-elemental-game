extends Sprite2D

const TOTAL_FRAMES:int = 8

var frame_id:int = 0

@onready var timer:Timer = $AnimationTimer
@export var hp:float = 10

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and body.has_method("update_health") and body.is_health_low():
		body.update_health(hp)
		body.notify("Picked up HP Potion({hp})".format({
			"hp": hp
		}))
		queue_free()


func _on_animation_timer_timeout():
	self.frame = frame_id
	frame_id = (frame_id + 1) % TOTAL_FRAMES

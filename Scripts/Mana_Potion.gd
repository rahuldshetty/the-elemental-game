extends Sprite2D

const TOTAL_FRAMES:int = 8

var frame_id:int = 0

@onready var timer:Timer = $AnimationTimer
@export var mana:float = 30


func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and body.has_method("update_mana") and body.is_mana_low():
		body.update_mana(mana)
		body.notify("Picked up Mana Potion({mana})".format({
			"mana": mana
		}))
		queue_free()


func _on_animation_timer_timeout():
	self.frame = frame_id
	frame_id = (frame_id + 1) % TOTAL_FRAMES

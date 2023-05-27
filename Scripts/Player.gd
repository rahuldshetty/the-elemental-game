extends CharacterBody2D

const PLAYER_MAX_HEALTH:float = 100.0
const PLAYER_MAX_MANA:float = 100.0

@export var player_speed:float = 100.0
@export var player_health:float = 100.0
@export var player_mana:float = 100
@export var player_gold:int = 0

@onready var hud:CanvasLayer = $PlayerHUD
@onready var animation:AnimatedSprite2D = $AnimatedSprite2D
@onready var hp_bar:TextureProgressBar = $PlayerHUD/HPBar
@onready var mana_bar:TextureProgressBar = $PlayerHUD/ManaBar
@onready var gold_label:Label = $PlayerHUD/CoinBGHud/GoldLabel

# Notification
var notifications = []
@onready var player_notification:Label = $PlayerHUD/PlayerNotification
@onready var player_notif_timer:Timer = $PlayerHUD/PlayerNotification/PlayerNotificationTimer

func _ready():
	animation.play("idle")
	hud.visible = true
	init_player_stats()


func init_player_stats():
	update_health(-12)
	update_mana(PLAYER_MAX_MANA)
	update_gold(0)

func update_health(value):
	player_health += min(value, PLAYER_MAX_HEALTH)
	hp_bar.value = player_health

func is_health_low():
	return player_health < PLAYER_MAX_HEALTH
	
func update_gold(value):
	player_gold += value
	gold_label.text = str(player_gold)
	
func update_mana(value):
	player_mana += min(value, PLAYER_MAX_MANA)
	mana_bar.value = player_mana

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


# Notification Stuff
func notify(message):
	notifications.append(message)
	player_notification.visible = true
	player_notification.text = "\n".join(notifications)
	player_notif_timer.one_shot = false
	player_notif_timer.start()

func _on_player_notification_timer_timeout():
	notifications.pop_front()
	if len(notifications) == 0:
		player_notif_timer.one_shot = true
		player_notif_timer.stop()
		player_notification.visible = false
	player_notification.text = "\n".join(notifications)
	

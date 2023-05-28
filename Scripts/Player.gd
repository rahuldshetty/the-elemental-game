extends CharacterBody2D

const PLAYER_MAX_HEALTH:float = 100.0
const PLAYER_MAX_MANA:float = 100.0
const GOD_SPEED_MOVEMENT:float = 80

var input_direction:Vector2 = Vector2.ZERO;
var god_speed_movement:float = 0

@export var player_speed:float = 125.0
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

# Spells
@onready var orb1:TextureRect = $GamicHUD/Orb1
@onready var orb2:TextureRect = $GamicHUD/Orb2
@onready var orb3:TextureRect = $GamicHUD/Orb3

@onready var spell1:TextureRect = $PlayerHUD/Control/SpellHud1/Spell1
@onready var spell2:TextureRect = $PlayerHUD/Control/SpellHud2/Spell2

@onready var spell1Title:Label = $PlayerHUD/Control/SpellHud1/Spell1Title
@onready var spell2Title:Label = $PlayerHUD/Control/SpellHud2/Spell2Title

@onready var spell1TimerLabel:Label = $PlayerHUD/Control/SpellHud1/Spell1/Spell1TimerLabel
@onready var spell2TimerLabel:Label = $PlayerHUD/Control/SpellHud2/Spell2/Spell2TimerLabel
@onready var spell3TimerLabel:Label = $PlayerHUD/Control/SpellHud3/Spell3/Spell3TimerLabel

@onready var spell1Sweep:TextureProgressBar = $PlayerHUD/Control/SpellHud1/Spell1/Spell1Sweep
@onready var spell2Sweep:TextureProgressBar = $PlayerHUD/Control/SpellHud2/Spell2/Spell2Sweep
@onready var spell3Sweep:TextureProgressBar = $PlayerHUD/Control/SpellHud3/Spell3/Spell3Sweep


var selected_orbs:Array = []
const MAX_ORBS = 3

var ORBS = [
	{
		"id": 0,
		"name": "Fire",
		"x": 0,
	},
	{
		"id": 1,
		"name": "Earth",
		"x": 68,
	},
	{
		"id": 2,
		"name": "Wind",
		"x": 100,
	},
	{
		"id": 3,
		"name": "Water",
		"x": 32,
	},
	{
		"id": 4,
		"name": "Void",
		"x": 128,
	}
]

const SPELL_ICON_PREFIX = "res://Sprites/spell_gui/"

var select_spells = []
const MAX_SPELS = 2

var SPELLS = {
	Vector3i(0,0,0) : {
		"id": Vector3i(0,0,0),
		"name": "Fire Blast",
		"icon": "Spells/fire_spell.png",
		"function": fire_blast,
		"mana": 30,
		"dmg": 69,
		"cd": 8,
		"timer": create_timer(8, _spell_timer_callback),
		"scene": preload("res://Scenes/Spells/fire_blast.tscn"),
		"distance": 150
	},
	Vector3i(1, 1, 1) : {
		"id": Vector3i(1,1,1),
		"name": "Earthen Gaurd",
		"icon": "Buffs/knockback_resistance.png",
		"function": earten_gaurd,
		"mana": 10,
		"dmg": 0,
		"cd": 3.5,
		"timer": create_timer(3.5, _spell_timer_callback),
		"scene": preload("res://Scenes/Spells/earthen_gaurd.tscn"),
		"distance": 65
	},
	Vector3i(1, 2, 2) : {
		"id": Vector3i(1,2,2),
		"name": "God Speed",
		"icon": "Buffs/swiftness.png",
		"function": god_speed,
		"mana": 15,
		"dmg": 0,
		"cd": 5,
		"timer": create_timer(5, _spell_timer_callback),
		"scene": null,
		"distance": 0
	},
	Vector3i(2, 2, 2) : {
		"id": Vector3i(2,2,2),
		"name": "Wind Gush",
		"icon": "Spells/frenzy_spell_(critical_booster).png",
		"function": wind_gush,
		"mana": 2,
		"dmg": 10,
		"cd": 0.8,
		"timer": create_timer(0.8, _spell_timer_callback),
		"scene": preload("res://Scenes/Spells/wind_gush.tscn"),
		"distance": 50
	},
	Vector3i(2, 3, 3) : {
		"id": Vector3i(2,3,3),
		"name": "Mana Regen",
		"icon": "Spells/mana_replenish.png",
		"function": mana_regen,
		"mana": 0,
		"dmg": 0,
		"cd": 2,
		"timer": create_timer(2, _spell_timer_callback),
		"scene": null,
		"distance": 0
	},
	Vector3i(3, 3, 3) : {
		"id": Vector3i(3,3,3),
		"name": "Water Splash",
		"icon": "Spells/water_spell.png",
		"function": water_splash,
		"mana": 15,
		"dmg": 35,
		"cd": 3,
		"timer": create_timer(3, _spell_timer_callback),
		"scene": preload("res://Scenes/Spells/water_splash.tscn"),
		"distance": 86
	},
	Vector3i(2, 3, 4) : {
		"id": Vector3i(2,3,4),
		"name": "Spell Caster",
		"icon": "Buffs/element_boost.png",
		"function": spell_caster,
		"mana": 25,
		"dmg": 0,
		"cd": 20,
		"timer": create_timer(20, _spell_timer_callback),
		"scene": null,
		"distance": 0
	},
	Vector3i(4, 4, 4) : {
		"id": Vector3i(3,3,3),
		"name": "Death",
		"icon": "Spells/summoning_spell.png",
		"function": death_spell,
		"mana": 45,
		"dmg": 350,
		"cd": 35,
		"timer": create_timer(35, _spell_timer_callback),
		"scene": preload("res://Scenes/Spells/death.tscn"),
		"distance": 120
	}
}

var casting_spell = false

func _ready():
	animation.play("idle")
	$GamicHUD.visible = true
	
	
	orb1.visible = false
	orb2.visible = false
	orb3.visible = false
	
	spell1TimerLabel.visible = false
	spell2TimerLabel.visible = false
	
	spell1Sweep.visible = false
	spell2Sweep.visible = false
	
	spell1.visible =  false
	spell2.visible = false
	
	spell1Title.visible = false
	spell2Title.visible = false
	
	hud.visible = true
	init_player_stats()
	
	god_speed_movement = 0


func init_player_stats():
	update_health(-12)
	update_mana(PLAYER_MAX_MANA)
	update_gold(0)

func create_timer(cd, call_back):
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = cd
	timer.process_callback = Timer.TIMER_PROCESS_IDLE
	timer.connect("timeout",  call_back)
	add_child(timer)
	return timer

func get_spell_timer(idx):
	if idx == 0 and len(select_spells) >= 1:
		var key = select_spells[0]
		return SPELLS[key]['timer']
	if idx == 1 and len(select_spells) >= 2:
		var key = select_spells[1]
		return SPELLS[key]['timer']

func update_health(value):
	player_health += value
	player_health = min(player_health, PLAYER_MAX_HEALTH)
	player_health = max(player_health, 0)
	hp_bar.value = player_health


func is_health_low():
	return player_health < PLAYER_MAX_HEALTH
	
func is_mana_low():
	return player_mana < PLAYER_MAX_MANA
	
func update_gold(value):
	player_gold += value
	gold_label.text = str(player_gold)
	
func update_mana(value):
	player_mana += value
	player_mana = min(player_mana, PLAYER_MAX_MANA)
	player_mana = max(player_mana, 0)
	mana_bar.value = player_mana

func is_player_facing_left():
	return animation.flip_h == true

func animate_movement(direction:Vector2):
	if direction.length() > 0:
		casting_spell = false
		animation.play("run")
		if direction.x > 0:
			animation.flip_h = false
		elif direction.x < 0:
			animation.flip_h = true
	else:
		if not casting_spell:
			animation.play("idle")

func get_input():
	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	velocity = input_direction * (player_speed + god_speed_movement)
	animate_movement(input_direction)

func _physics_process(_delta):
	get_input()
	move_and_slide()

func _process(_delta):
	draw_orbs()
	draw_spells()
	draw_spell_timer_ui()

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

# Orbs Stuff
func get_orb_draw_region(x):
	return Rect2(x, 580, 32, 28)

func draw_orbs():
	if len(selected_orbs) >= 1:
		orb1.texture.region = get_orb_draw_region(selected_orbs[0]['x'])
		orb1.visible = true
	if len(selected_orbs) >= 2:
		orb2.texture.region = get_orb_draw_region(selected_orbs[1]['x'])
		orb2.visible = true
	if len(selected_orbs) >= 3:
		orb3.texture.region = get_orb_draw_region(selected_orbs[2]['x'])
		orb3.visible = true

func add_orb(idx):
	selected_orbs.push_front(ORBS[idx])
	selected_orbs = selected_orbs.slice(0, MAX_ORBS)

# Elemnet Fusion

func draw_spells():
	if len(select_spells) >= 1:
		spell1.texture = load(SPELL_ICON_PREFIX + SPELLS[select_spells[0]]['icon'])
		spell1.visible = true
		spell1Title.visible = true
		spell1Title.text = SPELLS[select_spells[0]]['name']
	if len(select_spells) >= 2:
		spell2.texture = load(SPELL_ICON_PREFIX + SPELLS[select_spells[1]]['icon'])
		spell2.visible = true
		spell2Title.visible = true
		spell2Title.text = SPELLS[select_spells[1]]['name']

func add_spell(id):
	if id in select_spells:
		return
	select_spells.push_front(id)
	select_spells = select_spells.slice(0, MAX_SPELS)

func fuse_element():
	if len(selected_orbs) == 3:
		var items = [selected_orbs[0]['id'],
			selected_orbs[1]['id'],
			selected_orbs[2]['id']
		];
		items.sort()
		var key = Vector3i(
			items[0],
			items[1],
			items[2],
		)
		if key in SPELLS:
			add_spell(key)
			
# Spells

func _input(event):
	if Input.is_action_just_pressed("fuse_element"):
		fuse_element()
	if Input.is_action_just_pressed("cast_spell"):
		cast_spell(0)
	if Input.is_action_just_pressed("case_spell_2"):
		cast_spell(1)
	if Input.is_action_just_pressed("orb1"):
		add_orb(0)
	if Input.is_action_just_pressed("orb2"):
		add_orb(1)
	if Input.is_action_just_pressed("orb3"):
		add_orb(2)
	if Input.is_action_just_pressed("orb4"):
		add_orb(3)
	if Input.is_action_just_pressed("orb5"):
		add_orb(4)
	

func cast_spell(idx):		
	if len(select_spells) >= idx + 1:
		# Stop casting if timer is active
		if (idx == 0 and get_spell_timer(0).time_left > 0) or (idx == 1 and get_spell_timer(1).time_left > 0):
			return
		
		if idx == 0:
			spell1TimerLabel.visible = true
			spell1Sweep.visible = true
		elif idx == 1:
			spell2TimerLabel.visible = true
			spell2Sweep.visible = true
		
		var mana = SPELLS[select_spells[idx]]['mana']
		var cd = SPELLS[select_spells[idx]]['cd']
		if player_mana >= mana:
			update_mana(-mana)
			start_spell_cd(cd, idx)
			(SPELLS[select_spells[idx]]['function']).call()

		
func cast_spell_animation():
	animation.play("spell")
	casting_spell = true

func aoe_summon_spell(idx, flip_h=false, scale_value=Vector2(1, 1)):
	var spell = SPELLS[idx]
	var scene = spell['scene']
	cast_spell_animation()
	var aoe_spell:Area2D = scene.instantiate()
	aoe_spell.position = global_position
	if is_player_facing_left():
		aoe_spell.position.x -= spell['distance']
	else:
		aoe_spell.position.x += spell['distance']
		
	if flip_h and is_player_facing_left():
		aoe_spell.set_scale(scale_value)
	
	get_parent().add_child(aoe_spell)


func fire_blast():
	aoe_summon_spell(Vector3i(0,0,0))

func earten_gaurd():
	aoe_summon_spell(Vector3i(1,1,1), true, Vector2(-2, 2))

func wind_gush():
	aoe_summon_spell(Vector3i(2,2,2), true, Vector2(-1, 1))

func water_splash():
	aoe_summon_spell(Vector3i(3,3,3), true, Vector2(-1, 1))

func death_spell():
	aoe_summon_spell(Vector3i(4,4,4), true, Vector2(-1, 1))

func mana_regen():
	update_mana(25)
	
func spell_caster():
	for key in SPELLS:
		# Skip Spell Caster CD
		if key == Vector3i(2, 3, 4):
			continue
		var timer:Timer = SPELLS[key]['timer']
		timer.stop()
		
func god_speed():
	god_speed_movement = GOD_SPEED_MOVEMENT
	var timer = create_timer(4.5, _godspeed_timer_callback)
	timer.start()

func _godspeed_timer_callback():
	god_speed_movement = 0

func _on_animated_sprite_2d_animation_finished():
	if casting_spell:
		casting_spell = false
		animation.play("idle")

func start_spell_cd(cd, idx):
	# since there are 2 timers
	if idx == 0:
		get_spell_timer(0).start(cd)
	if idx == 1:
		get_spell_timer(1).start(cd)
		

func draw_spell_timer_ui():
	if len(select_spells) >= 1 and get_spell_timer(0).time_left > 0:
		spell1TimerLabel.text = "%3.1f" % get_spell_timer(0).time_left
		var cd = SPELLS[select_spells[0]]['cd']
		spell1Sweep.value = int((get_spell_timer(0).time_left / cd) * 100)
	elif len(select_spells) >= 1 and get_spell_timer(0).time_left == 0:
		spell1TimerLabel.visible = false
		spell1Sweep.visible = false
		
	if len(select_spells) >= 2 and get_spell_timer(1).time_left > 0:
		spell2TimerLabel.text = "%3.1f" % get_spell_timer(1).time_left
		var cd = SPELLS[select_spells[1]]['cd']
		spell2Sweep.value = int((get_spell_timer(1).time_left / cd) * 100)
	elif len(select_spells) >= 2 and get_spell_timer(1).time_left == 0:
		spell2TimerLabel.visible = false
		spell2Sweep.visible = false
	

func _spell_timer_callback():
	if len(select_spells) >= 1 and get_spell_timer(0).time_left == 0:
		spell1TimerLabel.visible = false
		spell1Sweep.visible = false
	if len(select_spells) >= 2 and get_spell_timer(1).time_left == 0:
		spell2TimerLabel.visible = false
		spell2Sweep.visible = false



extends CanvasLayer

var screen_shown = false

@onready var respawn_button:TextureButton = $TextureRect/Respawn
@onready var death_screen_show_timer:Timer = $DeathScreenShowTimer

func change_scene(new_scene):
	get_tree().change_scene_to_file(new_scene)
	
func _process(_delta):
	if PlayerVariables.died and not screen_shown and death_screen_show_timer.time_left == 0:
		death_screen_show_timer.start()
	
	if not PlayerVariables.died:
		visible = false
	
	if PlayerVariables.player_gold == 0:
		respawn_button.disabled = true
	else:
		respawn_button.disabled = false
		
func _on_respawn_pressed():
	PlayerVariables.player_gold = PlayerVariables.player_gold / 2
	PlayerVariables.died = false
	PlayerVariables.player_health = PlayerVariables.get_max_health()
	PlayerVariables.player_mana = PlayerVariables.get_max_mana()
	visible = false
	screen_shown = false


func _on_menu_pressed():
	screen_shown = false
	GameManager.game_paused = false
	change_scene("res://Scenes/menus/main_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_death_screen_show_timer_timeout():
	screen_shown = true
	visible = true

extends CanvasLayer

@onready var pause_menu = $TextureRect
@onready var pause_button = $PauseButton

func change_scene(new_scene):
	get_tree().change_scene_to_file(new_scene)

func _process(_delta):
	if GameManager.game_paused:
		pause_menu.visible = true
		pause_button.visible = false
	else:
		pause_menu.visible = false
		pause_button.visible = true

func _on_resume_pressed():
	GameManager.game_paused = false

func _on_quit_pressed():
	get_tree().quit()

func _on_menu_pressed():
	GameManager.game_paused = false
	change_scene("res://Scenes/menus/main_menu.tscn")


func _on_pause_button_pressed():
	GameManager.game_paused = true

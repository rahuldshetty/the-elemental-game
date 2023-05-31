extends Control

var show_controls = false

func change_scene(new_scene):
	get_tree().change_scene_to_file(new_scene)

func _ready():
	$Buttons/ControlMenu.visible = false

func _on_play_button_pressed():
	pass # Replace with function body.


func _on_test_button_pressed():
	change_scene("res://Scenes/TestGame.tscn")


func _on_settings_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()


func _on_control_pressed():
	show_controls = not show_controls
	$Buttons/ControlMenu.visible = show_controls

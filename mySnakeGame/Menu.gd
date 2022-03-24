extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$startButton.grab_focus()

func _on_quitButton_pressed():
	get_tree().quit()

func _on_startButton_pressed():
	get_tree().change_scene("res://Main/Main.tscn")

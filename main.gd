extends Node2D

func _on_quit_pressed():
	get_tree().quit();


func _on_play_pressed():
	get_tree().change_scene_to_file("res://world.tscn");
	# get_tree().change_scene_to_file("res://Level2.tscn");
	# get_tree().change_scene_to_file("res://level3.tscn");




	

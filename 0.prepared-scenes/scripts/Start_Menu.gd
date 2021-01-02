extends Node2D

func _ready():
	$VBoxContainer/join_room.connect("pressed", self, "_show_join_dialog");
	
	
func _show_join_dialog():
	$VBoxContainer/join_dialog.visible = !$VBoxContainer/join_dialog.visible;


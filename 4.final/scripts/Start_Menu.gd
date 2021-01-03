extends Node2D

func _ready():
	$VBoxContainer/join_room.connect("pressed", self, "_show_join_dialog");
	$VBoxContainer/create_room.connect("pressed", self, "_create_room");
	
	
func _show_join_dialog():
	$VBoxContainer/join_dialog.visible = !$VBoxContainer/join_dialog.visible;

func _create_room():
	NetworkGlobal.create_lobby();

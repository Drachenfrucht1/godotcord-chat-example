extends Node2D

func _ready():
	$HBoxContainer/send.connect("pressed", self, "_send");
	NetworkGlobal.connect("new_user", self, "_new_user");
	NetworkGlobal.connect("new_message", self, "_new_message");
	
func _new_user(name):
	$RichTextLabel.text += "\n" + name + " joined the room";
	
func _new_message(author, msg):
	$RichTextLabel.text += "\n" + author + ": " + msg;
	
func _send():
	if $HBoxContainer/LineEdit.text != "":
		NetworkGlobal.rpc("send_message", $HBoxContainer/LineEdit.text);
		$HBoxContainer/LineEdit.text = "";


func _on_back_pressed():
	#TODO disconnect
	SceneSwitcher.change_scene_instant("res://Start_Menu.tscn");

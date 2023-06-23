extends Control

var data

func _update():
	data = SaveLoad._load_settings()
	get_node("VBoxContainer/PassLenghtContainer/SpinBox").value = data[ConstantsDefaultValueData.settings_key_pass_length]
	get_node("VBoxContainer/SpecialsCharContainer/CheckBox").pressed = data[ConstantsDefaultValueData.settings_special_chars]
	pass
	
func _on_SpinBox_value_changed(value):
	data[ConstantsDefaultValueData.settings_key_pass_length] = value
	SaveLoad._save_settings(data)
	pass # Replace with function body.


func _on_CheckBox_toggled(button_pressed):
	data[ConstantsDefaultValueData.settings_special_chars] = button_pressed
	SaveLoad._save_settings(data)
	pass # Replace with function body.

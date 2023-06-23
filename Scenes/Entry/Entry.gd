extends Control
var fav_on = preload("res://Assets/Icons/fav_on.png")
var fav_off = preload("res://Assets/Icons/fav_off.png")
var data
signal update_gui

#Hydrate l'UI de l'entrée avec ses informations
func _hydrate(_data):
	get_node("SiteContainer/LabelSite") .text = _data[ConstantsDefaultValueData.entry_key_website]
	get_node("SiteContainer/FavIcon").icon = fav_on if _data[ConstantsDefaultValueData.entry_key_favorite] else fav_off
	get_node("ScrollContainer/VBoxContainer/PseudoContainer/LabelPseudo").text = _data[ConstantsDefaultValueData.entry_key_pseudo]
	get_node("ScrollContainer/VBoxContainer/PassContainer/LabelPass").text = _data[ConstantsDefaultValueData.entry_key_pass]	
	get_node("SiteContainer/ButtonDelete").connect("pressed",self,"_delete_entry",[_data[ConstantsDefaultValueData.entry_key_id]])
	data = _data.duplicate()
	pass

################################################################################################################
#Supprime l'entrée
func _delete_entry(_id):
	SaveLoad._delete_entry(_id)
	get_tree().get_root().get_node("Main")._load_entries(SaveLoad._load_entries())

########################################## SIGNALS ######################################################################## 

func _on_ButtonClipBoard_pressed():
	OS.set_clipboard(get_node("ScrollContainer/VBoxContainer/PassContainer/LabelPass").text)
	pass # Replace with function body.


func _on_SiteContainer_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_node("ScrollContainer").visible = !get_node("ScrollContainer").visible
	pass # Replace with function body.


func _on_FavIcon_pressed():
	data[ConstantsDefaultValueData.entry_key_favorite] = !data[ConstantsDefaultValueData.entry_key_favorite]
	var fav = data[ConstantsDefaultValueData.entry_key_favorite]
	if fav:
		get_node("SiteContainer/FavIcon").icon= fav_on
	else:
		get_node("SiteContainer/FavIcon").icon = fav_off
	SaveLoad._save_entry(data)
	emit_signal("update_gui")
	pass # Replace with function body.

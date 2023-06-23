extends Control

var Entry_node = preload("res://Scenes/Entry/Entry.tscn") #Scene d'une entrée

onready var entries_container = $ScrollContainer/EntriesContainer #Container d'entrées
onready var entry_form = $Popup/Panel/UpdateNewEntry #Formulaire d'entrée
onready var settings = $SettingPopup/Panel/Settings
onready var popup_entry_form = $Popup #Popup contenant le formulaire d'entrée
onready var popup_settings = $SettingPopup #Popup contenant le formulaire d'entrée



func _ready():
	_load_entries(SaveLoad._load_entries())
	pass # Replace with function body.


#Affiche les entrées indiquées en paramêtre (souvent provenant du chargement du fichier d'entrées
#Affiche les favoris d'abord  
func _load_entries(_entries):
	#Nettoie les entrées du container
	for child in entries_container.get_children():
		entries_container.remove_child(child)	
			
	#Appelle la fonction de tri par favoris et alphabétique
	
	_entries.sort_custom(self,"_sort_alphabetic_and_favorites")
	
	#Ajoute les entrées triées	
	for entry in _entries:
		var n = Entry_node.instance()
		n._hydrate(entry)
		n.get_node("SiteContainer/ButtonUpdate").connect("pressed",self,"_update_entry",[entry])
		n.connect("update_gui",self,"on_update_gui")
		entries_container.add_child(n)
	pass





########################################## FONCTIONS DE TRI #################################################################
#Fonction de tri par favoris
func _sort_entries_by_favorites(a,b):
	return a[ConstantsDefaultValueData.entry_key_favorite]
	
func _sort_alphabetic_and_favorites(a,b):
	if a[ConstantsDefaultValueData.entry_key_favorite] and b[ConstantsDefaultValueData.entry_key_favorite]: 
		return a[ConstantsDefaultValueData.entry_key_website]<b[ConstantsDefaultValueData.entry_key_website]
	elif !a[ConstantsDefaultValueData.entry_key_favorite] and !b[ConstantsDefaultValueData.entry_key_favorite]: 
		return a["site"]<b["site"]
	else:
		return a[ConstantsDefaultValueData.entry_key_favorite]

########################################## SIGNALS ######################################################################## 

#Où: Page principale
#Action: Appui Bouton "Edition"
#Affiche le formulaire d'entrée hydraté
func _update_entry(_entry):
	entry_form._hydrate(_entry)
	popup_entry_form.popup()
	pass
	
#Où: Page principale	
#Action: Appui Bouton "Nouvelle entrée"
#Affiche le formulaire d'entrée vierge
func _on_AddEntry_pressed():
	popup_entry_form.popup()
	entry_form._reset()
	pass # Replace with function body.

#Où: Formulaire d'entrée
#Action: Appui Bouton "Enregistrer"
#Appelle la fonction d'affichage des entrées
#Ferme le formulaire d'entrée
func _on_UpdateNewEntry_register():
	_load_entries(SaveLoad._load_entries())
	popup_entry_form.hide()
	pass # Replace with function body.

#Où: Page principale
#Action: Appui Bouton "Settings"
#Appelle le formulaire d'options
func _on_ButtonSettings_pressed():
	settings._update()
	popup_settings.popup()
	pass # Replace with function body.

#Où: Page principale
#Action: Nouvel Input dans la barre de recherche
#Appelle la fonction d'affichage des entrées avec un tableau d'entrées filtrées par l'Input
#Si l'Input est nul, appelle la fonction d'affichage avec toutes les entrées
func _on_SearchBar_text_changed(new_text):
	var entries = SaveLoad._load_entries()
	if new_text == "":
		_load_entries(entries)
		return
	var copy_entries = entries.duplicate()
	var entries_filtered = []
	new_text = new_text.to_lower()
	for entry in entries:
		var site = entry[ConstantsDefaultValueData.entry_key_website].to_lower()
		if new_text in site:
			entries_filtered.append(entry)

	_load_entries(entries_filtered)					
	pass # Replace with function body.

#Où:Entrée
#Action: Appui Bouton "Favori"
#Met à jour l'affichage des entrées
func on_update_gui():
	_load_entries(SaveLoad._load_entries())

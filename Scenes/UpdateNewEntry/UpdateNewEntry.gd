extends Control

var fav_on = preload("res://Assets/Icons/fav_on.png") #Icone de favori activé
var fav_off = preload("res://Assets/Icons/fav_off.png") #Icone de favori désactivé


onready var username_predictions =$VBoxContainer/UsernamePredictions
onready var fav_icon = $VBoxContainer/SiteContainer/Favorite
onready var username_field = $VBoxContainer/CredentialsContainer/PseudoEdit
onready var pass_field = $VBoxContainer/CredentialsContainer/PasswordEdit
onready var site_field = $VBoxContainer/SiteContainer/SiteEdit
onready var register_button = $VBoxContainer/Enregistrer


signal register


var tags = [] #Tableau de tags, destiné à la prédiction
var usernames = []#Tableau de pseudos, destiné à la prédiction
var data = ConstantsDefaultValueData.entry_default.duplicate()#Tableau des informations de l'entrée

func _ready():
	_get_usernames()
	pass

#Verifie les conditions d'enregistrement
func _process(delta):
	if username_field.text == "" ||  pass_field.text == "" || site_field.text =="":
		register_button.disabled = true
	else:
		register_button.disabled = false
	pass

################################################################################################################	
#Hydrate le formulaire avec les informations sauvegardées
#Appelé lors de l'édition d'une entrée
func _hydrate(_data):
	data = _data
	username_field.text = _data[ConstantsDefaultValueData.entry_key_pseudo]
	pass_field.text = _data[ConstantsDefaultValueData.entry_key_pass]
	site_field.text = _data[ConstantsDefaultValueData.entry_key_website]
	fav_icon.icon = fav_on if _data[ConstantsDefaultValueData.entry_key_favorite] else fav_off
	pass

################################################################################################################	
#Reinitialise les champs du formulaire d'entrée par défaut
func _reset():
	data = ConstantsDefaultValueData.entry_default.duplicate()
	username_field.text = ""
	site_field.text=""
	pass_field.text = ""
	fav_icon.icon = fav_off
	for child in username_predictions.get_children():
		username_predictions.remove_child(child)
	pass

################################################################################################################	
#Hydrate le tableau d'usernames
func _get_usernames():
	var data = SaveLoad._load_pseudos()
	usernames = data[ConstantsDefaultValueData.pseudos_key_label]
	pass
	
################################################################################################################	
#Verifie la pré-éxistence du pseudo dans le tableau usernames
#Sauvegarde le tableau d'usernames à jour
func _save_username():
	var new_pseudo = username_field.text
	if usernames.find(new_pseudo) == -1:
		usernames.append(new_pseudo)
		SaveLoad._save_pseudos(usernames)
	pass
	
################################################################################################################	
#Crée un ID aléatoire
#TODO: Verifier la pré-existence de l'ID
func _generate_id():
	if data[ConstantsDefaultValueData.entry_key_id] == "":
		data[ConstantsDefaultValueData.entry_key_id] = SIDGeneration._generate_id()
	pass



########################################## SIGNALS ######################################################################## 


#Où: Formulaire d'entrée
#Action: Nouvel Input dans l'edit d'username
#Met à jour les prédictions d'usernames
func _on_PseudoEdit_text_changed(new_text):
	#Vide les predictions
	for pseudo in username_predictions.get_children():
		username_predictions.remove_child(pseudo)
		
	#Predit les usernames en fonction du nouvel Input
	#Permet l'ajout d'une prédction par l'appel de la fonction "_on_username_prediction_pressed"
	for pseudo  in usernames:
		if new_text in pseudo:
			var pseudo_sugg = Button.new()
			pseudo_sugg.text = pseudo
			pseudo_sugg.connect("pressed",self,"_on_username_prediction_pressed",[pseudo_sugg])
			username_predictions.add_child(pseudo_sugg)
			pass
	data[ConstantsDefaultValueData.entry_key_pseudo] = new_text
	pass 

#Selectione une prédiction comme nouvel username
#Nettoie les suggestions
func _on_username_prediction_pressed(_pseudo):
	username_field.text = _pseudo.text
	data[ConstantsDefaultValueData.entry_key_pseudo]  = _pseudo.text
	for pseudo in username_predictions.get_children():
		username_predictions.remove_child(pseudo)
	pass
	
	

################################################################################################################	
#Où: Formulaire d'entrée
#Action: Nouvel Input dans l'edit du site
#Met à jour le site de l'entrée
func _on_SiteEdit_text_changed(new_text):
	data[ConstantsDefaultValueData.entry_key_website] = new_text
	pass # Replace with function body.

################################################################################################################	
#Où: Formulaire d'entrée
#Action: Nouvel Input dans l'edit du password
#Met à jour le password de l'entrée
func _on_PasswordEdit_text_changed(new_text):
	data[ConstantsDefaultValueData.entry_key_pass] = new_text
	pass 
################################################################################################################	
#Où: Formulaire d'entrée
#Action: Appui sur l'icone de favoris
#Met à jour la favorisation de l'entrée
func _on_Favorite_toggled(button_pressed):
	data[ConstantsDefaultValueData.entry_key_favorite] = button_pressed
	if button_pressed:
		fav_icon.icon = fav_on
	else:
		fav_icon.icon = fav_off
	pass 
	
################################################################################################################	
#Où: Formulaire d'entrée
#Action: Appui sur le button de generation de password
#Met à jour le password de l'entrée
func _on_RandomPassword_pressed():
	pass_field.text = SPasswordManager._random_pass()
	_on_PasswordEdit_text_changed(pass_field.text)
	pass 
################################################################################################################	

#Où: Formulaire d'entrée
#Action: Appui sur le bouton "Enregistrer"
#Genere un ID
#Sauvegarde les predictions de tags et d'usernames
#Sauvegarde l'entrée
#Previent le Main de mettre à jour l'UI
func _on_Enregistrer_pressed():
	_generate_id()
	print()
	data[ConstantsDefaultValueData.entry_key_website][0] = data[ConstantsDefaultValueData.entry_key_website][0].to_upper()
	SaveLoad._save_entry(data)
	_save_username()
	emit_signal("register")
	pass # Replace with function body.

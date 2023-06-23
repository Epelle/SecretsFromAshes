class_name SaveLoad

const savepath_tags = "user://Data/tags.json"	
const savepath_pseudos = "user://Data/pseudos.json"
const savepath_settings = "user://Data/settings.json"
const savepath_entries = "user://Data/Entries/"


static func _save_entry(_dict):
	var filename = "user://Data/Entries/"+_dict["id"]+".json"
	save_overwrite(filename,_dict)
	pass

static func _load_entries():
	var datas = []
	var dir = Directory.new()
	if dir.open(savepath_entries) == 31:
		dir.make_dir_recursive("user://Data/Entries/")
		
	if dir.open(savepath_entries) == OK:
		dir.list_dir_begin(true,true)
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var path = savepath_entries+file_name
				var data = load_all(path)
				if data:
					datas.append(data)
				else:
					datas.append(ConstantsDefaultValueData.entry_default)
				file_name = dir.get_next()
	else:
		print("Code Erreur: "+ str(dir.open(savepath_entries)))				
	return datas	
	
static func _delete_entry(_id):
	var dir = Directory.new()
	var path = savepath_entries + _id+".json"
	dir.remove(path)
################################################################################
	
static func _load_settings():
	var settings = load_all(savepath_settings)
	if settings:
		return settings
	return ConstantsDefaultValueData.settings_default

static func _save_settings(_data):
	save_overwrite(savepath_settings,_data)
	pass	
################################################################################	
#Supprimer à la V1

#static func _save_tags(_array):
#	var dict = {ConstantsDefaultValueData.tags_key_label : _array}
#	save_overwrite(savepath_tags, dict)
#	pass
#
#static func _load_tags():
#	var data = load_all(savepath_tags)
#	if data:
#		return data
#	return ConstantsDefaultValueData.tags_default


################################################################################
static func _save_pseudos(_pseudos):
	var dict = {ConstantsDefaultValueData.pseudos_key_label : _pseudos}
	save_overwrite(savepath_pseudos, dict)
	pass
	
static func _load_pseudos():
	var data = load_all(savepath_pseudos)
	if data:
		return data
	return ConstantsDefaultValueData.pseudos_default
		

################################################################################

	
static func save_overwrite(_filename,_dict):
	var save_file = File.new()
	if save_file.open(_filename,File.WRITE) == OK:
		save_file.store_line(to_json(_dict))
		save_file.close()
	else:
		print(_filename + " n'exite pas")
#	if save_file.file_exists((_filename)):
#		print("Sauvegarde de "+_filename+" est terminée")
#	else:
#		print(_filename+" n'a pas pu être sauvegardé")
	pass
	
static func _save_append_file(_filename, _dict):
	var save_file = File.new()
	var open_mode = File.READ_WRITE
	if !save_file.file_exists(_filename):
		open_mode = File.WRITE
	save_file.open(_filename, open_mode)
	save_file.store_line(to_json(_dict))
	save_file.close()
	pass
	
static func load_all(_filename):
	var save = File.new()
	if not save.file_exists(_filename):
#		print(_filename+" n'existe pas")
		return false
	save.open(_filename, File.READ)
	var data = parse_json(save.get_as_text())
	return data


static func load_by_line(_filename):
	var file = File.new()
	if not file.file_exists(_filename):
		print(_filename+" n'existe pas")
		return []
	file.open(_filename, File.READ)	
	var datas = []
	while file.get_position() < file.get_len():
		datas.append(parse_json(file.get_line()))
	return datas

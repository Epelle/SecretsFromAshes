class_name ConstantsDefaultValueData

const settings_key_pass_length = "pass_length"
const settings_special_chars = "special_chars"

const settings_default = {
	settings_key_pass_length: 12,
	settings_special_chars: true
}

################################################################################
const entry_key_id = "id"
const entry_key_pseudo = "pseudo"
const entry_key_pass = "pass"
const entry_key_website = "site"
const entry_key_favorite = "favorite"
#const entry_key_tags = "tags" #Supprimer pour la V1

const entry_default = {
	entry_key_id : "",
	entry_key_website : "",
	entry_key_pseudo : "",
	entry_key_pass : "",
	entry_key_favorite : false
#	entry_key_tags : [], #Supprimer pour la V1
	
}

################################################################################
#Supprimer pour la V1

#const tags_key_label = "tags"
#const tags_default = {
#	tags_key_label: []
#}

###############################################################################

const pseudos_key_label = "pseudos"
const pseudos_default = {
	pseudos_key_label: []
}

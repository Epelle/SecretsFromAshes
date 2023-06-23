class_name SPasswordManager

static func _random_pass():
	var settings = SaveLoad._load_settings()
	var authorized = "azertyuiopqsdfghjklmwxcvbnAZERTYUIOPQSDFGHJKLMWXCVBN0123456789"
	if settings[ConstantsDefaultValueData.settings_special_chars]:
		authorized += "&#~{[(-|`_\\=^@]°)]},?;./:!§%*$£¨+"
	var passwordSize = settings[ConstantsDefaultValueData.settings_key_pass_length]
	var password = ""
	var rand = RandomNumberGenerator.new()
	for i in range(passwordSize):
		rand.randomize()
		password += authorized[rand.randi_range(0, authorized.length()-1)]
	return password

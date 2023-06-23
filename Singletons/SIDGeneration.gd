class_name SIDGeneration
const alphabet = "azertyuiopqsdfghjklmwxcvbn123456789"
const length = 8

static func _generate_id():
	var id = ""
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	for i in length:
		id += alphabet[rand.randi_range(0, alphabet.length()-1)]
	return id

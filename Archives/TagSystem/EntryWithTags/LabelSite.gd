extends Label


#Animations  de transparence au survol du Label
func _on_LabelSite_mouse_entered():
	modulate.a = 0.4
	pass # Replace with function body.


func _on_LabelSite_mouse_exited():
	modulate.a = 1
	pass # Replace with function body.

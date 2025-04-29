extends CanvasLayer

class_name NotificationsManager
@onready var label = $NotificationLabel

func _ready() -> void:
	label.text = ""

func showMessage(text: String, duration: float = 2.0):
	label.text = text
	label.modulate.a = 0.0  

	var tween = create_tween()

	
	tween.tween_property(label, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	
	tween.tween_interval(duration)


	tween.tween_property(label, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

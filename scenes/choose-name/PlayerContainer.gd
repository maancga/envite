extends PanelContainer

class_name PlayerContainer

@onready var leaderIcon = $Layout/LeaderIcon

func _ready():
	leaderIcon.visible = false

func isLeader():
	leaderIcon.visible = true

func isYou():
	$Layout/PlayerLabel.add_theme_color_override("font_color", "54ba5e")

func changeName(newName: String):
	$Layout/PlayerLabel.text = newName

func isGameOwner():
	print("a")

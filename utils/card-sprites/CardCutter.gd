extends Node

const SOURCE = "res://utils/card-sprites/mmartin-baraja-espanola-03b-original.png"
const CARD_WIDTH = 113
const CARD_HEIGHT = 175
const X_INITIAL_OFFSET = 40
const BETWEEN_X_OFFSET = 42
const Y_INITIAL_OFFSET = 40
const BETWEEN_Y_OFFSET = 15
const COLUMNS = 5
const ROWS = 4
const OUTPUT_DIR = "user://cards_generated/"

func _ready():
	var a: Texture2D = load(SOURCE)
	var sheet = a.get_image()

	for row in range(ROWS):
		for col in range(COLUMNS):
			var img = Image.create(CARD_WIDTH, CARD_HEIGHT, false, sheet.get_format())
			var from_rect = Rect2i(
				(col * (CARD_WIDTH + (0 if col == 0 else BETWEEN_X_OFFSET))) + (X_INITIAL_OFFSET ), 
				(row * (CARD_HEIGHT + (0 if row == 0 else BETWEEN_Y_OFFSET))) + Y_INITIAL_OFFSET , 
				CARD_WIDTH, 
				CARD_HEIGHT)
			img.blit_rect(sheet, from_rect, Vector2i(0, 0))
			
			var copaOrOro = 'copas' if row < 2 else 'oro'

			var file_path = "user://cards_generated/card_%s_%d.png" % [copaOrOro, col + (5 * row) - (10 if copaOrOro == 'oro' else 0)]
			var error = img.save_png(file_path)

			if error != OK:
				print("❌ Failed to save:", file_path, "Error:", error)
			else:
				print("✅ Saved:", file_path)

class_name ServerPlayer

var id: String
var name: String
var _isReady: bool = false

func _init(newId: String, newName: String):
    id = newId
    name = newName

func isReady():
    return _isReady

func changeName(newName):
    name = newName
    _isReady = true

func toDictionary() -> Dictionary:
    return {
        "id": id,
        "name": name,
    }
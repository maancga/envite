class_name ServerPlayer

var id: String
var name: String

func _init(newId: String, newName: String):
    id = newId
    name = newName

func toDictionary() -> Dictionary:
    return {
        "id": id,
        "name": name,
    }
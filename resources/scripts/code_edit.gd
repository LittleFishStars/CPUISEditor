extends HBoxContainer

signal copy(code)
signal changed

@export var num: int = 8:
	set(new_num):
		num = new_num
		$Code.num = new_num
		self.sort_children.emit()
@export var button_size: int = 8:
	set(new_size):
		button_size = new_size
		$Code.button_size = new_size
		self.sort_children.emit()

var code: Dictionary:
	get:
		return $Code.code
	set(new_code):
		$Code.code = new_code

func _on_del_pressed() -> void:
	self.queue_free()

func _on_copy_pressed() -> void:
	self.copy.emit($Code.code)

func _on_sort_children() -> void:
	self.size.x = $Code.size.x + $Button.size.x
	$Background.size = self.size
	$Button/Panel.size = $Button.size

func _on_code_changed() -> void:
	self.changed.emit()

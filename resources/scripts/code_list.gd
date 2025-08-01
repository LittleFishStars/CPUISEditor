extends VBoxContainer

signal changed

var code = preload("res://scenes/code_edit.tscn")

@export var button_size: int = 64:
	set(new_size):
		button_size = new_size
		for child in $List.get_children():
			child.button_size = new_size
@export var num: int = 8:
	set(new_num):
		num = new_num
		for child in $List.get_children():
			child.num = new_num

var codes: Array:
	get:
		var c = []
		for child in $List.get_children():
			c.append(child.code)
		return c
	set(new_codes):
		self.clean()
		for code in new_codes:
			self.code_copy(code)

func _on_add_pressed() -> Control:
	var child = self.code.instantiate()
	$List.add_child(child)
	child.num = self.num
	child.button_size = self.button_size
	child.changed.connect(self.code_changed)
	child.copy.connect(self.code_copy)
	return child

func clean() -> void:
	for child in $List.get_children():
		$List.remove_child(child)
		child.queue_free()

func code_changed() -> void:
	self.changed.emit()

func code_copy(code: Dictionary) -> void:
	var child = self._on_add_pressed()
	child.code = code

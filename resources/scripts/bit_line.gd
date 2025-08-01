extends HBoxContainer

signal changed

var bit = preload("res://scenes/bit.tscn")

@export var button_size: int = 64:
	set(new_size):
		button_size = new_size
		for child: SwitchButton in self.get_children():
			child.button_size = new_size

@export var num: int = 8:
	set(new_num):
		num = new_num
		for child in self.get_children():
			self.remove_child(child)
			child.queue_free()
		self.add_bits(new_num)

@export var icons: Array[Texture2D]:
	set(new_icons):
		icons = new_icons
		for child in self.get_children():
			child.icons = new_icons

var bits: Array:
	get:
		var b = []
		for child: SwitchButton in get_children():
			b.append(child.state)
		return b
	set(new_bits):
		var children = get_children()
		for i in range(len(children)):
			children[i].state = new_bits[i]

func add_bits(num: int) -> void:
	for i in range(num):
		var child: SwitchButton = self.bit.instantiate()
		self.add_child(child)
		child.icons = self.icons
		child.button_size = self.button_size
		child.pressed.connect(self.bit_changed)

func _ready() -> void:
	self.add_bits(self.num)

func bit_changed() -> void:
	self.changed.emit()

func _on_sort_children() -> void:
	self.size.x = self.button_size * self.num

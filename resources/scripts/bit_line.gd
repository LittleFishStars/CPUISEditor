extends Container

signal changed

var bit = preload("res://scenes/bit.tscn")
var divider = preload("res://scenes/divider.tscn")

@export var button_size: int = 64:
	set(new_size):
		button_size = new_size
		for child: SwitchButton in $Bits.get_children():
			child.button_size = new_size
		self.add_divider()

@export var num: int = 8:
	set(new_num):
		var d = new_num - num
		if d > 0:
			self.add_bits(d)
		elif d < 0:
			var children = $Bits.get_children()
			for i in range(children.size()):
				if i >= -d:
					break
				$Bits.remove_child(children[-i-1])
				children[-i-1].queue_free()
		num = new_num
		self.add_divider()

@export var icons: Array[Texture2D]:
	set(new_icons):
		icons = new_icons
		if $Bits != null:
			for child in $Bits.get_children():
				child.icons = new_icons

var bits: Array:
	get:
		var b = []
		for child: SwitchButton in $Bits.get_children():
			b.append(child.state)
		return b
	set(new_bits):
		var children = $Bits.get_children()
		for i in range(children.size()):
			children[i].state = new_bits[i]

func add_bits(num: int) -> void:
	for i in range(num):
		var child: SwitchButton = self.bit.instantiate()
		$Bits.add_child(child)
		child.icons = self.icons
		child.button_size = self.button_size
		child.pressed.connect(self.bit_changed)

func _ready() -> void:
	self.add_bits(self.num)

func bit_changed() -> void:
	self.changed.emit()

func _on_sort_children() -> void:
	$Dividers.size = $Bits.size
	self.custom_minimum_size.x = self.button_size * self.num
	self.custom_minimum_size.y = $Bits.size.y

func add_divider():
	for child in $Dividers.get_children():
		$Dividers.remove_child(child)
		child.queue_free()
	for i in range(int($Bits.get_children().size() / 8) - 1):
		var child: VSeparator = self.divider.instantiate()
		$Dividers.add_child(child)
		child.position.x = (i + 1) * 8 * self.button_size - 2
		child.size.y = self.button_size

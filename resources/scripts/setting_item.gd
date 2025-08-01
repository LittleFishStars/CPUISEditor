@tool
@icon('res://resources/icons/setting_item.svg')
class_name SettingItem
extends Container

@export var text: String = '':
	get:
		if self.label:
			return self.label.text
		else:
			return text
	set(new_text):
		text = new_text
		if self.label:
			self.label.text = new_text
@export var alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT:
	get:
		if self.label:
			return self.label.horizontal_alignment
		else:
			return alignment
	set(new_alignment):
		alignment = new_alignment
		if self.label:
			self.label.horizontal_alignment = new_alignment

var label = Label.new()
var child: Control

func _init() -> void:
	self.add_child(self.label, true, Node.INTERNAL_MODE_FRONT)
	self.sort_children.connect(_on_sort_children)

func _ready() -> void:
	var children = self.get_children()
	if children.size() == 0:
		push_error('need a child node!')
	elif children.size() > 1:
		push_error('only need one child node!')
	else:
		self.child = children[0]

func _on_sort_children() -> void:
	self.custom_minimum_size.x = self.label.size.x + self.child.size.x
	self.custom_minimum_size.y = max(self.label.size.y, self.child.size.y)
	self.child.position.x = self.size.x - self.child.size.x

extends Container

var file: Dictionary:
	get:
		return $ScrollContainer/Edit.file
	set(new_file):
		$ScrollContainer/Edit.file = new_file
var path: String = 'user://temp.cis':
	set(new_path):
		path = new_path
		var file_name = '.'.join((new_path.split('/')[-1]).split('.').slice(0, -1))
		DisplayServer.window_set_title('指令集编辑器--' + file_name)
var setting: Dictionary = {
	'last': self.path,
	'last_open_path': 'user://'
}

func _ready() -> void:
	DisplayServer.window_set_title('指令集编辑器--新文件')
	self.get_setting()
	var file = self.read(self.path)
	if file != {}:
		self.file = file

func get_setting() -> void:
	var setting = JsonReader.read('user://config.json')
	if setting.state:
		if setting.state == JsonReader.state.READ_ERROR:
			if setting.code == ERR_FILE_NOT_FOUND:
				JsonReader.write('user://config.json', self.setting)
	else:
		self.setting = setting.data

func _notification(what):
	if (what == NOTIFICATION_WM_CLOSE_REQUEST) or (what == NOTIFICATION_APPLICATION_PAUSED):
		self.save(self.path)
		JsonReader.write('user://config.json', self.setting)
		get_tree().quit()

func _on_sort_children() -> void:
	$TextureRect.size = self.size
	$ScrollContainer.position.y = $MenuBar.size.y
	$ScrollContainer.position.x = (self.size.x - $ScrollContainer.size.x) / 2
	$ScrollContainer.size.x = self.size.x
	$ScrollContainer.size.y = self.size.y - $MenuBar.size.y


func _on_file_id_pressed(id: int) -> void:
	match id:
		1:
			$OpenFile.current_path = self.setting.last_open_path
			$OpenFile.show()
		2:
			if self.path == 'user://temp.cis':
				$SaveFile.show()
			else:
				self.save(self.path)
		3:
			$SaveFile.show()
		4:
			$ScrollContainer/Edit.clean()
		5:
			$Setting.show()

func show_error(massage: String) -> void:
	$ErrorWindow.dialog_text = massage
	$ErrorWindow.show()

func read(path: String) -> Dictionary:
	var json = JsonReader.read(path)
	if json.state:
		match json.state:
			JsonReader.state.READ_ERROR:
				self.show_error('文件读取错误！\n错误代码：' + str(json.code))
			JsonReader.state.JSON_ERROR:
				self.show_error('文件解析错误！\n错误信息：' + json.massage + '，行数：' + str(json.line))
			_:
				self.show_error('发生错误！')
		return {}
	return json.data

func _on_open_file_file_selected(path: String) -> void:
	self.path = path
	self.file = self.read(path)
	self.setting.last_open_path = path

func save(path: String) -> void:
	var state = JsonReader.write(path, self.file)
	match state.state:
		JsonReader.state.OK:
			$Massage.dialog_text = '保存成功！'
			$Massage.show()
		JsonReader.state.WRITE_ERROR:
			self.show_error('文件读取错误！\n错误代码：' + str(state.code))
		_:
			self.show_error('发生错误！')

func _on_save_file_file_selected(path: String) -> void:
	self.save(path)

func _on_setting_close(bit: int) -> void:
	$ScrollContainer/Edit.num = bit

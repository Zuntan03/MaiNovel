(function () {
	let maiNovel = {
		config: {},
		voices: {},
		scenes: []
	};

	maiNovel.formatSceneCode = function (index) {
		let format = maiNovel.config.sceneCodeFormat;
		return "s" + (format + index).slice(-format.length);
	};

	maiNovel.formatMessageCode = function (index) {
		let format = maiNovel.config.messageCodeFormat;
		return "m" + (format + index).slice(-format.length);
	};

	let loadConfig = function (config, data) {
		let setDefaultValue = function (dst, src, memberName, defaultValue) {
			if (typeof src[memberName] != "undefined") {
				dst[memberName] = src[memberName];
			} else {
				dst[memberName] = defaultValue;
			}
		}

		setDefaultValue(config, data, "title", "MaiNovel");
		config.voiceName = data.voiceName;
		setDefaultValue(config, data, "sceneCodeFormat", "00");
		setDefaultValue(config, data, "messageCodeFormat", "00");
		setDefaultValue(config, data, "imageFormat", "png");
		setDefaultValue(config, data, "audioFormat", "wav");
		setDefaultValue(config, data, "audioInterval", 1000);
		setDefaultValue(config, data, "credit", "");
	};

	let loadVoice = function (data) {
		let voice = {
			name: data.voiceName,
			ciiStyleId: data.ciiStyleId
		};
		return voice;
	};

	let loadScene = function (data, index) {
		let scene = {
			name: data.sceneName,
			voiceName: data.voiceName,
			audioInterval: data.audioInterval,
			index: index,
			code: maiNovel.formatSceneCode(index),
			messages: []
		};
		if (typeof scene.name == "undefined") { scene.name = scene.code; }

		for (let mi = 0; mi < data.messages.length; mi++) {
			scene.messages[mi] = loadMessage(data.messages[mi], mi);
		}
		return scene;
	};

	let loadMessage = function (data, index) {
		let message = {
			index: index,
			code: maiNovel.formatMessageCode(index)
		};
		if (typeof data == "string") {
			message.text = data;
			message.insertHTML = "";
		} else {
			message.text = (typeof data.text == "undefined") ? "" : data.text;
			message.insertHTML = (typeof data.insertHTML == "undefined") ? "" : data.insertHTML;
			message._voiceName = data.voiceName;
			message._audioInterval = data.audioInterval;
			message.imageName = data.imageName;
			message.imagePath = data.imagePath;
			message.ciiVolume = data.ciiVolume;
			message.ciiSpeed = data.ciiSpeed;
			message.ciiText = data.ciiText;
		}
		return message;
	};

	let initializeMessage = function (novel, scene, message) {
		message.name = scene.code + message.code;
		message.scene = scene;

		let nextMsgIdx = message.index + 1;
		if (nextMsgIdx == scene.messages.length) {
			let nextScnIdx = scene.index + 1;
			if (nextScnIdx == novel.scenes.length) { nextScnIdx = 0; }
			message.next = novel.scenes[nextScnIdx].messages[0];
		} else {
			message.next = scene.messages[nextMsgIdx];
		}

		message.voiceName = message._voiceName;
		if (typeof message.voiceName == "undefined") { message.voiceName = scene.voiceName; }
		if (typeof message.voiceName == "undefined") { message.voiceName = novel.config.voiceName; }
		if (typeof message.voiceName == "string") { message.voice = novel.voices[message.voiceName]; }

		message.audioInterval = message._audioInterval;
		if (typeof message.audioInterval == "undefined") { message.audioInterval = scene.audioInterval; }
		if (typeof message.audioInterval == "undefined") { message.audioInterval = novel.config.audioInterval; }
		if (typeof message.audioInterval == "undefined") { message.audioInterval = 0; }

		let aFmt = novel.config.audioFormat;
		message.audioPath = `${aFmt}/${scene.code}/${message.name}.${aFmt}`;

		if (typeof message.imagePath == "undefined") {
			let iFmt = novel.config.imageFormat;
			if (typeof message.imageName == "undefined") {
				message.imagePath = `${iFmt}/${scene.code}/${message.name}.${iFmt}`;
			} else {
				let firstChar = message.imageName.charAt(0);
				if (firstChar == "m") {
					message.imagePath = `${iFmt}/${scene.code}/${scene.code}${message.imageName}.${iFmt}`;
				} else if (firstChar == "s") {
					mIdx = message.imageName.indexOf("m");
					if (mIdx != -1) {
						sceneCode = message.imageName.substring(0, mIdx);
						message.imagePath = `${iFmt}/${sceneCode}/${message.imageName}.${iFmt}`;
					}
				}
			}
		}
	};

	maiNovel.loadFromJson = function (json) {
		let data = JSON.parse(json);
		loadConfig(maiNovel.config, data.config);

		for (let vi = 0; vi < data.voices.length; vi++) {
			let voice = loadVoice(data.voices[vi]);
			maiNovel.voices[voice.name] = voice;
		}

		for (let si = 0; si < data.scenes.length; si++) {
			maiNovel.scenes[si] = loadScene(data.scenes[si], si);
		}

		for (let si = 0; si < maiNovel.scenes.length; si++) {
			let scene = maiNovel.scenes[si];
			for (let mi = 0; mi < scene.messages.length; mi++) {
				initializeMessage(maiNovel, scene, scene.messages[mi]);
			}
		}
	};

	window.maiNovel = maiNovel;
})();

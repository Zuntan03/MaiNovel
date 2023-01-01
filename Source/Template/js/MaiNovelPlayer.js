(function () {
	let novel = window.maiNovel;
	let player = {
		jsonFilePath: "MaiNovel.json",
		infiniteLoop: false,
		r18: false,
		autoPlay: true,
		loopMode: "None",
		playSpeed: 1.0,
		volume: 0.5,
		preLoadMessage: null,
		playMessage: null,
		timeoutId: null
	};
	window.maiNovelPlayer = player;

	let onJsonLoaded = function (e) {
		if (player.r18) {
			let cookieStr = "MaiNovelOver18=true";
			let over18 = (document.cookie.indexOf(cookieStr) != -1)
			// if (over18) { document.cookie = `${cookieStr}; max-age=0`; }

			if (!over18) {
				let adult = window.confirm("あなたは18歳以上ですか？\n\n" +
					"このコンテンツは成人向けですので、18歳未満の者が閲覧することを禁止します。");
				if (adult) {
					document.cookie = cookieStr;
				} else {
					document.location.href = "https://google.com/";
					return;
				}
			}
		}

		novel.loadFromJson(e.target.responseText);

		let config = novel.config;
		player.title = document.getElementById("maiNovelTitle");
		player.title.innerText = config.title;
		document.getElementById("maiNovelCredit").innerHTML = config.credit;

		player.cover = document.getElementById("maiNovelCover");
		if (player.cover.src.length == 0) {
			let sCode = novel.formatSceneCode(0);
			let iFmt = config.imageFormat;
			player.cover.src = `${iFmt}/${sCode}/${sCode}${novel.formatMessageCode(0)}.${iFmt}`;
		}

		player.imageArea = document.getElementById("maiNovelImageArea");
		player.imageArea.onclick = function () { play(); }

		player.textArea = document.getElementById("maiNovelTextArea");
		player.textArea.innerHTML = `『${novel.config.title}』<br>・音がでます。<br>・画像タッチで進みます。`;

		document.getElementById("maiNovelStop").onclick = function () { stop(); };

		document.getElementById("maiNovelAutoPlaySelector").onchange = function (e) {
			player.autoPlay = e.target.checked;
		};

		document.getElementById("maiNovelLoopModeSelector").onchange = function (e) {
			player.loopMode = e.target.value;
		};

		document.getElementById("maiNovelPlaySpeedSelector").onchange = function (e) {
			player.playSpeed = parseFloat(e.target.value);
			if (player.playMessage != null) {
				player.playMessage.audio.playbackRate = player.playSpeed;
			}
		};

		document.getElementById("maiNovelVolumeSelector").onchange = function (e) {
			player.volume = parseFloat(e.target.value);
			if (player.playMessage != null) {
				player.playMessage.audio.volume = player.volume;
			}
		};

		document.getElementById("maiNovelZoom").onclick = function () {
			if (player.imageArea.className == "zoom") {
				player.imageArea.className = "";
				player.textArea.className = "";
			} else {
				player.imageArea.className = "zoom";
				player.textArea.className = "zoom";
			}
		};

		player.sceneSelector = document.getElementById("maiNovelSceneSelector");
		player.sceneSelector.innerHTML += `<option value="0">${config.title}</option>`;
		for (let si = 0; si < novel.scenes.length; si++) {
			let scene = novel.scenes[si];
			player.sceneSelector.innerHTML +=
				`<option value="${scene.index}">${scene.index + 1} ${scene.name}</option>`;
			preload(scene.messages[0]);
		}

		let startSceneIndex = 0;
		if (document.location.search.length > 0) {
			let params = new URLSearchParams(document.location.search);
			let sceneIndex = parseInt(params.get("s"));
			if ((sceneIndex >= 0) && (sceneIndex < novel.scenes.length)) {
				startSceneIndex = sceneIndex;
			}
		}
		preload(novel.scenes[startSceneIndex].messages[0]);

		player.sceneSelector.onchange = function (e) {
			let message = novel.scenes[parseInt(e.target.value)].messages[0];
			if (player.playMessage != message) {
				preload(message);
				play();
			}
		};

		document.onkeydown = function (e) {
			if (e.code == "Enter" || e.code == "Space") { play(); }
			if (e.code == "Escape") { stop(); }
		};
	};

	let preload = function (message) {
		if (typeof message.audio == "undefined") {
			message.image = new Image();
			message.imageLoaded = false;
			message.image.onload = function (e) { message.imageLoaded = true; }
			message.image.src = message.imagePath;
			message.audio = new Audio(message.audioPath);
			message.audioLoaded = false;
			message.audio.oncanplaythrough = function () { message.audioLoaded = true; };

			message.audio.onended = function () {
				if (!player.autoPlay) { return; }
				if ((player.loopMode == "None") && (message.next.name == "s00m00")) { return; }
				if ((player.loopMode == "Scene") && (message.next.index == 0)) {
					preload(message.scene.messages[0]);
				}

				let timeout = function () {
					if (!play()) { player.timeoutId = setTimeout(timeout, 200); }
				};
				player.timeoutId = setTimeout(timeout,
					(player.playMessage.audioInterval / player.playSpeed));
			};
		}
		player.preLoadMessage = message;
	};

	let play = function () {
		if (!player.preLoadMessage.audioLoaded) { return false; }

		if (player.timeoutId != null) {
			clearTimeout(player.timeoutId);
			player.timeoutId = null;
		}

		if (player.playMessage != null) {
			player.playMessage.audio.pause();
			player.playMessage.audio.currentTime = 0;
		}

		let message = player.preLoadMessage;
		message.audio.playbackRate = player.playSpeed;
		message.audio.currentTime = 0;
		message.audio.volume = player.volume;
		message.audio.play();

		player.textArea.innerHTML = `${message.insertHTML}${message.text}`;

		if (message.imageLoaded) {
			player.imageArea.removeChild(player.imageArea.children[0]);
			player.imageArea.appendChild(message.image);
		}

		player.playMessage = message;
		if ((player.loopMode == "Scene") && (message.next.index == 0)) {
			preload(message.scene.messages[0]);
		} else {
			preload(message.next);
		}

		if (message.index == 0) {
			player.title.innerText = `${novel.config.title} - ${message.scene.name}`;
		}
		return true;
	};

	let stop = function () {
		if (player.playMessage != null) {
			player.playMessage.audio.pause();
			player.playMessage.audio.currentTime = 0;
			preload(player.playMessage);
		}
		if (player.timeoutId != null) {
			clearTimeout(player.timeoutId);
			player.timeoutId = null;
		}
	};

	window.onload = function () {
		// スマホアドレスバー対策
		novelElem = document.getElementById("maiNovel");
		if (novelElem.offsetHeight != window.innerHeight) {
			novelElem.style.height = `${window.innerHeight}px`;
		}

		let xhr = new XMLHttpRequest();
		xhr.open("GET", player.jsonFilePath);
		xhr.onload = onJsonLoaded;
		xhr.send();
	};
})();

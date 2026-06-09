(function () {
	function getGreeting() {
		const hour = new Date().getHours();
		if (hour < 12) return "Good morning";
		if (hour < 17) return "Good afternoon";
		return "Good evening";
	}

	function addHeroBanner() {
		if (document.getElementById("hl118-hero")) return;

		const main = document.querySelector("main");
		if (!main) return;

		const banner = document.createElement("div");
		banner.id = "hl118-hero";

		const now = new Date();
		const dateText = now.toLocaleDateString("en-IN", {
			weekday: "long",
			month: "short",
			day: "numeric",
		});

		const timeText = now.toLocaleTimeString("en-IN", {
			hour: "2-digit",
			minute: "2-digit",
			hour12: false,
		});

		banner.innerHTML =
			'<div><div class="hl118-title">' +
			getGreeting() +
			', welcome to Homelab 118</div><div class="hl118-subtitle">' +
			dateText +
			'</div></div><div class="hl118-time">' +
			timeText +
			" IST</div>";

		main.prepend(banner);
	}

	function applyStaggerIndices() {
		const cards = document.querySelectorAll("main a[href]");
		cards.forEach(function (card, index) {
			card.style.setProperty("--stagger-index", String(index % 16));
		});
	}

	function refreshEnhancements() {
		addHeroBanner();
		applyStaggerIndices();
	}

	window.addEventListener("load", refreshEnhancements);
	document.addEventListener("visibilitychange", function () {
		if (!document.hidden) refreshEnhancements();
	});

	const observer = new MutationObserver(function () {
		applyStaggerIndices();
	});

	observer.observe(document.documentElement, { childList: true, subtree: true });
})();

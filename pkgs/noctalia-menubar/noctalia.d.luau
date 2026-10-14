-- luau-lsp type definitions for the noctalia plugin API (noctalia 5.2, plugin_api 27),
-- written from noctalia's plugin docs (docs/user/plugins/development). Editor-only: loaded
-- through luau-lsp.types.definitionFiles, not installed with the plugin.

-- ── ui.* ────────────────────────────────────────────────────────────────────

type UiNode = { [string]: any }
-- a callback is a Luau function or the name of a global function in the script
type Callback = string | (...any) -> ...any
type Children = { UiNode? }
type Align = "start" | "center" | "end" | "stretch"
type Justify = "start" | "center" | "end" | "space_between"
type ControlSize = "sm" | "md" | "lg"

-- props every node accepts
type CommonProps = {
	key: string?,
	width: number?,
	height: number?,
	flexGrow: number?,
	opacity: number?,
	visible: boolean?,
}

type FlexProps = CommonProps & {
	gap: number?,
	padding: number?,
	paddingH: number?,
	paddingV: number?,
	align: Align?,
	justify: Justify?,
	-- color role ("primary", "on_surface/0.1") or hex ("#rrggbbaa")
	fill: string?,
	radius: number?,
	border: string?,
	borderWidth: number?,
	minWidth: number?,
	minHeight: number?,
	onClick: Callback?,
	onRightClick: Callback?,
	onHover: Callback?,
	tooltip: string?,
}

type ScrollProps = FlexProps & {
	stickToBottom: boolean?,
	onScroll: Callback?,
	scrollToBottomRev: number?,
}

type LabelProps = CommonProps & {
	text: string?,
	fontSize: number?,
	color: string?,
	fontWeight: ("thin" | "light" | "normal" | "medium" | "semibold" | "bold" | "heavy" | number)?,
	fontFamily: string?,
	baseline: ("text" | "textFixedHeight" | "inkCentered" | "pictographic")?,
	maxWidth: number?,
	maxLines: number?,
	textAlign: ("start" | "center" | "end")?,
}

type MarkdownProps = CommonProps & { text: string? }

type GlyphProps = CommonProps & {
	-- Tabler or Nerd Font glyph name
	name: string,
	size: number?,
	color: string?,
}

type ImageProps = CommonProps & {
	-- plugin-relative, ~ or absolute
	path: string,
	radius: number?,
	fit: ("contain" | "cover" | "stretch")?,
	border: string?,
	borderWidth: number?,
	onClick: Callback?,
	onHover: Callback?,
	tooltip: string?,
}

type BoxProps = CommonProps & {
	fill: string?,
	radius: number?,
	border: string?,
	borderWidth: number?,
	softness: number?,
	onClick: Callback?,
	onHover: Callback?,
	tooltip: string?,
}

type SeparatorProps = CommonProps & {
	thickness: number?,
	color: string?,
	spacing: number?,
	orientation: ("auto" | "horizontal" | "vertical")?,
}

type ProgressProps = CommonProps & {
	-- 0 to 1
	progress: number?,
	fill: string?,
	track: string?,
	radius: number?,
}

type ButtonProps = CommonProps & {
	text: string?,
	glyph: string?,
	fontSize: number?,
	glyphSize: number?,
	variant: ("default" | "primary" | "secondary" | "destructive" | "outline" | "ghost")?,
	contentAlign: ("start" | "center" | "end")?,
	controlSize: ControlSize?,
	tooltip: string?,
	enabled: boolean?,
	selected: boolean?,
	onClick: Callback?,
	onRightClick: Callback?,
	onHover: Callback?,
}

type GraphProps = CommonProps & {
	-- 0 to 1
	values: { number }?,
	values2: { number }?,
	color: string?,
	color2: string?,
	lineWidth: number?,
	fillOpacity: number?,
	onPointerMove: Callback?,
	onPointerLeave: Callback?,
}

type ToggleProps = CommonProps & {
	checked: boolean?,
	enabled: boolean?,
	onChange: Callback?,
}

type SliderProps = CommonProps & {
	min: number?,
	max: number?,
	step: number?,
	value: number?,
	controlSize: ControlSize?,
	enabled: boolean?,
	onChange: Callback?,
	onDragEnd: Callback?,
}

type SelectProps = CommonProps & {
	options: { string }?,
	selectedIndex: number?,
	placeholder: string?,
	controlSize: ControlSize?,
	enabled: boolean?,
	onChange: Callback?,
}

type InputProps = CommonProps & {
	-- initial text only; change the node's key to reset it
	value: string?,
	placeholder: string?,
	fontSize: number?,
	controlSize: ControlSize?,
	password: boolean?,
	multiline: boolean?,
	submitOnEnter: boolean?,
	frameVisible: boolean?,
	focus: boolean?,
	enabled: boolean?,
	onChange: Callback?,
	onSubmit: Callback?,
}

type DragSourceProps = CommonProps & {
	dragType: string,
	payload: string,
	enabled: boolean?,
	tooltip: string?,
	previewAncestor: number?,
}

type DropZoneProps = CommonProps & {
	accepts: { string },
	value: string,
	onDrop: Callback,
	direction: ("column" | "row")?,
	enabled: boolean?,
	expandOnDrag: boolean?,
	minHeight: number?,
	hitSlop: number?,
}

declare ui: {
	row: (props: FlexProps?, children: Children?) -> UiNode,
	column: (props: FlexProps?, children: Children?) -> UiNode,
	scroll: (props: ScrollProps?, children: Children?) -> UiNode,
	label: (props: LabelProps) -> UiNode,
	markdown: (props: MarkdownProps) -> UiNode,
	glyph: (props: GlyphProps) -> UiNode,
	image: (props: ImageProps) -> UiNode,
	box: (props: BoxProps?) -> UiNode,
	separator: (props: SeparatorProps?) -> UiNode,
	spacer: (props: CommonProps?) -> UiNode,
	progress: (props: ProgressProps?) -> UiNode,
	button: (props: ButtonProps) -> UiNode,
	graph: (props: GraphProps) -> UiNode,
	toggle: (props: ToggleProps?) -> UiNode,
	slider: (props: SliderProps?) -> UiNode,
	select: (props: SelectProps?) -> UiNode,
	input: (props: InputProps?) -> UiNode,
	dragSource: (props: DragSourceProps, children: Children?) -> UiNode,
	dropZone: (props: DropZoneProps, children: Children?) -> UiNode,
}

-- ── entries ─────────────────────────────────────────────────────────────────

-- bar widget entries ([[widget]])
declare barWidget: {
	render: (tree: UiNode) -> (),
	setText: (text: string) -> (),
	setTooltip: (content: any) -> (),
	clearTooltip: () -> (),
	setVisible: (visible: boolean) -> (),
	setGlyph: (name: string) -> (),
	setGlyphColor: (color: string, mode: string?) -> (),
	setColor: (color: string, mode: string?) -> (),
	setFont: (family: string, baseline: string?) -> (),
	setImage: (path: string, watch: boolean?, width: number?, height: number?) -> (),
	isVertical: () -> boolean,
	outputName: () -> string?,
}

-- panel entries ([[panel]])
declare panel: {
	render: (tree: UiNode) -> (),
	close: () -> (),
	openContextMenu: (request: { [string]: any }) -> (),
	setNeedsFrameTick: (enabled: boolean) -> (),
}

-- ── noctalia.* ──────────────────────────────────────────────────────────────

type RunResult = {
	stdout: string,
	stderr: string,
	exitCode: number,
}

type HttpResponse = { [string]: any }

declare noctalia: {
	-- processes
	runAsync: (command: string | { string }, callback: ((result: RunResult) -> ())?) -> (),
	-- a command line only: an argv list fails with "string expected, got table"
	runStream: (command: string, onLine: (line: string) -> ()) -> any,
	runInTerminal: (command: string) -> (),
	commandExists: (name: string) -> boolean,
	processMatches: (callback: (matches: boolean) -> (), ...string) -> (),
	flatpakAppInstalled: (id: string) -> boolean,

	-- files
	pluginDir: () -> string,
	pluginDataDir: () -> string,
	expandPath: (path: string) -> string,
	readFile: (path: string) -> string?,
	readFileAsync: (path: string, callback: (content: string?) -> ()) -> (),
	writeFile: (path: string, content: string) -> boolean,
	fileExists: (path: string) -> boolean,
	fileInfo: (path: string) -> { [string]: any }?,
	listDir: (path: string) -> { string }?,
	mkdirAll: (path: string) -> boolean,
	removeFile: (path: string) -> boolean,
	renameFile: (from: string, to: string) -> boolean,
	loadFont: (path: string) -> string?,

	-- network
	http: (request: { [string]: any }, callback: (response: HttpResponse) -> ()) -> (),
	httpStream: (request: { [string]: any }, onLine: (line: string) -> (), onClose: ((response: HttpResponse) -> ())?) -> any,
	download: (url: string, dest: string, callback: (ok: boolean, error: string?) -> ()) -> (),

	-- shell
	togglePanel: (id: string, context: string?) -> (),
	openSettings: () -> (),
	notify: (title: string, body: string?) -> (),
	notifyError: (title: string, body: string?) -> (),
	log: (message: any) -> (),
	getenv: (name: string) -> string?,
	getSetting: (path: string) -> any,
	getConfig: (key: string?) -> any,
	getColor: (role: string) -> string,
	isDarkMode: () -> boolean,
	appIconPath: (appId: string, sizePx: number?) -> string?,
	fuzzyScore: (pattern: string, text: string) -> number?,
	copyToClipboard: (text: string, mime: string?) -> (),
	clipboardText: () -> string?,
	openColorPicker: (initialColor: string?, onClose: (color: string?) -> ()) -> (),
	portalAvailable: () -> boolean,
	setUpdateInterval: (ms: number) -> (),
	focusedOutputName: () -> string?,
	outputs: () -> { { [string]: any } },

	-- time and translation
	nowMs: () -> number,
	formatTime: (pattern: string, unixSeconds: number?, timezone: string?) -> string,
	isValidTimezone: (name: string) -> boolean,
	timeFormat: () -> string,
	dateFormat: () -> string,
	tr: (key: string, subst: { [string]: any }?) -> string,
	trp: (key: string, count: number, subst: { [string]: any }?) -> string,

	-- system
	cpuCores: () -> number,
	systemStats: () -> { [string]: any },
	diskMounts: () -> { { [string]: any } },
	diskStats: (path: string) -> { [string]: any }?,

	-- wallpaper
	wallpaperDirectory: () -> string?,
	wallpaperPath: (connector: string?) -> string?,
	setWallpaper: (...any) -> (),
	setWallpaperEnabled: (connector: string, enabled: boolean) -> (),
	setWallpaperMask: (connector: string, mask: { path: string, wallpaperPath: string }?) -> (),

	-- shared between a plugin's entries
	state: {
		get: (key: string) -> any,
		set: (key: string, value: any) -> (),
		watch: (key: string, callback: (value: any) -> ()) -> (),
	},
	json: {
		decode: (text: string) -> any,
		encode: (value: any, pretty: boolean?) -> string,
	},
	string: {
		trim: (text: string) -> string,
		urlEncode: (text: string) -> string,
		urlDecode: (text: string) -> string,
	},
	sound: {
		load: (name: string, path: string, onLoaded: ((ok: boolean, error: string?) -> ())?) -> (),
		play: (name: string) -> (),
	},
}

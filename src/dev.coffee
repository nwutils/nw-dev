
window.CRASHED = false

if process?
	nwgui = window.require "nw.gui"
	nwwin = nwgui.Window.get window
	
	# Get rid of the shitty broken error handler
	process.removeAllListeners "uncaughtException"
	# stupid clouds
	
	# Add our own handler
	process.on "uncaughtException", (e)->
		console?.warn? "CRASH" unless window.CRASHED
		window.CRASHED = true
		nwwin.showDevTools() unless nwwin.isDevToolsOpen()
		nwwin.show() if nwgui.App.manifest.window?.show is false
	
	# Show developer tools with F12
	window.addEventListener "keydown", (e)->
		if e.keyCode is 123 # F12
			if nwwin.isDevToolsOpen()
				nwwin.closeDevTools()
			else
				nwwin.showDevTools()
	
	# Live reload
	try
		chokidar = window.require "nw-dev/node_modules/chokidar/"
	catch e
		console.warn "Live reload disabled:", e.stack
	
	if chokidar
		watcher = chokidar.watch ".", ignored: /node_modules|\.git/
		# @TODO: watch linked dependencies and bundled dependencies
		watcher.on "change", (path)->
			watcher.close()
			
			# this could theoretically cause issues in very obscure cases
			# where caching behavior is relied upon in a separate page/context
			for own k of global.require.cache
				delete global.require.cache[k]
			# very obscure cases
			# overall, it's very helpful
			
			nwwin.closeDevTools()
			
			if path is "package.json"
				fs = require "fs"
				pkg = JSON.parse fs.readFileSync "package.json", "utf8"
				
				# override the getter
				Object.defineProperty nwgui.App,
					"manifest"
					value: pkg
					configurable: yes # so it'll work a second time
				
				{x, y} = nwwin
				width = window.innerWidth
				height = window.innerHeight
				window.close()
				newwin_options = {}
				newwin_options[k] = v for k, v of pkg.window
				newwin_options[k] = v for k, v of {x, y, width, height}
				newwin = nwgui.Window.open window.location.href, newwin_options
				# @TODO: handle zoomLevel and other window state?
				# like https://github.com/azu/node-webkit-winstate
				# actually, you should just use that library
			else
				location?.reload()

window.onerror = (e)->
	console?.warn? "CRASH" unless window.CRASHED
	window.CRASHED = true
	console?.error? "Got exception:", e

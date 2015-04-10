
window.CRASHED = false

if process?
	nwgui = window.require 'nw.gui'
	nwwin = nwgui.Window.get window
	
	# Get rid of the shitty broken error handler
	process.removeAllListeners "uncaughtException"
	
	# Add our own handler
	process.on "uncaughtException", (e)->
		console?.warn? "CRASH" unless window.CRASHED
		window.CRASHED = true
		nwwin.showDevTools() unless nwwin.isDevToolsOpen()
		nwwin.show() if nwgui.App.manifest.window?.show is false
	
	# Live reload
	try
		chokidar = require "chokidar"
		watcher = chokidar.watch ".", ignored: /node_modules|\.git/
		watcher.on "change", (path)->
			watcher.close()
			
			# this could theoretically cause issues in obscure cases
			# where the cache is relied upon in a separate page/context
			for own k of global.require.cache
				delete global.require.cache[k]
			
			nwwin.closeDevTools()
			location?.reload()
	catch e
		console.warn "Live reload disabled:", e.stack
	
	window.addEventListener "keydown", (e)->
		if e.keyCode is 123 # F12
			if nwwin.isDevToolsOpen()
				nwwin.closeDevTools()
			else
				nwwin.showDevTools()

window.onerror = (e)->
	console?.warn? "CRASH" unless window.CRASHED
	window.CRASHED = true
	console?.error? "Got exception:", e

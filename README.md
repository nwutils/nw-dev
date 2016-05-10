
# nw-dev

A drop-in library for [nw.js][] development

* Live-reloads upon save

* Reloads when you press <kbd>F5</kbd>

* Opens the devtools when you press <kbd>F12</kbd> (`nw@>=0.13.0` does this for you)

* Opens the devtools upon error

* Sets `window.CRASHED` upon error,
  so you can stop an animation loop for example
  (and not flood the console with errors)

* Clears the require cache,
  so reloading works with modules

* When you change `package.json`, it closes and reopens the window
  with the new values, so you don't even have to restart
  to change things like `window.frame`
  (not working in latest nw.js)

* When loaded in a browser (non-nw.js),
  it only tries to do error handling


## install

`npm i nw-dev --save-dev`

Put this script before any other scripts
(that you're developing, at least):

```html
<script src="node_modules/nw-dev/lib/dev.js"></script>
```


## exclude some files from being watched

By default `node_modules`, `npm-debug.log`, `.git`, `.hg`, and `.svn` are ignored.

You can ignore additional paths by adding a `data-ignore` attribute to the script:

```html
<script src="node_modules/nw-dev/lib/dev.js" data-ignore="data.json|*.md"></script>
```

The ignore pattern will be passed to [chokidar][] and interpreted by [micromatch][].


## don't annoyingly assert window focus when reloading

(This can be especially annoying if your editor autosaves!)

You may have your app set up to show itself once it finishes loading.

That's a good thing, but if you're calling `win.show()`,
it can inadvertently focus the window.

Do this (with JavaScript):

```js
if(!win.shown){
    win.show();
    win.shown = true;
}
```

Or this (with CoffeeScript):

```coffee
win.show() unless win.shown
win.shown = yes
```

(Now autosaving can once again be beneficial!)


## develop nw-dev

* `npm i`

* `npm link`, and `npm link nw-dev` from an nw.js project

* `npm run prepublish` to recompile

[nw.js]: https://github.com/nwjs/nw.js
[chokidar]: https://github.com/paulmillr/chokidar
[micromatch]: https://github.com/jonschlinkert/micromatch

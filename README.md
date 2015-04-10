
# nw-dev

A drop-in library for [nw.js](https://github.com/nwjs/nw.js) development

* Live-reloads upon save

* Opens devtools when you press <kbd>F12</kbd>

* Opens devtools upon error

* Sets `window.CRASHED` upon error,
  so you can stop an animation loop for example
  and only get one error

* Clears require cache,
  so reloading works with modules

* When loaded in a browser (non-nw.js),
  it only tries to do error handling


## install nw-dev

`npm i nw-dev --save-dev`

Put this script before any other scripts
(that you're developing, at least):

```html
<script src="node_modules/nw-dev/lib/dev.js"></script>
```

Or just download `lib/dev.js` and include it:

```html
<script src="lib/dev.js"></script>
```


## my window annoyingly asserts focus when reloading

(This can be especially annoying if your editor autosaves!)

You probably have your app set up to show itself once it finishes loading.

That's good, but you're calling `win.show()` which focuses the window.

Do this (CoffeeScript):

```coffee
win.show() unless win.shown
win.shown = yes
```

Or this (JavaScript):

```js
if(!win.shown){
    win.show();
    win.shown = true;
}
```

(Now your autosaving workflow is once again beneficial!)


## develop nw-dev

* `npm i`

* `npm link`

* `cd ~/some/other/project`

* `npm link nw-dev`

* `cd ../back/to/nw-dev`

* `npm run prepublish` to recompile


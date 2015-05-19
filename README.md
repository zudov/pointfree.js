# Pointfree.js
     

Pointfree.js converts Haskell expressions between the pointfree and
pointful styles. It is a web front end to the [pointfree](http://hackage.haskell.org/package/pointfree)
and [pointful](http://hackage.haskell.org/package/pointful) libraries that
are compiled into javascript using [GHCJS](https://github.com/ghcjs/ghcjs).

The design and inspiration are shamelessly borrowed from [Blunt](https://blunt.herokuapp.com) by [@tfausak](https://github.com/tfausak).

## Building

You'll need GHCJS and cabal-1.22.

To compile the project initialize a sandbox and run `cabal install`:

```bash
cabal sandbox init
cabal install --ghcjs
```

Makefile will help to produce final html file:

```bash
make build
```

After that you can point your web-browser at `static-build/index.html`.

```bash
firefox static-build/index.html
```



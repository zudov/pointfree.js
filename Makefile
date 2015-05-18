
# ghcjs -Wall -package-db=.cabal-sandbox/x86_64-linux-ghcjs-0.1.0-ghc7_10_1-packages.conf.d/ src/Main.hs
build:
	cabal install --ghcjs
	mkdir -p static-build/
	cp -t static-build/ static/{index.html,style.css}
	cp -t static-build/ .cabal-sandbox/bin/pointfree-js.jsexe/all.js 

minify: build
	ccjs .cabal-sandbox/bin/pointfree-js.jsexe/all.js > static-build/all.js
	du -h static-build/all.js
	gzip static-build/all.js -c > /tmp/all.js.gz && du -h /tmp/all.js.gz && rm /tmp/all.js.gz

clean:
	cabal clean
	rm -rf static-build/

develop:
	while true; do \
		inotifywait -e close_write,moved_to,create src/; \
		ghcjs -Wall -outputdir /tmp -o static-build/scripts -package-db=.cabal-sandbox/x86_64-linux-ghcjs-0.1.0-ghc7_10_1-packages.conf.d/ src/Main.hs; \
		cp -t static-build/ static-build/scripts.jsexe/all.js; \
	done

GITHUB_REPO ?= zudov/pointfree.js

deploy: minify
	cd static-build/ && \
	  git init . && \
	  git add . && \
	  git commit -m "Updated deployment"; \
	  git push "https://github.com/$(GITHUB_REPO).git" master:gh-pages --force && \
	  rm -rf .git

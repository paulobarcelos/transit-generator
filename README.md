# transit-generator

A web-component element that renders the simulation used to generate branding graphics for Transit.


## Dependencies

Element dependencies are managed via [Bower](http://bower.io/). You can
install that via:

    npm install -g bower

Then, go ahead and download the element's dependencies:

    bower install

## Optimizing shader
In order to optmize the `frag.source.glsl` shader (so it runs smoothly on older machines) use the [GLSL Optimizer](https://github.com/aras-p/glsl-optimizer).
It will generate the `frag.optmized.glsl` shader.

There is a big change that your browser will comply it cannot compile the shader (due to the way the optimizer works, like optmizing for loops for example). If that happens check the errors on console and fix the errors manually (like adjusting the statements of the loops).

```
# Run from this directory
sh optimize-shader.sh
```


## Playing With Your Element

If you wish to work on your element in isolation, we recommend that you use
[Polyserve](https://github.com/PolymerLabs/polyserve) to keep your element's
bower dependencies in line. You can install it via:

    npm install -g polyserve

And you can run it via:

    polyserve

Once running, you can preview your element at
`http://localhost:8080/components/transit-generator/`, where `transit-generator` is the name of the directory containing it.


## Testing Your Element

Simply navigate to the `/test` directory of your element to run its tests. If
you are using Polyserve: `http://localhost:8080/components/transit-generator/test/`

### web-component-tester

The tests are compatible with [web-component-tester](https://github.com/Polymer/web-component-tester).
Install it via:

    npm install -g web-component-tester

Then, you can run your tests on _all_ of your local browsers via:

    wct

#### WCT Tips

`wct -l chrome` will only run tests in chrome.

`wct -p` will keep the browsers alive after test runs (refresh to re-run).

`wct test/some-file.html` will test only the files you specify.


## Yeoman support

If you'd like to use Yeoman to scaffold your element that's possible. The official [`generator-polymer`](https://github.com/yeoman/generator-polymer) generator has a [`seed`](https://github.com/yeoman/generator-polymer#seed) subgenerator.

const { serveHTTP, publishToCentral } = require("stremio-addon-sdk")

const Server = dependencies => {
    const {
        builder
    } = dependencies

    const serve = ({ port }) => {
        serveHTTP(builder.getInterface(), { port })
    }

    return {
        serve
    }
}

module.exports = Server

// const addonInterface = require("./addon")

// serveHTTP(addonInterface, { port: 60086 })

// when you've deployed your addon, un-comment this line
// publishToCentral("https://my-addon.awesome/manifest.json")
// for more information on deploying, see: https://github.com/Stremio/stremio-addon-sdk/blob/master/docs/deploying/README.md

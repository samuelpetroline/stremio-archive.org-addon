const { serveHTTP } = require("stremio-addon-sdk")

const Server = builder => {

    const serve = ({ port }) => {
        serveHTTP(builder.getInterface(), { port })
    }

    return {
        serve
    }
}

module.exports = Server
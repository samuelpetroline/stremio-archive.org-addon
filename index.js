'use strict';

const axios = require('axios')

const builder = require('./addon')
const server = require('./server')
const useCases = require('./use-cases')
const handlers = require('./handlers')

const { env } = require('./config')
const { queryBuilder, transformModel, validate, parseTorrent } = require('./commons')

const {
    searchCatalog,
    getMeta,
    getStreams
} = handlers({
    env,
    ...transformModel({ env, parseTorrent }),
    ...validate({ env }),
    ...useCases({
        httpClient: axios,
        queryBuilder,
        env
    })
})

const addon = builder({ env })

addon.defineCatalogHandler(searchCatalog)
addon.defineMetaHandler(getMeta)
addon.defineStreamHandler(getStreams)

server(addon).serve({
    port: 60086
})
'use strict';

const axios = require('axios')

const builder = require('./addon')
const server = require('./server')
const useCases = require('./use-cases')
const handlers = require('./handlers')
const use = require('./pipeline')

const { env } = require('./config')
const { queryBuilder, transformModel, validate } = require('./commons')

const { validateContentType, validateRequest} = validate({ env })

const {
    searchCatalog,
    getMeta,
    getStreams
} = handlers({
    env,
    ...transformModel({ env }),
    ...useCases({
        httpClient: axios,
        queryBuilder,
        env
    })
})

const addon = builder({ env })

addon.defineCatalogHandler(use(validateContentType, searchCatalog))
addon.defineMetaHandler(use(validateContentType, validateRequest, getMeta))
addon.defineStreamHandler(use(validateContentType, validateRequest, getStreams))

server(addon).serve({
    port: 60086
})
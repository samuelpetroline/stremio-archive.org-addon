'use strict';

const axios = require('axios')

const builder = require('./addon')
const server = require('./server')
const useCases = require('./use-cases')
const handlers = require('./handlers')

const { env } = require('./config')
const { queryBuilder } = require('./commons')

const {
    searchCatalog,
    getMeta
} = handlers({
    ...useCases({
        httpClient: axios,
        queryBuilder,
        env
    })
})

builder.defineCatalogHandler(searchCatalog)
builder.defineMetaHandler(getMeta)

server(builder).serve({
    port: 60086
})
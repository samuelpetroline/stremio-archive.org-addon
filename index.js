const axios = require('axios')

const builder = require('./addon')
const server = require('./server')
const useCases = require('./use-cases')
const handlers = require('./handlers')

const {
    searchCatalog,
    getMeta // TODO
} = handlers({
    httpClient: axios,
    ...useCases
})

builder.defineCatalogHandler(searchCatalog)
builder.defineMetaHandler(searchCatalog)

server({ builder }).serve({
    port: 60086
})
const searchCatalog = require('./search-catalog')
const getMeta = require('./get-meta')
const getStreams = require('./get-streams')

module.exports = dependencies => {
    return {
        searchCatalog: searchCatalog(dependencies),
        getMeta: getMeta(dependencies),
        getStreams: getStreams(dependencies)
    }
}
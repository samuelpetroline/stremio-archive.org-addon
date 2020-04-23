const searchCatalog = require('./search-catalog')

module.exports = dependencies => ({
    searchCatalog: searchCatalog(dependencies)
})
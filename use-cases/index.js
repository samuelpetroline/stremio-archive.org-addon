const Catalog = require('./catalog')

module.exports = dependencies => ({
    ...Catalog({
        ...dependencies
    })
})
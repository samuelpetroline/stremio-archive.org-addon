const generator = require('lucene-query-generator')

module.exports = (args) => {
    return generator.convert({
        $operands: [ args ]
    })
}
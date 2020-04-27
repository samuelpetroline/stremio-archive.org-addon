module.exports = dependencies => {
    const {
        env
    } = dependencies

    const toCatalog = (item) => {
        return {
            id: item.identifier,
            type: 'movie',
            name: item.title,
            poster: `${env.url.image}/${item.identifier}`,
            description: item.description
        }
    }

    const toMeta = (item) => {

    }

    return {
        toCatalog,
        toMeta
    }
}
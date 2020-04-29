module.exports = dependencies => {
    const {
        env
    } = dependencies

    const toCatalog = (item) => {
        return {
            id: `${env.addonContentIdPrefix}${item.identifier}`,
            type: 'movie',
            name: item.title,
            poster: `${env.url.image}/${item.identifier}`,
            description: item.description
        }
    }

    const toMeta = (item) => {
        return {
            id: item.identifier,
            type: 'movie',
            name: item.title,
            description: item.description,
            language: item.language,
            genres: item.genre ? item.genre.split(',') : undefined,
            director: item.director ? item.director.split(',') : undefined
        }
    }

    return {
        toCatalog,
        toMeta
    }
}
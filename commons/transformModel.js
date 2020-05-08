module.exports = dependencies => {
    const {
        env,
        parseTorrent
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

    const isTorrent = file => file.indexOf('.torrent') !== -1

    //https://archive.org/download/boys_of_the_city/boys_of_the_city_512kb.mp4
    const toStream = async (item) => {
        const url = `${env.url.stream}/${item.id}/${item.name}`

        return {
            url,
            infoHash: isTorrent(item.name) ? await parseTorrent(url) : undefined
        }
    }

    return {
        toCatalog,
        toMeta,
        toStream
    }
}
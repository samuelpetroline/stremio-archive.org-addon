const Stream = dependencies => {
    const {
        httpClient,
        env
    } = dependencies

    const getStreams = async (request) => {
        const {
            id
        } = request

        try {
            const response = await httpClient.get(`${env.url.metadata}/${id}/files`)

            return filterStreams(response.data)
        } catch (error) {
            throw error
        }
    }

    const extensionList = ['.torrent', '.mp4']
    // Returns only streams supported by Stremio
    const filterStreams = (streams) => {
        return streams
            .filter(stream => Boolean(extensionList.filter(ext => stream.name.indexOf(ext) !== -1)))
    }

    return {
        getStreams
    }

}

module.exports = Stream
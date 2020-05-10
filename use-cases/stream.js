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

             return extractStreams({ id, result: response.data.result })
        } catch (error) {
            throw error
        }
    }

    // Returns only streams supported by Stremio
    const extractStreams = ({ id, result }) => {
        const streams = []
        const subtitles = []

        for (const file of result) {
            if (Boolean(file.name.match((`${id}(.*)(.mp4|.torrent)`)))) {
                streams.push(file)
            }

            if (Boolean(file.name.match((`${id}(.*)(.srt)`)))) {
                subtitles.push(file)
            }
        }

        return {
            streams,
            subtitles
        }
    }

    return {
        getStreams
    }

}

module.exports = Stream
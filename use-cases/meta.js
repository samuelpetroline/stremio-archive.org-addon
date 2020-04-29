const Meta = dependencies => {
    const {
        httpClient,
        env
    } = dependencies

    const getMeta = async (request) => {
        const {
            id
        } = request

        try {
            const response = await httpClient.get(`${env.url.metadata}/${id}`)

            return response.data.metadata
        } catch (error) {
            throw error
        }
    }

    return {
        getMeta
    }

}

module.exports = Meta
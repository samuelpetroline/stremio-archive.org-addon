module.exports = dependencies => {
    const {
        getStream,
        toStream,
        env
    } = dependencies

    return async (args) => {
        if (args.type === 'movie' && args.id.indexOf(env.addonContentIdPrefix) !== -1) {
            const id = args.id.replace(env.addonContentIdPrefix, '')
            const streams = await getStream({ id })

            return {
                streams: streams.map((stream) => toStream({
                    id,
                    ...stream
                }))
            }
        }

        return Promise.resolve({ streams: [] })
    }
}
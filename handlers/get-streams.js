module.exports = dependencies => {
    const {
        getStream,
        toStream,
        validateRequest,
        validateContentType,
        env
    } = dependencies

    return async (args) => {
        try {
            validateRequest(args)
            validateContentType(args)

            const id = args.id.replace(env.addonContentIdPrefix, '')
            const streams = await getStream({ id })

            return {
                streams: streams.map((stream) => toStream({
                    id,
                    ...stream
                }))
            }
        } catch (error) {
            return Promise.resolve({ streams: [] })
        }

    }
}
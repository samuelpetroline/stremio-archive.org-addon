module.exports = dependencies => {
    const {
        env
    } = dependencies

    const validateRequest = async (args) => {
        if (args.id.indexOf(env.addonContentIdPrefix) !== -1)
            return args

        throw new Error('invalid id')
    }

    const validateContentType = async (args) => {
        if (args.type === 'movie')
            return args

        throw new Error('invalid content type')
    }

    return {
        validateRequest,
        validateContentType
    }
}
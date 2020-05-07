const _pipe = async (a, b) => async (arg) => b(await a(arg));

module.exports = (...ops) => {
    return async () => {
        return ops.reduce(_pipe)
    }
}
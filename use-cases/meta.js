const Meta = (dependencies) => {
  const { httpClient, env } = dependencies

  const getMeta = async (request) => {
    const { id } = request

    const response = await httpClient.get(`${env.url.metadata}/${id}`)

    return response.data.metadata
  }

  return {
    getMeta,
  }
}

module.exports = Meta

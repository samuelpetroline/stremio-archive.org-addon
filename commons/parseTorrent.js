const parse = require('parse-torrent')

module.exports = () => {
  const parseTorrent = (link) => {
    return new Promise((resolve, reject) => {
      parse.remote(link, (error, torrentInfo) => {
        if (error) return reject(error)

        if (!torrentInfo.files) return resolve(undefined)

        const fileIdx = torrentInfo.files.findIndex((file) =>
          file.name.includes('.mp4')
        )

        resolve(fileIdx === -1 ? undefined : fileIdx)
      })
    })
  }

  return {
    parseTorrent,
  }
}

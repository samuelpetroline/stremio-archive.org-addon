const parse = require('parse-torrent')

module.exports = () => {

    const parseTorrent = (link) => {
        return new Promise((resolve, reject) => {
            parse.remote(link, (error, torrentHash) => {
                if (error)
                    return reject(error)

                resolve(torrentHash)
            })
        })
    }

    return {
        parseTorrent
    }
}
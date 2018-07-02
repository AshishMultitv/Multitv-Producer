struct Preference {
    static var defaultInstance: Preference = Preference()

    var uri: String? = "rtmp://live.belive.mobi:80/belive"
    var streamName: String? = AppData.Stremname
}

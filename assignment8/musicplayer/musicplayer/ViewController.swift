import UIKit
import AVFoundation

struct Track {
    let title: String
    let artist: String
    let fileName: String   // имя mp3 без .mp3
    let coverName: String  // имя картинки в Assets
}

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!

    private let tracks: [Track] = [
        Track(title: "8 миля", artist: "madk1d", fileName: "song1", coverName: "cover1"),
        Track(title: "fireman", artist: "Miagy", fileName: "song2", coverName: "cover2"),
        Track(title: "Minor", artist: "Miagy", fileName: "song3", coverName: "cover3"),
        Track(title: "Там ревели горы", artist: "Miagy", fileName: "song2", coverName: "cover4"),
        Track(title: "Kosandra", artist: "Miagy", fileName: "song1", coverName: "cover5"),
        Track(title: "Папа", artist: "2Hug", fileName: "song2", coverName: "cover6"),
        Track(title: "Влюблен", artist: "2Hug", fileName: "song1", coverName: "cover7"),
        Track(title: "Сансара", artist: "Баста", fileName: "song2", coverName: "cover8"),
        Track(title: "Моя игра", artist: "Баста", fileName: "song1", coverName: "cover9"),
        Track(title: "Скандал", artist: "T-Fest и Баста", fileName: "song2", coverName: "cover10"),
    ]

    private var currentIndex = 0
    private var player: AVAudioPlayer?
    private var timer: Timer?
    private var isScrubbing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        loadTrack(at: 0, autoplay: false)
    }

    deinit { timer?.invalidate() }

    private func loadTrack(at index: Int, autoplay: Bool) {
        currentIndex = index
        let track = tracks[index]
        titleLabel.text = track.title
        artistLabel.text = track.artist
        coverImageView.image = UIImage(named: track.coverName)

        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3") else {
            print("Нет файла \(track.fileName).mp3 — проверь Target Membership")
            return
        }
        player?.stop()
        player = try? AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.prepareToPlay()

        let duration = player?.duration ?? 0
        progressSlider.maximumValue = Float(duration)
        progressSlider.value = 0
        currentTimeLabel.text = format(0)
        durationLabel.text = format(duration)

        if autoplay { play() } else { pause() }
    }

    private func play() {
        player?.play()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            guard let self, let player = self.player, !self.isScrubbing else { return }
            self.progressSlider.value = Float(player.currentTime)
            self.currentTimeLabel.text = self.format(player.currentTime)
        }
        updatePlayButton()
    }

    private func pause() {
        player?.pause()
        timer?.invalidate()
        updatePlayButton()
    }

    @IBAction func playPauseTapped(_ sender: UIButton) {
        player?.isPlaying == true ? pause() : play()
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        loadTrack(at: (currentIndex + 1) % tracks.count, autoplay: true)
    }

    @IBAction func prevTapped(_ sender: UIButton) {
        if let player, player.currentTime > 3 {
            player.currentTime = 0
        } else {
            loadTrack(at: (currentIndex - 1 + tracks.count) % tracks.count, autoplay: true)
        }
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        isScrubbing = true
        currentTimeLabel.text = format(TimeInterval(sender.value))
    }

    @IBAction func sliderReleased(_ sender: UISlider) {
        player?.currentTime = TimeInterval(sender.value)
        isScrubbing = false
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        loadTrack(at: (currentIndex + 1) % tracks.count, autoplay: true)
    }

    private func updatePlayButton() {
        let name = player?.isPlaying == true ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: name), for: .normal)
    }

    private func format(_ time: TimeInterval) -> String {
        let t = Int(time)
        return String(format: "%d:%02d", t / 60, t % 60)
    }
}

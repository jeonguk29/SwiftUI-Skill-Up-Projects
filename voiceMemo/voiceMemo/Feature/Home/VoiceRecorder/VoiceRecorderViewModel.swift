//
//  VoiceRecorderViewModel.swift
//  voiceMemo
//

import AVFoundation

class VoiceRecorderViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    /*
     NSObject를 채택하는 이유 AVAudioRecorder라는 서비스 객체를 만들고 해당 객체를 뷰에 올려서 사용하기 위해
     ObservableObject를 채택함 음성메모의 재생 끝 지점등 내장 기능을 사용하기 위해 AVAudioPlayerDelegate를 채택
     AVAudioPlayerDelegate는 NSObject프로토콜을 채택하고 있음 내부적으로 이 프로토콜은 coreFoundation 속성을 가진 타입이기에 객체들이 실행되는 런타임시에 런타임 메커니즘이 해당 프로토콜을 기반으로 동작함 그렇기에 AVAudioPlayerDelegate를 채택하여 객체를 구현하기 위해서는 NSObjectPlayer를 채택하거나 NSObject를 상속받아 해당 AVAudioPlayerDelegate가 간접적으로 런타임 메커니즘을 사용할수 있게 만들어야함
     이게 더 간단함 둘다 하지 않는 다면 AVAudioPlayerDelegate에 모든 필수 메서드를 모두 정의 해야지만 사용할 수 있음
     
     */
    @Published var isDisplayRemoveVoiceRecorderAlert: Bool
    @Published var isDisplayAlert: Bool
    @Published var alertMessage: String
    
    /// 음성메모 녹음 관련 프로퍼티
    var audioRecorder: AVAudioRecorder?
    @Published var isRecording: Bool
    
    /// 음성메모 재생 관련 프로퍼티
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool // 재생
    @Published var isPaused: Bool // 대기
    @Published var playedTime: TimeInterval // 얼마나 재생되었는지
    private var progressTimer: Timer? // 얼마나 진행되었는지
    
    /// 음성메모된 파일
    var recordedFiles: [URL] // 로컬로 저장되는 파일타입은 URL 타입임
    /*
     음성 메모를 저장할 때 URL 타입이 사용되는 이유는 파일 시스템에서 파일의 위치를 나타내는 일반적인 방법 중 하나입니다. URL은 파일 시스템의 경로를 나타내는 데 사용되며, iOS 및 macOS에서 파일 시스템을 다루는 데 많이 활용됩니다.

     일반적으로, 음성 메모나 기타 매체를 저장할 때, 해당 파일이 저장된 경로를 추적하고 파일에 액세스하는 것이 중요합니다. 이를 위해 파일 시스템에서 파일의 위치를 나타내는 URL을 사용합니다.

     따라서 음성 메모를 저장할 때, 해당 파일의 URL을 저장하고 추적함으로써 필요할 때 파일에 액세스하거나 조작할 수 있습니다. 이 URL을 사용하면 저장된 음성 메모 파일을 올바르게 식별하고 관리할 수 있습니다.
     */
    
    /// 현재 선택된 음성메모 파일
    @Published var selectedRecoredFile: URL?
    
    init(
        isDisplayRemoveVoiceRecorderAlert: Bool = false,
        isDisplayErrorAlert: Bool = false,
        errorAlertMessage: String = "",
        isRecording: Bool = false,
        isPlaying: Bool = false,
        isPaused: Bool = false,
        playedTime: TimeInterval = 0,
        recordedFiles: [URL] = [],
        selectedRecoredFile: URL? = nil
    ) {
        self.isDisplayRemoveVoiceRecorderAlert = isDisplayRemoveVoiceRecorderAlert
        self.isDisplayAlert = isDisplayErrorAlert
        self.alertMessage = errorAlertMessage
        self.isRecording = isRecording
        self.isPlaying = isPlaying
        self.isPaused = isPaused
        self.playedTime = playedTime
        self.recordedFiles = recordedFiles
        self.selectedRecoredFile = selectedRecoredFile
    }
}

// MARK: - 음성메모 View와 관련된 로직
extension VoiceRecorderViewModel {
    func voiceRecordCellTapped(_ recordedFile: URL) {
        if selectedRecoredFile != recordedFile {
            stopPlaying() // 재생중 다른 파일 누르면 멈춰줘야함 - 재생정지 메서드 호출
            selectedRecoredFile = recordedFile
        }
    }
    
    func removeBtnTapped() {
        setIsDisplayRemoveVoiceRecorderAlert(true)
    }
    
    func removeSelectedVoiceRecord() {
        guard let fileToRemove = selectedRecoredFile,
              let indexToRemove = recordedFiles.firstIndex(of: fileToRemove) else {
            displayAlert(message: "선택된 음성메모 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: fileToRemove) // 로컬에 있는 URL 파일 삭제
            recordedFiles.remove(at: indexToRemove) // 메모리에 올라와 있는 배열 공간에서도 삭제
            selectedRecoredFile = nil
            stopPlaying() // 재생정지 메서드 호출
            displayAlert(message: "선택된 음성메모 파일을 성공적으로 삭제했습니다.")
        } catch {
            displayAlert(message: "선택된 음성메모 파일 삭제 중 오류가 발생했습니다.")
        }
    }
    
    private func setIsDisplayRemoveVoiceRecorderAlert(_ isDisplay: Bool) {
        isDisplayRemoveVoiceRecorderAlert = isDisplay
    }
    
    private func setErrorAlertMessage(_ message: String) {
        alertMessage = message
    }
    
    private func setIsDisplayErrorAlert(_ isDisplay: Bool) {
        isDisplayAlert = isDisplay
    }
    
    // 메시지를 담고 한번에 띄워주기 위한 메서드
    private func displayAlert(message: String) {
        setErrorAlertMessage(message)
        setIsDisplayErrorAlert(true)
    }
}

// MARK: - 음성메모 녹음 관련
extension VoiceRecorderViewModel {
    func recordBtnTapped() {
        selectedRecoredFile = nil // 선택된게 없도록 다시 재생할거니까
        
        if isPlaying {
            stopPlaying() // 재생 정지와
            startRecording() // 녹음 시작 
        } else if isRecording {
            stopRecording() // 녹음 정지
        } else {
            startRecording() // 녹음 시작
        }
    }
    
    /*
     startRecording() 메서드:
     fileURL 생성:

     getDocumentsDirectory() 메서드를 호출하여 음성 메모를 저장할 디렉토리의 URL을 가져옵니다.
     appendingPathComponent("새로운 녹음 \(recordedFiles.count + 1)")를 사용하여 새로운 파일의 URL을 생성합니다. 이는 이전에 녹음된 파일의 개수에 1을 더한 값으로 새 파일 이름을 생성합니다.
     녹음 설정 (settings):

     settings 딕셔너리에는 녹음에 대한 설정이 포함됩니다. 여기에는 오디오 형식, 샘플링 속도, 채널 수 및 오디오 품질이 포함됩니다.
     AVAudioRecorder 생성:

     AVAudioRecorder 클래스의 이니셜라이저를 사용하여 녹음을 위한 객체를 생성합니다. 이때 앞에서 생성한 fileURL과 settings를 사용합니다.
     녹음 시작:

     audioRecorder?.record()를 호출하여 녹음을 시작합니다.
     isRecording 프로퍼티를 true로 설정하여 녹음이 진행 중임을 나타냅니다.
     */
    private func startRecording() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("새로운 녹음 \(recordedFiles.count + 1)")
       
        //파일 셋팅
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000, // 셈플링 비율 대표 설정값
            AVNumberOfChannelsKey: 1, //
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue // 높은수준
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            self.isRecording = true // 레코딩 되고 있는지
        } catch {
            displayAlert(message: "음성메모 녹음 중 오류가 발생했습니다.")
        }
    }
    
    private func stopRecording() {
        audioRecorder?.stop() // 현재 나오는 오디오 멈추고
        self.recordedFiles.append(self.audioRecorder!.url) // 저장시키기 녹음한 파일
        self.isRecording = false
    }
    
    // 문서의 디렉토리를 가져오는 메서드
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

// MARK: - 음성메모 재생 관련
extension VoiceRecorderViewModel {
    func startPlaying(recordingURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            audioPlayer?.delegate = self
            audioPlayer?.play() // 재생
            self.isPlaying = true
            self.isPaused = false
            self.progressTimer = Timer.scheduledTimer(
                withTimeInterval: 0.1, // 타이머 간격
                repeats: true // 반복
            ) { _ in
                // 어떤 동작을 해줄것인지
                self.updateCurrentTime() // 현재 시간 업데이트 메서드 호출
            }
        } catch {
            displayAlert(message: "음성메모 재생 중 오류가 발생했습니다.")
        }
    }
    
    private func updateCurrentTime() {
        // 현재 재생 오디오 타임으로 대입
        self.playedTime = audioPlayer?.currentTime ?? 0
    }
    
    private func stopPlaying() {
        audioPlayer?.stop()
        playedTime = 0
        self.progressTimer?.invalidate() // 프로그래스 타임도 초기화
        self.isPlaying = false
        self.isPaused = false
    }
    
    // 일시정지
    func pausePlaying() {
        audioPlayer?.pause()
        self.isPaused = true
    }
    
    // 재개
    func resumePlaying() {
        audioPlayer?.play()
        self.isPaused = false
    }
    
    // 오디오 플레이가 다 끝났을때 AVAudioPlayerDelegate에서 제공해주는 메서드
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isPlaying = false
        self.isPaused = false
    }
    
    
    // View에서 오디오 플레이어 파일정보 표시위해 시간, TimeInterval로 반환해주는 메서드
    func getFileInfo(for url: URL) -> (Date?, TimeInterval?) {
        let fileManager = FileManager.default
        var creationDate: Date? // 시간
        var duration: TimeInterval? // 기간
        
        do {
            let fileAttributes = try fileManager.attributesOfItem(atPath: url.path)
            creationDate = fileAttributes[.creationDate] as? Date
        } catch {
            displayAlert(message: "선택된 음성메모 파일 정보를 불러올 수 없습니다.")
        }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            duration = audioPlayer.duration // 기간
        } catch {
            displayAlert(message: "선택된 음성메모 파일의 재생 시간을 불러올 수 없습니다.")
        }
        
        return (creationDate, duration)
    }
}

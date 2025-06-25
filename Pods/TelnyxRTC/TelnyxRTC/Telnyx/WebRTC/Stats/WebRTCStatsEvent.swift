import Foundation

enum WebRTCStatsEvent: String {
    case addConnection = "addConnection"
    case stats = "stats"
    case statsFrame = "statsFrame"
    case onIceCandidate = "onicecandidate"
    case onTrack = "ontrack"
    case onSignalingStateChange = "onsignalingstatechange"
    case onIceConnectionStateChange = "oniceconnectionstatechange"
    case onIceGatheringStateChange = "onicegatheringstatechange"
    case onIceCandidateError = "onicecandidateerror"
    case onConnectionStateChange = "onconnectionstatechange"
    case onNegotiationNeeded = "onnegotiationneeded"
    case onDataChannel = "ondatachannel"
    case getUserMedia = "getUserMedia"
    case mute = "mute"
    case unmute = "unmute"
    case overconstrained = "overconstrained"
    case ended = "ended"
}

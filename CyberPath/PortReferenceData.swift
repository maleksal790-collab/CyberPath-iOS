import Foundation

enum PortReferenceData {
    static let items: [PortCheatSheetItem] = [
        PortCheatSheetItem(port: 22, transportProtocol: "TCP", usesTCP: true, description: "SSH remote administration"),
        PortCheatSheetItem(port: 53, transportProtocol: "TCP/UDP", usesTCP: true, description: "DNS name resolution"),
        PortCheatSheetItem(port: 80, transportProtocol: "TCP", usesTCP: true, description: "HTTP web traffic"),
        PortCheatSheetItem(port: 123, transportProtocol: "UDP", usesTCP: false, description: "NTP time synchronization"),
        PortCheatSheetItem(port: 443, transportProtocol: "TCP", usesTCP: true, description: "HTTPS encrypted web traffic"),
        PortCheatSheetItem(port: 3389, transportProtocol: "TCP", usesTCP: true, description: "Remote Desktop Protocol")
    ]
}

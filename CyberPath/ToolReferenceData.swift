import Foundation

enum ToolReferenceData {
    static let categories: [ToolLandscapeCategory] = [
        ToolLandscapeCategory(
            category: "SIEM",
            tools: ["Microsoft Sentinel", "Splunk", "Elastic"]
        ),
        ToolLandscapeCategory(
            category: "Endpoint Protection",
            tools: ["Microsoft Defender for Endpoint", "CrowdStrike Falcon", "SentinelOne"]
        ),
        ToolLandscapeCategory(
            category: "Cloud Posture",
            tools: ["Microsoft Defender for Cloud", "Wiz", "Prisma Cloud"]
        ),
        ToolLandscapeCategory(
            category: "Vulnerability Management",
            tools: ["Tenable", "Qualys", "Rapid7"]
        )
    ]
}

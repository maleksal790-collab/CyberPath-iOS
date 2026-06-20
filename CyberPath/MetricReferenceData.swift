import Foundation

enum MetricReferenceData {
    static let metrics: [SecurityMetric] = [
        SecurityMetric(
            metric: "MTTD",
            fullName: "Mean Time To Detect",
            description: "Average time between issue occurrence and detection by people or tooling.",
            target: "Trend downward over time",
            category: "Detection"
        ),
        SecurityMetric(
            metric: "MTTR",
            fullName: "Mean Time To Respond",
            description: "Average time required to contain, remediate, or restore after a confirmed event.",
            target: "Trend downward while preserving quality",
            category: "Response"
        ),
        SecurityMetric(
            metric: "Patch SLA",
            fullName: "Patch Service-Level Agreement",
            description: "Percentage of fixes completed inside approved remediation windows.",
            target: "Meet or exceed agreed threshold",
            category: "Vulnerability Management"
        ),
        SecurityMetric(
            metric: "Coverage",
            fullName: "Telemetry Coverage",
            description: "Percentage of critical assets sending expected monitoring and operational data.",
            target: "Increase coverage for critical assets",
            category: "Monitoring"
        )
    ]
}

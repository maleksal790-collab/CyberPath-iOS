import Foundation

enum GlossaryData {
    static let terms: [GlossaryTerm] = [
        GlossaryTerm(
            term: "Asset",
            definition: "A system, data set, account, device, application, or business process that has value and needs ownership.",
            relatedDomainIds: ["it-fundamentals", "grc"]
        ),
        GlossaryTerm(
            term: "Control",
            definition: "A safeguard or activity designed to reduce risk, detect issues, enforce policy, or support recovery.",
            relatedDomainIds: ["grc", "security-operations"]
        ),
        GlossaryTerm(
            term: "Evidence",
            definition: "Records, logs, screenshots, approvals, exports, or attestations used to prove that work happened or a control operated.",
            relatedDomainIds: ["grc", "security-operations"]
        ),
        GlossaryTerm(
            term: "Least Privilege",
            definition: "Granting only the access required for a user, service, or workflow to complete its approved task.",
            relatedDomainIds: ["cloud-security", "security-operations"]
        ),
        GlossaryTerm(
            term: "Segmentation",
            definition: "Separating systems or networks into controlled zones to reduce exposure and limit incident blast radius.",
            relatedDomainIds: ["networking", "grc"]
        ),
        GlossaryTerm(
            term: "Telemetry",
            definition: "Operational data such as logs, events, metrics, and traces collected from systems for monitoring and investigation.",
            relatedDomainIds: ["security-operations", "networking"]
        )
    ]
}

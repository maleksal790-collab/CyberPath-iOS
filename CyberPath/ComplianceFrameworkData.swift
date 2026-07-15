import Foundation

/// Represents a compliance or security framework.
struct ComplianceFramework: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let abbreviation: String
    let scope: String                    // "Cybersecurity", "Data Privacy", "Cloud", etc.
    let description: String
    let keyRequirements: [String]
    let applicableIndustries: [String]
    let releaseYear: Int?
    let primaryBody: String              // "NIST", "ISO", "GDPR", etc.

    init(
        name: String,
        abbreviation: String,
        scope: String,
        description: String,
        keyRequirements: [String],
        applicableIndustries: [String],
        releaseYear: Int? = nil,
        primaryBody: String
    ) {
        self.id = abbreviation
        self.name = name
        self.abbreviation = abbreviation
        self.scope = scope
        self.description = description
        self.keyRequirements = keyRequirements
        self.applicableIndustries = applicableIndustries
        self.releaseYear = releaseYear
        self.primaryBody = primaryBody
    }
}

enum ComplianceFrameworkData {
    static let frameworks: [ComplianceFramework] = [
        ComplianceFramework(
            name: "NIST Cybersecurity Framework",
            abbreviation: "NIST CSF",
            scope: "Cybersecurity Risk Management",
            description: "Voluntary framework providing guidance on how to manage and reduce cybersecurity risk. Applicable across all sectors and organization sizes.",
            keyRequirements: [
                "Identify: Know your assets, risks, and business context.",
                "Protect: Implement safeguards to enable delivery of core services.",
                "Detect: Understand and monitor potential cyber incidents.",
                "Respond: Take planned actions during and after a cyber incident.",
                "Recover: Restore capabilities affected by a cyber incident."
            ],
            applicableIndustries: ["Critical Infrastructure", "Federal", "Private sector", "Any"],
            releaseYear: 2014,
            primaryBody: "NIST"
        ),
        ComplianceFramework(
            name: "ISO/IEC 27001",
            abbreviation: "ISO 27001",
            scope: "Information Security Management Systems",
            description: "Certifiable standard for establishing, implementing, and maintaining an information security management system (ISMS). Includes 14 control domains.",
            keyRequirements: [
                "Information security policies",
                "Organization of information security",
                "Human resource security",
                "Asset management",
                "Access control",
                "Cryptography",
                "Physical and environmental security",
                "Operations security",
                "Communications security",
                "System acquisition, development and maintenance",
                "Supplier relationships",
                "Information security incident management",
                "Business continuity management",
                "Compliance (legal, regulatory, contractual)"
            ],
            applicableIndustries: ["Any"],
            releaseYear: 2013,
            primaryBody: "ISO/IEC"
        ),
        ComplianceFramework(
            name: "GDPR",
            abbreviation: "GDPR",
            scope: "Data Privacy and Protection",
            description: "European Union regulation on data protection and privacy for individuals. Applies to any organization processing personal data of EU residents.",
            keyRequirements: [
                "Lawful basis for processing",
                "Data minimization and purpose limitation",
                "Consent and privacy by design",
                "Right to access and data portability",
                "Right to be forgotten and erasure",
                "Breach notification (within 72 hours)",
                "Data protection impact assessments",
                "Data protection officer (DPO) appointment"
            ],
            applicableIndustries: ["EU-based", "Any organization handling EU resident data"],
            releaseYear: 2018,
            primaryBody: "European Union"
        ),
        ComplianceFramework(
            name: "CIS Controls",
            abbreviation: "CIS",
            scope: "Technical Security Controls",
            description: "Prioritized best practices to protect organizations from cyber attacks. 18 controls across Governance, Defender, and Detect categories.",
            keyRequirements: [
                "Inventory and Control of Hardware Assets",
                "Inventory and Control of Software Assets",
                "Asset Management",
                "Secure Configuration Management",
                "Access Control Management",
                "Maintenance, Monitoring and Analysis of Audit Logs",
                "Email and Web Browser Protections",
                "Malware Defenses",
                "Limitation and Control of Network Ports, Protocols, and Services",
                "Data Recovery Capabilities",
                "Secure Configuration Management - Network Infrastructure",
                "Boundary Defense",
                "Data Protection",
                "Controlled Access Based on the Need to Know",
                "Wireless Access Point Management",
                "Account Monitoring and Control",
                "Security Awareness and Training Program",
                "Incident Response Management"
            ],
            applicableIndustries: ["Any"],
            releaseYear: 2019,
            primaryBody: "Center for Internet Security"
        ),
        ComplianceFramework(
            name: "COBIT 2019",
            abbreviation: "COBIT",
            scope: "IT Governance and Management",
            description: "Framework for governance and management of enterprise IT. Aligns IT delivery with business objectives through comprehensive control objectives.",
            keyRequirements: [
                "Governance: Evaluated and Directed",
                "Align, Plan and Organize",
                "Build, Acquire and Implement",
                "Deliver, Service and Support",
                "Monitor, Evaluate and Assess"
            ],
            applicableIndustries: ["Any enterprise"],
            releaseYear: 2019,
            primaryBody: "ISACA"
        )
    ]
}

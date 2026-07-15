import Foundation

/// Represents a common attack pattern or adversarial technique.
struct AttackPattern: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let abbreviation: String
    let category: String              // "Social Engineering", "Malware", "Network", etc.
    let description: String
    let typicalTargets: [String]      // "SMBs", "Enterprises", "Critical Infrastructure"
    let detectionMethods: [String]    // How to identify this attack
    let mitigationSteps: [String]     // How to defend against it
    let releaseYear: Int?
    let primarySource: String         // "MITRE ATT&CK", "OWASP", etc.

    init(
        name: String,
        abbreviation: String,
        category: String,
        description: String,
        typicalTargets: [String],
        detectionMethods: [String],
        mitigationSteps: [String],
        releaseYear: Int? = nil,
        primarySource: String
    ) {
        self.id = abbreviation
        self.name = name
        self.abbreviation = abbreviation
        self.category = category
        self.description = description
        self.typicalTargets = typicalTargets
        self.detectionMethods = detectionMethods
        self.mitigationSteps = mitigationSteps
        self.releaseYear = releaseYear
        self.primarySource = primarySource
    }
}

enum AttackPatternData {
    static let patterns: [AttackPattern] = [
        AttackPattern(
            name: "Phishing",
            abbreviation: "T1566",
            category: "Social Engineering",
            description: "Adversaries send fraudulent communications that appear to come from a trusted source to induce targets to reveal sensitive information or execute malicious code.",
            typicalTargets: ["SMBs", "Enterprises", "Education", "Government"],
            detectionMethods: [
                "Monitor email gateways for suspicious sender addresses and domains",
                "Analyze email headers for spoofing indicators",
                "Track user reports of suspicious emails",
                "Monitor for unusual credential submission patterns"
            ],
            mitigationSteps: [
                "Implement multi-factor authentication (MFA)",
                "Deploy email filtering and anti-phishing tools",
                "Conduct regular security awareness training",
                "Use email authentication (SPF, DKIM, DMARC)",
                "Implement user-level whitelisting and blacklisting"
            ],
            releaseYear: 2020,
            primarySource: "MITRE ATT&CK"
        ),
        AttackPattern(
            name: "Credential Dumping",
            abbreviation: "T1003",
            category: "Credential Access",
            description: "Adversaries attempt to obtain credential material, such as password hashes or access tokens, by targeting operating system memory and credential stores.",
            typicalTargets: ["Enterprises", "Government", "Critical Infrastructure"],
            detectionMethods: [
                "Monitor for registry access patterns and Windows API calls",
                "Detect unusual LSASS process access",
                "Monitor for use of credential dumping tools (mimikatz, gsecdump)",
                "Check for suspicious process creation and command-line arguments"
            ],
            mitigationSteps: [
                "Enable credential guard on Windows",
                "Use strong password policies and MFA",
                "Minimize privileged account exposure",
                "Disable WDigest authentication",
                "Monitor and audit privileged account usage"
            ],
            releaseYear: 2017,
            primarySource: "MITRE ATT&CK"
        ),
        AttackPattern(
            name: "SQL Injection",
            abbreviation: "T1190",
            category: "Exploitation",
            description: "An adversary exploits weaknesses in an online service that uses a SQL database by injecting malicious SQL statements to gain unauthorized access or data manipulation.",
            typicalTargets: ["Web Applications", "Databases", "E-commerce", "Healthcare"],
            detectionMethods: [
                "Monitor database query logs for suspicious SQL patterns",
                "Analyze SQL error messages for injection indicators",
                "Track unusual database access patterns",
                "Monitor for repeated failed authentication attempts"
            ],
            mitigationSteps: [
                "Use parameterized queries and stored procedures",
                "Implement input validation and sanitization",
                "Apply principle of least privilege to database accounts",
                "Use web application firewalls (WAF)",
                "Conduct regular penetration testing"
            ],
            releaseYear: 2018,
            primarySource: "OWASP"
        ),
        AttackPattern(
            name: "Malware Distribution",
            abbreviation: "T1204",
            category: "Initial Access",
            description: "Adversaries distribute malware through various channels, including email, websites, removable media, or supply chain compromise to establish initial access.",
            typicalTargets: ["SMBs", "Enterprises", "Individuals", "Government"],
            detectionMethods: [
                "Monitor file hash databases for known malware (VirusTotal, YARA)",
                "Analyze network traffic for C2 communications",
                "Monitor for suspicious file execution and behavior",
                "Track email attachments and download sources"
            ],
            mitigationSteps: [
                "Deploy endpoint detection and response (EDR)",
                "Use advanced email filtering with sandboxing",
                "Maintain updated antivirus/antimalware signatures",
                "Educate users on file download risks",
                "Implement application whitelisting"
            ],
            releaseYear: 2017,
            primarySource: "MITRE ATT&CK"
        ),
        AttackPattern(
            name: "Privilege Escalation",
            abbreviation: "T1548",
            category: "Privilege Escalation",
            description: "Adversaries exploit vulnerabilities or misconfigurations to obtain elevated privileges on a system, moving from user-level to administrator or root access.",
            typicalTargets: ["Windows", "Linux", "macOS", "Cloud Environments"],
            detectionMethods: [
                "Monitor process creation with elevated privileges",
                "Track kernel exploit attempts",
                "Monitor sudo/UAC prompt abuse",
                "Analyze Windows event logs for privilege changes"
            ],
            mitigationSteps: [
                "Keep operating systems and applications patched",
                "Disable unnecessary services and drivers",
                "Implement least privilege principle",
                "Monitor for suspicious privilege elevation",
                "Use code signing and execution policies"
            ],
            releaseYear: 2017,
            primarySource: "MITRE ATT&CK"
        )
    ]
}

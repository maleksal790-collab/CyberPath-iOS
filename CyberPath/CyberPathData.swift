import Foundation

enum CyberPathData {
    static let domains: [Domain] = [
        Domain(
            id: "it-fundamentals",
            title: "IT Foundations",
            symbol: "desktopcomputer",
            colorHex: "#3b82f6",
            summary: "Build the technical baseline: devices, operating systems, virtualization, identity, ownership, and support boundaries.",
            stage: "Foundation",
            topics: [
                Topic(
                    id: "hardware-basics",
                    title: "Hardware & Endpoint Basics",
                    minutes: 12,
                    difficulty: 1,
                    overview: "Understand CPU, memory, storage, firmware, and network interfaces as operational and security dependencies.",
                    workplaceUse: "Use this when discussing endpoint refreshes, device performance issues, evidence capture, and infrastructure risk.",
                    keyTerms: ["CPU", "RAM", "SSD", "NIC", "Firmware"],
                    quiz: QuizQuestion(
                        question: "Which component is most relevant to memory forensics?",
                        answers: ["CPU", "RAM", "Power supply", "Display"],
                        correctIndex: 1,
                        explanation: "RAM can contain active process data, malware artifacts, credentials, and other volatile evidence. It disappears when power is lost."
                    )
                ),
                Topic(
                    id: "operating-systems",
                    title: "Operating Systems & Ownership",
                    minutes: 15,
                    difficulty: 1,
                    overview: "Compare Windows, Linux, and macOS administration models, services, filesystems, patching, and permissions.",
                    workplaceUse: "Helps project managers clarify platform owners, patch plans, endpoint hardening responsibilities, and support handoffs.",
                    keyTerms: ["Kernel", "Registry", "Shell", "Permissions", "Service"],
                    quiz: QuizQuestion(
                        question: "Which platform is most associated with Active Directory in enterprise environments?",
                        answers: ["Linux", "Windows", "macOS", "FreeBSD"],
                        correctIndex: 1,
                        explanation: "Windows enterprise environments commonly use Active Directory or Entra-integrated identity patterns for centralized identity and policy."
                    )
                ),
                Topic(
                    id: "virtualization-basics",
                    title: "Virtualization & Lab Thinking",
                    minutes: 14,
                    difficulty: 1,
                    overview: "Understand virtual machines, snapshots, host resources, isolated labs, and why repeatable testing matters.",
                    workplaceUse: "Useful when planning safe test environments, rollback strategies, training labs, and proof-of-concept work.",
                    keyTerms: ["VM", "Snapshot", "Hypervisor", "Isolation", "Rollback"],
                    quiz: QuizQuestion(
                        question: "Why are snapshots valuable in a cybersecurity lab?",
                        answers: ["They increase monitor brightness", "They allow rollback to a known state", "They replace backups", "They remove the need for testing"],
                        correctIndex: 1,
                        explanation: "Snapshots let the learner return to a known baseline after a test, mistake, or malware simulation."
                    )
                )
            ],
            capstone: "Create a simple asset, platform, and ownership map for a small business unit."
        ),
        Domain(
            id: "networking",
            title: "Networking",
            symbol: "network",
            colorHex: "#06b6d4",
            summary: "Understand how traffic moves: OSI/TCP-IP, addressing, routing, switching, DNS, DHCP, VPNs, and segmentation.",
            stage: "Foundation",
            topics: [
                Topic(
                    id: "osi-tcpip",
                    title: "OSI & TCP/IP Models",
                    minutes: 15,
                    difficulty: 1,
                    overview: "Use layered models to describe how traffic moves and where failures, bottlenecks, or attacks occur.",
                    workplaceUse: "Clarifies ownership during outages, firewall changes, application issues, and architecture reviews.",
                    keyTerms: ["Layer 3", "Layer 4", "Layer 7", "TCP/IP"],
                    quiz: QuizQuestion(
                        question: "Which OSI layer is commonly associated with routing?",
                        answers: ["Layer 1", "Layer 2", "Layer 3", "Layer 7"],
                        correctIndex: 2,
                        explanation: "Layer 3 handles logical addressing and routing decisions between networks."
                    )
                ),
                Topic(
                    id: "firewalls-vpns",
                    title: "Firewalls, VPNs & Segmentation",
                    minutes: 16,
                    difficulty: 2,
                    overview: "Control traffic between trust zones and provide secure remote access through approved encrypted paths.",
                    workplaceUse: "Supports change approvals, segmentation projects, secure access rollouts, and rollback planning.",
                    keyTerms: ["ACL", "VPN", "Segmentation", "Ingress", "Egress"],
                    quiz: QuizQuestion(
                        question: "What is the main purpose of a firewall rule?",
                        answers: ["Store data", "Control traffic", "Compile code", "Assign IPs"],
                        correctIndex: 1,
                        explanation: "Firewall rules permit or deny traffic according to business and security policy."
                    )
                ),
                Topic(
                    id: "dns-dhcp-core",
                    title: "DNS, DHCP & Certificates",
                    minutes: 13,
                    difficulty: 2,
                    overview: "Recognize how naming, addressing, and certificate trust can make healthy systems appear broken when misconfigured.",
                    workplaceUse: "Helps explain outage root causes, certificate renewals, application cutovers, and network dependency risks.",
                    keyTerms: ["DNS", "DHCP", "TTL", "Certificate", "Trust"],
                    quiz: QuizQuestion(
                        question: "What does DNS primarily provide?",
                        answers: ["Name resolution", "Disk encryption", "Screen sharing", "Source code review"],
                        correctIndex: 0,
                        explanation: "DNS resolves names to addresses and is a critical dependency for most modern services."
                    )
                )
            ],
            capstone: "Design a secure branch-office network with trust boundaries, approved flows, and rollback notes."
        ),
        Domain(
            id: "security-operations",
            title: "Security Operations",
            symbol: "shield.lefthalf.filled",
            colorHex: "#22c55e",
            summary: "Practice detection, triage, containment, evidence handling, communications, and operational improvement.",
            stage: "Practitioner",
            topics: [
                Topic(
                    id: "incident-response",
                    title: "Incident Response Lifecycle",
                    minutes: 18,
                    difficulty: 2,
                    overview: "Prepare, detect, contain, recover, and improve using a repeatable lifecycle.",
                    workplaceUse: "Improves incident communications, decision authority, logging, evidence handling, and lessons learned.",
                    keyTerms: ["Prepare", "Detect", "Contain", "Recover", "Improve"],
                    quiz: QuizQuestion(
                        question: "Which response stage should feed updated playbooks and controls?",
                        answers: ["Improve", "Ignore", "Procure", "Archive"],
                        correctIndex: 0,
                        explanation: "Lessons learned should improve controls, playbooks, training, and architecture. Otherwise the same incident returns wearing a fake mustache."
                    )
                ),
                Topic(
                    id: "identity-triage",
                    title: "Identity Triage",
                    minutes: 16,
                    difficulty: 2,
                    overview: "Investigate suspicious sign-ins, token exposure, OAuth grants, session persistence, and privileged account anomalies.",
                    workplaceUse: "Supports containment decisions that preserve evidence while reducing account and business impact.",
                    keyTerms: ["MFA", "OAuth", "Token", "Session", "Privilege"],
                    quiz: QuizQuestion(
                        question: "What should be considered beyond a password reset after OAuth abuse?",
                        answers: ["Screen brightness", "Grant revocation", "Printer queue", "Keyboard layout"],
                        correctIndex: 1,
                        explanation: "Malicious grants and active sessions can persist beyond a password reset, so revocation and session invalidation matter."
                    )
                ),
                Topic(
                    id: "decision-log",
                    title: "Decision Logs & Evidence Quality",
                    minutes: 12,
                    difficulty: 2,
                    overview: "Document what happened, what was decided, why it was decided, who approved it, and what must be verified next.",
                    workplaceUse: "Turns incident activity into defensible evidence for leadership, audit, legal, and future improvement.",
                    keyTerms: ["Timeline", "Evidence", "Rationale", "Owner", "Verification"],
                    quiz: QuizQuestion(
                        question: "What makes an incident decision log useful?",
                        answers: ["Clear rationale and timestamped ownership", "Long emotional commentary", "Only screenshots", "No approvals"],
                        correctIndex: 0,
                        explanation: "A useful decision log connects evidence, decision, owner, timing, business impact, and next verification."
                    )
                )
            ],
            capstone: "Draft an incident decision log for a suspected credential compromise under business pressure."
        ),
        Domain(
            id: "grc",
            title: "GRC & Governance",
            symbol: "checklist.checked",
            colorHex: "#a855f7",
            summary: "Translate technical findings into accountable governance: risk treatment, controls, evidence, policy, and executive reporting.",
            stage: "Practitioner",
            topics: [
                Topic(
                    id: "risk-treatment",
                    title: "Risk Treatment",
                    minutes: 14,
                    difficulty: 2,
                    overview: "Choose between accepting, mitigating, transferring, and avoiding risk based on likelihood, impact, owner appetite, and timing.",
                    workplaceUse: "Connects technical findings to business decisions, ownership, review dates, and residual risk.",
                    keyTerms: ["Accept", "Mitigate", "Transfer", "Avoid", "Residual Risk"],
                    quiz: QuizQuestion(
                        question: "Which risk treatment reduces likelihood or impact through added controls?",
                        answers: ["Accept", "Mitigate", "Transfer", "Avoid"],
                        correctIndex: 1,
                        explanation: "Mitigation reduces likelihood, impact, or both through controls. Acceptance requires accountable approval."
                    )
                ),
                Topic(
                    id: "control-evidence",
                    title: "Controls & Evidence",
                    minutes: 15,
                    difficulty: 2,
                    overview: "Separate policy intent from actual control operation, then collect evidence that proves whether the control works.",
                    workplaceUse: "Useful for audits, compliance projects, security steering committees, and vendor assurance reviews.",
                    keyTerms: ["Control", "Evidence", "Test", "Owner", "Exception"],
                    quiz: QuizQuestion(
                        question: "What is stronger evidence for a control test?",
                        answers: ["A policy statement only", "A timestamped report showing control operation", "A meeting note saying it is fine", "A generic screenshot without context"],
                        correctIndex: 1,
                        explanation: "Evidence should show operation, timing, scope, result, and ownership. A policy alone is not proof of operation."
                    )
                )
            ],
            capstone: "Write a risk decision memo with owner, treatment, residual risk, evidence requirement, and review date."
        ),
        Domain(
            id: "cloud-security",
            title: "Cloud Security",
            symbol: "icloud.fill",
            colorHex: "#f59e0b",
            summary: "Understand shared responsibility, IAM, storage exposure, logging, deployment access, and cloud security posture.",
            stage: "Practitioner",
            topics: [
                Topic(
                    id: "shared-responsibility",
                    title: "Shared Responsibility Model",
                    minutes: 10,
                    difficulty: 1,
                    overview: "Understand which security controls are owned by the cloud provider versus the customer.",
                    workplaceUse: "Crucial for reviewing SaaS and IaaS contracts and identifying security control gaps.",
                    keyTerms: ["IaaS", "PaaS", "SaaS", "Customer Data", "Infrastructure"],
                    quiz: QuizQuestion(
                        question: "In an Infrastructure as a Service model, who is primarily responsible for securing the guest operating system?",
                        answers: ["The cloud provider", "The customer", "Third-party auditors", "Internet service providers"],
                        correctIndex: 1,
                        explanation: "In IaaS, the provider secures the physical infrastructure, but the customer must patch and secure the guest operating system."
                    )
                ),
                Topic(
                    id: "cloud-iam",
                    title: "Cloud IAM & Least Privilege",
                    minutes: 15,
                    difficulty: 2,
                    overview: "Explore how Identity and Access Management governs access to cloud resources, automation, and deployment pipelines.",
                    workplaceUse: "Used when designing access roles for developers, CI/CD pipelines, and external applications.",
                    keyTerms: ["IAM", "Role", "Policy", "Least Privilege", "Service Principal"],
                    quiz: QuizQuestion(
                        question: "What is the best practice for granting a CI/CD pipeline access to deploy cloud resources?",
                        answers: ["Use root account credentials", "Assign a dedicated service role with scoped permissions", "Make the resources public during deployment", "Share an administrator password"],
                        correctIndex: 1,
                        explanation: "A dedicated service role with least privilege lets the pipeline perform only approved deployment actions."
                    )
                ),
                Topic(
                    id: "storage-exposure",
                    title: "Cloud Storage Exposure",
                    minutes: 13,
                    difficulty: 2,
                    overview: "Understand how public buckets, weak policies, overbroad roles, and missing monitoring create data exposure risk.",
                    workplaceUse: "Useful for reviewing cloud storage projects, data classification, release exceptions, and emergency containment decisions.",
                    keyTerms: ["Bucket", "Policy", "Public Access", "Encryption", "Audit Log"],
                    quiz: QuizQuestion(
                        question: "What should happen first when sensitive cloud storage is publicly exposed?",
                        answers: ["Contain exposure", "Wait for the original developer", "Ignore it until the next audit", "Delete all logs"],
                        correctIndex: 0,
                        explanation: "Containment comes first. After that, preserve logs, assess exposure, fix root cause, and report through the right process."
                    )
                )
            ],
            capstone: "Map the security responsibilities and access controls for a newly proposed SaaS or cloud storage rollout."
        ),
        Domain(
            id: "delivery-governance",
            title: "Secure Delivery",
            symbol: "shippingbox.and.arrow.backward.fill",
            colorHex: "#ef4444",
            summary: "Connect cybersecurity, product delivery, change control, CI/CD, release evidence, and management reporting.",
            stage: "Advanced",
            topics: [
                Topic(
                    id: "release-gates",
                    title: "Release Gates & Change Control",
                    minutes: 16,
                    difficulty: 3,
                    overview: "Use clear entry and exit criteria so security, quality, business ownership, and release readiness are not left to memory.",
                    workplaceUse: "Supports governed software delivery, production approvals, rollback planning, and executive confidence.",
                    keyTerms: ["Gate", "Approval", "Rollback", "Evidence", "Change Window"],
                    quiz: QuizQuestion(
                        question: "What should a release gate prove before production deployment?",
                        answers: ["That someone is optimistic", "That required checks and approvals are complete", "That the team is tired", "That documentation can wait"],
                        correctIndex: 1,
                        explanation: "A release gate should prove that defined checks, owners, risk decisions, and rollback steps are complete. Hope is not a control."
                    )
                ),
                Topic(
                    id: "pipeline-security",
                    title: "Pipeline Security Basics",
                    minutes: 18,
                    difficulty: 3,
                    overview: "Protect source code, secrets, build steps, deployment roles, dependency integrity, and artifact promotion paths.",
                    workplaceUse: "Useful when governing GitHub, CI/CD, mobile release preparation, and production deployment workflows.",
                    keyTerms: ["Secrets", "Branch Protection", "Artifact", "SAST", "Dependency"],
                    quiz: QuizQuestion(
                        question: "Which practice reduces unauthorized production changes?",
                        answers: ["Direct pushes to main", "Protected branches and reviewed pull requests", "Shared admin passwords", "Skipping build logs"],
                        correctIndex: 1,
                        explanation: "Protected branches, reviews, checks, and controlled deployment permissions reduce unauthorized or unreviewed production changes."
                    )
                )
            ],
            capstone: "Design a governed mobile release checklist with code review, build validation, signing, TestFlight, rollback, and approval evidence."
        )
    ]

    static let scenarios: [Scenario] = [
        Scenario(
            id: "credential-compromise",
            title: "Credential compromise under delivery pressure",
            summary: "A finance administrator authenticated from Riyadh and Frankfurt within nine minutes. An OAuth consent event followed from an unmanaged device.",
            evidence: [
                EvidenceItem(title: "Identity sign-in log", detail: "Impossible travel and unfamiliar network."),
                EvidenceItem(title: "OAuth audit trail", detail: "New high-risk application grant."),
                EvidenceItem(title: "Endpoint telemetry", detail: "No managed endpoint associated with the session."),
                EvidenceItem(title: "Email gateway", detail: "Possible consent-phishing message.")
            ],
            actions: [
                ScenarioAction(
                    id: "coordinated-containment",
                    label: "Revoke sessions, suspend the grant, preserve logs, and verify with the user.",
                    score: 92,
                    feedback: "Strong decision: contains access, preserves evidence, limits impact, and verifies through a trusted channel.",
                    development: "Finance confirms a critical payment window is active and asks for immediate restoration.",
                    followUps: [
                        FollowUpAction(id: "temporary-clean-access", label: "Issue time-limited clean access with minimum privileges.", consequence: "Operations resume without restoring the potentially compromised identity.", recommended: true),
                        FollowUpAction(id: "restore-original", label: "Restore the original account after password reset.", consequence: "This can restore active malicious grants or sessions before scope is understood.", recommended: false)
                    ]
                ),
                ScenarioAction(
                    id: "password-reset",
                    label: "Reset the password and wait for user confirmation.",
                    score: 61,
                    feedback: "Partial decision: a password reset alone may leave active sessions and malicious grants intact.",
                    development: "The suspicious OAuth application continues reading mailbox data through an existing grant.",
                    followUps: [
                        FollowUpAction(id: "revoke-grant", label: "Revoke grants and active sessions, then preserve audit evidence.", consequence: "Containment improves and evidence remains available.", recommended: true),
                        FollowUpAction(id: "monitor-only", label: "Monitor for another alert before changing access.", consequence: "The attacker may keep access while business impact grows.", recommended: false)
                    ]
                )
            ]
        ),
        Scenario(
            id: "cloud-storage-exposure",
            title: "Cloud storage exposure during release pressure",
            summary: "A developer temporarily made a cloud storage bucket public to troubleshoot a CI/CD pipeline issue, exposing customer profile data.",
            evidence: [
                EvidenceItem(title: "Cloud audit log", detail: "Bucket policy updated to PublicRead by a deployment role."),
                EvidenceItem(title: "Billing alert", detail: "Spike in outbound data transfer from the storage bucket."),
                EvidenceItem(title: "Support ticket", detail: "Developer note: testing public access for build pipeline."),
                EvidenceItem(title: "Data classification", detail: "Bucket contains customer profile data marked confidential.")
            ],
            actions: [
                ScenarioAction(
                    id: "immediate-revert",
                    label: "Revert the bucket policy to private immediately and review access logs.",
                    score: 95,
                    feedback: "Excellent decision: stops the active data leak first, then moves to impact assessment and root cause.",
                    development: "The developer says the pipeline is now failing and blocking a critical release window.",
                    followUps: [
                        FollowUpAction(id: "create-service-role", label: "Create a dedicated pipeline role with scoped private-bucket access.", consequence: "Secures the release path without public exposure.", recommended: true),
                        FollowUpAction(id: "temporary-public", label: "Make it public again for the 10-minute release window.", consequence: "Re-exposes customer data and creates a weak precedent.", recommended: false)
                    ]
                ),
                ScenarioAction(
                    id: "contact-developer",
                    label: "Message the developer and wait for them to fix their own bucket.",
                    score: 40,
                    feedback: "Poor decision: sensitive data is actively exposed. Containment must happen immediately.",
                    development: "The developer is in a different timezone and will not be online for six hours.",
                    followUps: [
                        FollowUpAction(id: "override-policy", label: "Override the change and secure the bucket immediately.", consequence: "The leak is finally stopped, but avoidable exposure time increased.", recommended: true),
                        FollowUpAction(id: "wait-for-dev", label: "Wait for the developer to wake up.", consequence: "Severe data breach potential due to inaction.", recommended: false)
                    ]
                )
            ]
        ),
        Scenario(
            id: "mobile-release-governance",
            title: "Mobile release governance before TestFlight",
            summary: "A mobile learning app is ready for Xcode validation, but signing, privacy wording, rollback evidence, and release approvals are not yet complete.",
            evidence: [
                EvidenceItem(title: "Pull request", detail: "Compile repair branch is mergeable but not yet validated on macOS."),
                EvidenceItem(title: "Signing status", detail: "Apple Developer Team is not configured in Xcode."),
                EvidenceItem(title: "Release notes", detail: "No TestFlight-ready release note or reviewer guidance exists yet."),
                EvidenceItem(title: "Data posture", detail: "App is local-first and has no third-party runtime dependency.")
            ],
            actions: [
                ScenarioAction(
                    id: "validate-before-testflight",
                    label: "Validate in Xcode, configure signing, write release notes, and package evidence before TestFlight.",
                    score: 94,
                    feedback: "Strong governance: build proof, signing readiness, and release evidence are handled before distribution.",
                    development: "Leadership asks whether the app can be shared today for early feedback.",
                    followUps: [
                        FollowUpAction(id: "limited-internal", label: "Use a limited internal TestFlight group after successful build and signing.", consequence: "Feedback starts without skipping the basic release controls.", recommended: true),
                        FollowUpAction(id: "share-unsigned", label: "Share an unsigned archive informally.", consequence: "Creates support, trust, and provenance issues.", recommended: false)
                    ]
                ),
                ScenarioAction(
                    id: "skip-controls",
                    label: "Skip release controls and focus only on the visual demo.",
                    score: 38,
                    feedback: "Weak decision: visual progress is useful, but release governance prevents avoidable credibility problems.",
                    development: "A stakeholder asks for assurance that the app does not collect sensitive data.",
                    followUps: [
                        FollowUpAction(id: "privacy-note", label: "Add privacy wording and local-data explanation before sharing.", consequence: "Trust improves and reviewer questions are easier to answer.", recommended: true),
                        FollowUpAction(id: "verbal-only", label: "Answer verbally and document later.", consequence: "Evidence remains weak and easy to misunderstand.", recommended: false)
                    ]
                )
            ]
        )
    ]

    static let visualLessons: [VisualLesson] = [
        VisualLesson(
            id: "risk",
            title: "Risk treatment",
            summary: "Move likelihood and impact into an accountable decision with owner, treatment, review date, and evidence.",
            prompts: ["Accept requires owner approval.", "Mitigate lowers likelihood or impact.", "Residual risk must still have an owner."]
        ),
        VisualLesson(
            id: "threat",
            title: "Threat model canvas",
            summary: "Name assets, actors, entry points, boundaries, threats, mitigations, and verification steps.",
            prompts: ["Start with the asset.", "Map the trust boundary.", "Write a verification prompt."]
        ),
        VisualLesson(
            id: "cloud",
            title: "Cloud responsibility",
            summary: "Separate provider controls from customer-owned identity, data, configuration, logging, and response obligations.",
            prompts: ["IaaS leaves more to the customer.", "SaaS still requires identity and data governance.", "Shared does not mean ownerless."]
        )
    ]

    static let diagnosticQuestions: [DiagnosticQuestion] = [
        DiagnosticQuestion(id: "it-1", domainId: "it-fundamentals", prompt: "How comfortable are you explaining CPU, RAM, storage, and firmware risk to a non-technical stakeholder?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "it-2", domainId: "it-fundamentals", prompt: "Can you identify which team owns a Windows, Linux, or macOS operational issue?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "it-3", domainId: "it-fundamentals", prompt: "Can you connect patching, endpoint hardening, and asset inventory to project risk?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "it-4", domainId: "it-fundamentals", prompt: "Can you explain why a lab or simulator is safer than testing directly in production?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "network-1", domainId: "networking", prompt: "Can you use OSI or TCP/IP layers to describe where a connectivity problem sits?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "network-2", domainId: "networking", prompt: "Can you explain why segmentation changes require firewall, routing, DNS, and rollback planning?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "network-3", domainId: "networking", prompt: "Can you review a VPN or firewall request for business need and exposure?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "network-4", domainId: "networking", prompt: "Can you identify which services depend on DNS, DHCP, routing, and certificate trust?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "soc-1", domainId: "security-operations", prompt: "Can you distinguish detection, containment, recovery, and improvement decisions during an incident?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "soc-2", domainId: "security-operations", prompt: "Can you preserve evidence while reducing active attacker access?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "soc-3", domainId: "security-operations", prompt: "Can you explain why token or OAuth abuse may survive a password reset?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "soc-4", domainId: "security-operations", prompt: "Can you write a short incident decision log with rationale and next verification step?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "grc-1", domainId: "grc", prompt: "Can you choose between accept, mitigate, transfer, and avoid for a concrete risk?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "grc-2", domainId: "grc", prompt: "Can you identify the owner, residual risk, review date, and evidence needed for a risk decision?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "grc-3", domainId: "grc", prompt: "Can you connect a control gap to an executive-readable business impact?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "grc-4", domainId: "grc", prompt: "Can you explain how policies, controls, tests, and evidence relate to compliance?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "cloud-1", domainId: "cloud-security", prompt: "Can you confidently draw the line of responsibility between your team and the cloud provider?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "cloud-2", domainId: "cloud-security", prompt: "Are you comfortable configuring least-privilege IAM roles for a new service?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "cloud-3", domainId: "cloud-security", prompt: "Can you explain why public storage exposure is both a technical and governance issue?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "delivery-1", domainId: "delivery-governance", prompt: "Can you define release gates before moving a mobile app to TestFlight or production?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "delivery-2", domainId: "delivery-governance", prompt: "Can you explain why branch protection, pull requests, and build checks matter?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "delivery-3", domainId: "delivery-governance", prompt: "Can you package release evidence for business, security, and technical stakeholders?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "cross-1", domainId: "security-operations", prompt: "Can you prioritize action when business pressure conflicts with containment?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "cross-2", domainId: "delivery-governance", prompt: "Can you explain every recommendation with a short 'why this next' reason?", answers: diagnosticAnswers)
    ]

    private static let diagnosticAnswers = [
        DiagnosticAnswer(label: "Emerging", score: 20),
        DiagnosticAnswer(label: "Developing", score: 55),
        DiagnosticAnswer(label: "Ready", score: 90)
    ]
}

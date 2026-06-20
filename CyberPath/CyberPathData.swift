import Foundation

enum CyberPathData {
    static let domains: [Domain] = [
        Domain(
            id: "it-fundamentals",
            title: "IT Fundamentals",
            symbol: "desktopcomputer",
            colorHex: "#3b82f6",
            summary: "Hardware, operating systems, virtualization, identity, and core IT concepts.",
            stage: "Foundation",
            topics: [
                Topic(
                    id: "hardware-basics",
                    title: "Hardware Components",
                    minutes: 12,
                    difficulty: 1,
                    overview: "Understanding the physical components that make up computing systems: CPU, RAM, storage devices, motherboards, power supplies, and peripheral devices. These components work together to process, store, and transmit data.",
                    workplaceUse: "When your infrastructure team discusses hardware refresh cycles, capacity planning, or performance bottlenecks, understanding these components helps you assess timelines, budget requirements, and risk. A failing hard drive or insufficient RAM can be a security vulnerability if it causes system instability.",
                    deepDive: [
                        "CPU: The brain of the computer, measured in cores, clock speed, and architecture. Security relevance includes hardware-level vulnerabilities such as Spectre and Meltdown.",
                        "RAM: Volatile memory for active processes. Security relevance includes memory forensics and attacks that target active memory.",
                        "Storage: HDDs and SSDs support data at rest, secure destruction, encryption, and disk forensics.",
                        "Motherboard and firmware: BIOS or UEFI firmware can become a low-level attack surface.",
                        "NIC: Enables network connectivity and introduces risks such as MAC spoofing and packet capture."
                    ],
                    keyTerms: ["CPU", "RAM", "SSD", "HDD", "NIC", "BIOS", "UEFI", "Firmware", "Motherboard"],
                    relatedTopicIds: ["operating-systems", "virtualization", "server-hardening"],
                    quizzes: [
                        QuizQuestion(
                            question: "Which component is most relevant to memory forensics investigations?",
                            answers: ["CPU", "RAM", "Hard Drive", "Power Supply"],
                            correctIndex: 1,
                            explanation: "RAM holds active process data and can contain evidence of malware, encryption keys, and user activity that disappears when power is lost."
                        ),
                        QuizQuestion(
                            question: "What hardware-level vulnerability affected Intel CPUs and could leak sensitive data?",
                            answers: ["Heartbleed", "Spectre", "SQL Injection", "Cross-Site Scripting"],
                            correctIndex: 1,
                            explanation: "Spectre and Meltdown are CPU speculative-execution vulnerabilities that can leak sensitive data from memory."
                        )
                    ]
                ),
                Topic(
                    id: "operating-systems",
                    title: "Operating Systems",
                    minutes: 15,
                    difficulty: 1,
                    overview: "Operating systems manage hardware resources and provide services to applications. The three major OS families in enterprise environments are Windows, Linux, and macOS, each with distinct security models, administration tools, and use cases.",
                    workplaceUse: "Your teams will work across multiple OS platforms. Windows dominates enterprise desktops and Active Directory environments. Linux runs most servers, cloud infrastructure, and security tools. Understanding OS differences helps you plan cross-platform projects, estimate training needs, and assess compatibility risks.",
                    deepDive: [
                        "Windows: Dominant in enterprise desktop environments, commonly paired with Active Directory, PowerShell, Defender, BitLocker, Registry, and Event Logs.",
                        "Linux: Common across servers, cloud platforms, and security tooling. Administration often uses shells, file permissions, package managers, and service daemons.",
                        "macOS: Unix-based and common in creative and development teams, with controls such as Gatekeeper, FileVault, and XProtect.",
                        "Kernel: The OS core that manages hardware and privileges. Kernel vulnerabilities can cause critical privilege escalation.",
                        "File systems: NTFS, ext4, and APFS each have different permission models and forensic artifacts."
                    ],
                    keyTerms: ["Kernel", "File System", "Process", "Registry", "Permissions", "Shell", "GUI", "CLI", "Daemon", "Service"],
                    relatedTopicIds: ["hardware-basics", "linux-administration", "active-directory"],
                    quizzes: [
                        QuizQuestion(
                            question: "Which operating system is most commonly used for enterprise identity management via Active Directory?",
                            answers: ["Linux", "macOS", "Windows", "FreeBSD"],
                            correctIndex: 2,
                            explanation: "Windows Server with Active Directory is the dominant enterprise identity and access management platform."
                        ),
                        QuizQuestion(
                            question: "What Linux distribution is specifically designed for penetration testing and security research?",
                            answers: ["Ubuntu", "CentOS", "Kali Linux", "Red Hat"],
                            correctIndex: 2,
                            explanation: "Kali Linux comes pre-loaded with many security and penetration testing tools."
                        )
                    ]
                ),
                Topic(
                    id: "virtualization",
                    title: "Virtualization & Containers",
                    minutes: 10,
                    difficulty: 2,
                    overview: "Virtualization allows multiple operating systems to run on a single physical machine using hypervisors. Containers provide lightweight, isolated environments for applications. Both are foundational to modern infrastructure and cloud computing.",
                    workplaceUse: "Virtualization projects involve capacity planning, licensing costs, and migration timelines. Container projects move faster but require different security considerations. Understanding this helps you scope infrastructure and cloud delivery work accurately.",
                    deepDive: [
                        "Type 1 hypervisors run directly on hardware and are common in data centers, including platforms such as VMware ESXi and Microsoft Hyper-V.",
                        "Type 2 hypervisors run on top of a host operating system and are common for development and testing.",
                        "Containers package applications with dependencies and are lighter than virtual machines because they share the host kernel.",
                        "Security implications include VM escape, container breakout, hypervisor vulnerabilities, snapshot governance, and network isolation.",
                        "Use cases include server consolidation, disaster recovery, development environments, malware sandboxing, and cloud infrastructure."
                    ],
                    keyTerms: ["Hypervisor", "VM", "Container", "Docker", "Kubernetes", "Snapshot", "vMotion", "Orchestration"],
                    relatedTopicIds: ["cloud-models", "server-hardening", "operating-systems"],
                    quizzes: [
                        QuizQuestion(
                            question: "What is the key difference between a Type 1 and Type 2 hypervisor?",
                            answers: ["Type 1 is free, Type 2 is paid", "Type 1 runs on bare metal, Type 2 runs on a host OS", "Type 1 is for containers, Type 2 is for VMs", "There is no difference"],
                            correctIndex: 1,
                            explanation: "Type 1 hypervisors run directly on hardware, while Type 2 hypervisors run as software on an existing operating system."
                        )
                    ]
                ),
                Topic(
                    id: "troubleshooting",
                    title: "Troubleshooting Methodology",
                    minutes: 8,
                    difficulty: 1,
                    overview: "Systematic troubleshooting helps teams identify, diagnose, and resolve technical issues without jumping to unsupported conclusions. A structured model improves incident communication and reduces wasted effort.",
                    workplaceUse: "When incidents occur, teams follow troubleshooting methodologies. Understanding the steps helps you set realistic timelines, ask better status questions, identify escalation points, and structure post-incident reviews.",
                    deepDive: [
                        "Identify the problem: Gather information, question users, identify symptoms, and determine scope.",
                        "Establish a theory: Consider multiple causes, use models such as OSI for network issues, and check simple causes first.",
                        "Test the theory: Confirm or eliminate possible causes through controlled testing.",
                        "Establish and implement a plan: Document the fix, assess impact, plan the change window, and execute safely.",
                        "Verify and document: Confirm the fix works, test related systems, record root cause, and capture lessons learned."
                    ],
                    keyTerms: ["Root Cause Analysis", "Escalation", "Change Management", "Incident", "Workaround", "Known Error", "Problem Management"],
                    relatedTopicIds: ["incident-response", "operating-systems", "network-troubleshooting"],
                    quizzes: [
                        QuizQuestion(
                            question: "What is the first step in the CompTIA troubleshooting methodology?",
                            answers: ["Establish a theory", "Implement the solution", "Identify the problem", "Document findings"],
                            correctIndex: 2,
                            explanation: "Always start by identifying and understanding the problem before jumping to solutions."
                        )
                    ]
                )
            ],
            capstone: "Create an asset and platform dependency map for a small business unit."
        ),
        Domain(
            id: "networking",
            title: "Networking",
            symbol: "network",
            colorHex: "#06b6d4",
            summary: "OSI/TCP-IP, addressing, routing, switching, DNS, DHCP, firewalls, VPNs, and segmentation.",
            stage: "Foundation",
            topics: [
                Topic(
                    id: "osi-tcpip",
                    title: "OSI & TCP/IP Models",
                    minutes: 15,
                    difficulty: 1,
                    overview: "The OSI model is a 7-layer conceptual framework for understanding how data moves across networks. The TCP/IP model is the practical 4-layer implementation used on the internet. Together, they provide the vocabulary for network communication.",
                    workplaceUse: "When your network team says the issue is at Layer 3, they usually mean routing or IP addressing. When they say Layer 7 attack, it targets the application itself. Understanding layers helps you route ownership and assess severity quickly.",
                    deepDive: [
                        "Layer 7 - Application: HTTP, HTTPS, DNS, FTP, SMTP, and SSH. Users and applications interact here, and attacks include SQL injection, XSS, and phishing.",
                        "Layer 4 - Transport: TCP is reliable and ordered, while UDP is fast and connectionless. Ports identify services, and SYN floods target this layer.",
                        "Layer 3 - Network: IP addressing and routing between networks. Routers operate here, and risks include IP spoofing and routing attacks.",
                        "Layer 2 - Data Link: MAC addresses, switches, frames, ARP spoofing, and VLAN hopping.",
                        "TCP/IP maps OSI layers into Application, Transport, Internet, and Network Access layers for practical implementation."
                    ],
                    keyTerms: ["OSI", "TCP/IP", "Layer", "Encapsulation", "Protocol", "PDU", "Frame", "Packet", "Segment"],
                    relatedTopicIds: ["ip-addressing", "protocols-ports", "network-attacks"],
                    quizzes: [
                        QuizQuestion(
                            question: "At which OSI layer do routers primarily operate?",
                            answers: ["Layer 2 - Data Link", "Layer 3 - Network", "Layer 4 - Transport", "Layer 7 - Application"],
                            correctIndex: 1,
                            explanation: "Routers operate at Layer 3, making forwarding decisions based on IP addresses."
                        ),
                        QuizQuestion(
                            question: "A DDoS SYN flood attack targets which OSI layer?",
                            answers: ["Layer 3", "Layer 4", "Layer 5", "Layer 7"],
                            correctIndex: 1,
                            explanation: "SYN floods exploit the TCP three-way handshake at Layer 4 and overwhelm connection handling."
                        )
                    ]
                ),
                Topic(
                    id: "ip-addressing",
                    title: "IP Addressing & Subnetting",
                    minutes: 18,
                    difficulty: 2,
                    overview: "IP addresses are unique identifiers for devices on a network. IPv4 uses 32-bit addresses, while IPv6 uses 128-bit addresses. Subnetting divides networks into smaller segments for security, performance, and management.",
                    workplaceUse: "Network segmentation is a key security control. New subnets can require firewall rules, routing changes, test plans, and stakeholder coordination, so IP address planning is critical for infrastructure projects.",
                    deepDive: [
                        "IPv4 uses 32-bit addresses and common private ranges such as 10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16.",
                        "IPv6 uses 128-bit addresses and provides a much larger address space, although IPv4 remains common in many environments.",
                        "Subnet masks define the network and host portions of an address; CIDR notation such as /24 or /16 communicates network size.",
                        "NAT maps private addresses to public addresses and allows many internal devices to share public connectivity.",
                        "DHCP automatically assigns IP configuration, but DHCP starvation or rogue DHCP services can disrupt or redirect traffic."
                    ],
                    keyTerms: ["IPv4", "IPv6", "Subnet", "CIDR", "NAT", "DHCP", "Gateway", "Broadcast", "Unicast", "Multicast"],
                    relatedTopicIds: ["osi-tcpip", "routing-switching", "firewalls-vpns"],
                    quizzes: [
                        QuizQuestion(
                            question: "Which private IP range provides the most host addresses?",
                            answers: ["192.168.0.0/16", "172.16.0.0/12", "10.0.0.0/8", "169.254.0.0/16"],
                            correctIndex: 2,
                            explanation: "10.0.0.0/8 provides the largest private IPv4 range among the listed options."
                        )
                    ]
                ),
                Topic(
                    id: "protocols-ports",
                    title: "Protocols & Ports",
                    minutes: 12,
                    difficulty: 1,
                    overview: "Network protocols are standardized rules for communication. Ports are numbered endpoints that identify specific services. Understanding common protocols and ports is essential for firewall configuration, traffic analysis, and threat detection.",
                    workplaceUse: "When a security team says to block port 3389, they are preventing Remote Desktop exposure. When they discuss encrypted traffic on 443, they mean HTTPS. Knowing key ports helps you understand change requests and exposure risks.",
                    deepDive: [
                        "Well-known ports include HTTP 80, HTTPS 443, FTP 21, SSH 22, Telnet 23, SMTP 25, DNS 53, DHCP 67/68, LDAP 389, and RDP 3389.",
                        "TCP is reliable and connection-oriented, while UDP is faster and connectionless for services such as DNS, streaming, gaming, and VoIP.",
                        "HTTP and HTTPS carry web traffic; HTTPS adds TLS encryption and normally uses port 443.",
                        "DNS translates domain names to IP addresses and can be abused through poisoning, spoofing, or tunneling.",
                        "SSH encrypts remote administration traffic, while Telnet is plaintext and should not be used in production."
                    ],
                    keyTerms: ["TCP", "UDP", "Port", "Protocol", "Socket", "Handshake", "Stateful", "Stateless"],
                    relatedTopicIds: ["osi-tcpip", "firewalls-vpns", "network-monitoring"],
                    quizzes: [
                        QuizQuestion(
                            question: "Which port does HTTPS use by default?",
                            answers: ["80", "443", "8080", "22"],
                            correctIndex: 1,
                            explanation: "HTTPS uses port 443 by default, while unencrypted HTTP commonly uses port 80."
                        ),
                        QuizQuestion(
                            question: "Why should Telnet never be used in a production environment?",
                            answers: ["It is too slow", "It transmits data in plaintext including passwords", "It only works on Linux", "It requires too much bandwidth"],
                            correctIndex: 1,
                            explanation: "Telnet sends credentials and commands in plaintext. SSH should be used instead because it encrypts communication."
                        )
                    ]
                ),
                Topic(
                    id: "routing-switching",
                    title: "Routing & Switching",
                    minutes: 14,
                    difficulty: 2,
                    overview: "Switches connect devices within a network using MAC addresses. Routers connect different networks using IP addresses. Together they form the backbone of enterprise network infrastructure.",
                    workplaceUse: "Network infrastructure projects often involve switch upgrades, router configurations, and VLAN implementations. These changes require maintenance windows, blast-radius assessment, and coordination between network and security teams.",
                    deepDive: [
                        "Switches forward frames based on MAC addresses and can be managed or unmanaged depending on enterprise requirements.",
                        "VLANs segment a physical switch into logical networks and are important for isolating departments, guest networks, and IoT devices.",
                        "Routers forward packets between networks based on IP addresses, routing tables, and default gateways.",
                        "Routing protocols such as OSPF and BGP determine paths, and routing attacks can redirect or disrupt traffic.",
                        "Spanning Tree Protocol helps prevent loops in switched networks, but misconfiguration or attacks can cause outages."
                    ],
                    keyTerms: ["Switch", "Router", "VLAN", "MAC Address", "Routing Table", "Default Gateway", "OSPF", "BGP", "STP", "Trunk"],
                    relatedTopicIds: ["osi-tcpip", "ip-addressing", "network-security-arch"],
                    quizzes: [
                        QuizQuestion(
                            question: "What is the primary security benefit of implementing VLANs?",
                            answers: ["Faster internet speed", "Network segmentation and isolation", "Cheaper hardware costs", "Better WiFi signal"],
                            correctIndex: 1,
                            explanation: "VLANs logically segment network traffic and can limit the blast radius of incidents."
                        )
                    ]
                ),
                Topic(
                    id: "firewalls-vpns",
                    title: "Firewalls & VPNs",
                    minutes: 14,
                    difficulty: 2,
                    overview: "Firewalls control traffic flow between networks based on rules. VPNs create encrypted tunnels over public networks. Together they form core perimeter, segmentation, and secure remote-access controls.",
                    workplaceUse: "Firewall change requests are common in security projects and need review, approval, and testing. VPN projects require capacity planning, user onboarding, split-tunnel decisions, and careful rollback planning.",
                    deepDive: [
                        "Stateless firewalls filter packets individually by source, destination, port, and protocol. They are fast but have limited context.",
                        "Stateful firewalls track connection state and understand that response packets belong to an established connection.",
                        "Next-generation firewalls add application awareness, intrusion prevention, deep packet inspection, and sometimes SSL inspection.",
                        "Web application firewalls protect web applications from Layer 7 and OWASP Top 10 style attacks.",
                        "VPN types include site-to-site, remote access, SSL VPN, IPSec, OpenVPN, and WireGuard-style modern tunnels."
                    ],
                    keyTerms: ["Firewall", "VPN", "ACL", "Rule", "Stateful", "NGFW", "WAF", "IPSec", "DMZ", "Split Tunnel"],
                    relatedTopicIds: ["protocols-ports", "network-security-arch", "zero-trust"],
                    quizzes: [
                        QuizQuestion(
                            question: "What advantage does a Next-Generation Firewall have over a traditional stateful firewall?",
                            answers: ["It is cheaper", "Application-layer awareness and deep packet inspection", "It does not need rules", "It only works with VPNs"],
                            correctIndex: 1,
                            explanation: "NGFWs can identify and control applications, inspect traffic deeply, and integrate additional prevention capabilities."
                        )
                    ]
                ),
                Topic(
                    id: "dns-dhcp",
                    title: "DNS & DHCP",
                    minutes: 10,
                    difficulty: 1,
                    overview: "DNS translates human-readable domain names to IP addresses. DHCP automatically assigns IP configurations to devices. Both are critical infrastructure services and frequent attack targets.",
                    workplaceUse: "DNS outages can disrupt entire organizations even when servers are healthy, and DHCP issues can prevent users from connecting. These invisible services are critical dependencies for go-live planning and incident response.",
                    deepDive: [
                        "DNS hierarchy flows from root servers to TLDs, authoritative servers, recursive resolvers, and local caches.",
                        "DNS records include A, AAAA, CNAME, MX, TXT, and NS records, each supporting different infrastructure needs.",
                        "DNS attacks include spoofing, poisoning, tunneling, typosquatting, and DDoS attacks against name services.",
                        "DHCP follows the DORA process: Discover, Offer, Request, and Acknowledge.",
                        "DNS security controls include DNSSEC, encrypted DNS transports, DNS filtering, and careful TTL planning."
                    ],
                    keyTerms: ["DNS", "DHCP", "A Record", "CNAME", "MX", "TTL", "Resolver", "Zone", "DORA", "Lease"],
                    relatedTopicIds: ["ip-addressing", "protocols-ports", "network-attacks"],
                    quizzes: [
                        QuizQuestion(
                            question: "What does DNS tunneling allow an attacker to do?",
                            answers: ["Speed up DNS queries", "Exfiltrate data through DNS queries", "Block all DNS traffic", "Encrypt website traffic"],
                            correctIndex: 1,
                            explanation: "DNS tunneling encodes data inside DNS queries and responses, allowing exfiltration or command-and-control over a commonly allowed protocol."
                        )
                    ]
                ),
                Topic(
                    id: "wireless-networking",
                    title: "Wireless Networking",
                    minutes: 11,
                    difficulty: 2,
                    overview: "Wireless networks use radio frequencies to transmit data without physical cables. WiFi, Bluetooth, and cellular introduce unique security challenges because radio signals can extend beyond physical boundaries.",
                    workplaceUse: "Wireless projects involve site surveys, access point placement, security protocol selection, guest isolation, and BYOD policy decisions. Wireless can become the weakest link if coverage and security are not planned together.",
                    deepDive: [
                        "WiFi generations such as 802.11a/b/g/n/ac/ax improve speed, range, and capacity across different environments.",
                        "Security protocols evolved from broken WEP to WPA, WPA2, and WPA3; production networks should avoid legacy weak options.",
                        "Authentication can use pre-shared keys for small environments or 802.1X with RADIUS for enterprise access.",
                        "Wireless attacks include evil twin access points, deauthentication, KRACK-style weaknesses, wardriving, and packet sniffing.",
                        "Best practices include WPA3 or WPA2-Enterprise, disabling WPS, segmenting IoT, and performing site surveys before deployment."
                    ],
                    keyTerms: ["WiFi", "SSID", "WPA2", "WPA3", "802.1X", "RADIUS", "Access Point", "Evil Twin", "Deauth"],
                    relatedTopicIds: ["protocols-ports", "firewalls-vpns", "network-security-arch"],
                    quizzes: [
                        QuizQuestion(
                            question: "Which wireless security protocol should never be used due to known vulnerabilities?",
                            answers: ["WPA3", "WPA2-Enterprise", "WEP", "802.1X"],
                            correctIndex: 2,
                            explanation: "WEP has been thoroughly broken and can be cracked quickly, so modern networks should use WPA2 or WPA3."
                        )
                    ]
                )
            ],
            capstone: "Design a secure branch-office network with trust boundaries and approved traffic flows."
        ),
        Domain(
            id: "security-operations",
            title: "Security Operations",
            symbol: "shield.lefthalf.filled",
            colorHex: "#22c55e",
            summary: "Detection, alert triage, incident response, evidence handling, and operational improvement.",
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
                        explanation: "Lessons learned should improve controls, playbooks, training, and architecture."
                    )
                ),
                Topic(
                    id: "identity-triage",
                    title: "Identity Triage",
                    minutes: 16,
                    difficulty: 2,
                    overview: "Investigate suspicious sign-ins, token exposure, OAuth grants, and privileged account anomalies.",
                    workplaceUse: "Supports containment decisions that preserve evidence while reducing account and business impact.",
                    keyTerms: ["MFA", "OAuth", "Token", "Session", "Privilege"],
                    quiz: QuizQuestion(
                        question: "What should be considered beyond a password reset after OAuth abuse?",
                        answers: ["Screen brightness", "Grant revocation", "Printer queue", "Keyboard layout"],
                        correctIndex: 1,
                        explanation: "Malicious grants and active sessions can persist beyond a password reset."
                    )
                )
            ],
            capstone: "Draft an incident decision log for a suspected credential compromise."
        ),
        Domain(
            id: "grc",
            title: "GRC",
            symbol: "checklist.checked",
            colorHex: "#a855f7",
            summary: "Governance, risk, compliance, controls, evidence, policy, and executive reporting.",
            stage: "Practitioner",
            topics: [
                Topic(
                    id: "risk-treatment",
                    title: "Risk Treatment",
                    minutes: 14,
                    difficulty: 2,
                    overview: "Choose between accepting, mitigating, transferring, and avoiding risk based on likelihood and impact.",
                    workplaceUse: "Connects technical findings to business decisions, ownership, review dates, and residual risk.",
                    keyTerms: ["Accept", "Mitigate", "Transfer", "Avoid"],
                    quiz: QuizQuestion(
                        question: "Which risk treatment reduces likelihood or impact through added controls?",
                        answers: ["Accept", "Mitigate", "Transfer", "Avoid"],
                        correctIndex: 1,
                        explanation: "Mitigation reduces likelihood, impact, or both through controls."
                    )
                )
            ],
            capstone: "Write a risk decision memo with owner, treatment, residual risk, and review date."
        ),
        Domain(
            id: "cloud-security",
            title: "Cloud Security",
            symbol: "icloud.fill",
            colorHex: "#f59e0b",
            summary: "Shared responsibility, IAM, storage security, and cloud security posture.",
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
                        question: "In an Infrastructure as a Service (IaaS) model, who is primarily responsible for securing the guest operating system?",
                        answers: ["The Cloud Provider", "The Customer", "Third-party Auditors", "Internet Service Providers"],
                        correctIndex: 1,
                        explanation: "In IaaS, the provider secures the physical hardware, but the customer must patch and secure the guest OS."
                    )
                ),
                Topic(
                    id: "cloud-iam",
                    title: "Cloud IAM & Least Privilege",
                    minutes: 15,
                    difficulty: 2,
                    overview: "Explore how Identity and Access Management (IAM) governs access to cloud resources.",
                    workplaceUse: "Used when designing access roles for developers, CI/CD pipelines, and external applications.",
                    keyTerms: ["IAM", "Role", "Policy", "Least Privilege"],
                    quiz: QuizQuestion(
                        question: "What is the best practice for granting a CI/CD pipeline access to deploy cloud resources?",
                        answers: ["Use the root account credentials", "Assign a dedicated service role with scoped permissions", "Make the resources public during deployment", "Share an administrator user's password"],
                        correctIndex: 1,
                        explanation: "A dedicated service role with least privilege ensures the pipeline can only perform authorized actions."
                    )
                )
            ],
            capstone: "Map the security responsibilities for a newly proposed SaaS application rollout."
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
            id: "s3-bucket-exposure",
            title: "Unsecured Cloud Storage Exposure",
            summary: "A developer temporarily made a cloud storage bucket public to troubleshoot a CI/CD pipeline issue, exposing customer profile data.",
            evidence: [
                EvidenceItem(title: "CloudTrail Logs", detail: "Bucket policy updated to 'PublicRead' by a service role."),
                EvidenceItem(title: "Billing Alerts", detail: "Spike in outbound data transfer from the storage bucket."),
                EvidenceItem(title: "Support Ticket", detail: "Developer notes stating 'testing public access for build pipeline'.")
            ],
            actions: [
                ScenarioAction(
                    id: "immediate-revert",
                    label: "Revert the bucket policy to private immediately and review access logs.",
                    score: 95,
                    feedback: "Excellent decision: Stops the active data leak first, then moves to investigate the impact.",
                    development: "The developer complains that the CI/CD pipeline is now failing and blocking a critical release.",
                    followUps: [
                        FollowUpAction(id: "create-service-role", label: "Create a dedicated IAM role for the pipeline with access to the private bucket.", consequence: "Secures the process long-term, though it takes a bit more time right now.", recommended: true),
                        FollowUpAction(id: "temporary-public", label: "Make it public again just for the 10-minute release window.", consequence: "Re-exposes customer data to the public internet.", recommended: false)
                    ]
                ),
                ScenarioAction(
                    id: "contact-developer",
                    label: "Message the developer and wait for them to fix their own bucket.",
                    score: 40,
                    feedback: "Poor decision: Customer data is actively exposed. Containment must happen immediately.",
                    development: "The developer is in a different timezone and won't be online for 6 hours.",
                    followUps: [
                        FollowUpAction(id: "override-policy", label: "Override the developer and secure the bucket immediately.", consequence: "The leak is finally stopped, but data was exposed for hours.", recommended: true),
                        FollowUpAction(id: "wait-for-dev", label: "Wait for the developer to wake up.", consequence: "Severe data breach potential due to inaction.", recommended: false)
                    ]
                )
            ]
        )
    ]

    static let visualLessons: [VisualLesson] = [
        VisualLesson(id: "risk", title: "Risk treatment", summary: "Move likelihood and impact into an accountable decision.", prompts: ["Accept requires owner approval.", "Mitigate lowers likelihood or impact.", "Avoid removes the risky activity."]),
        VisualLesson(id: "threat", title: "Threat model canvas", summary: "Name assets, actors, entry points, boundaries, threats, and mitigations.", prompts: ["Start with the asset.", "Map the trust boundary.", "Write a verification prompt."]),
        VisualLesson(id: "cloud", title: "Cloud responsibility", summary: "Separate provider controls from customer-owned identity, data, and configuration.", prompts: ["IaaS leaves more to the customer.", "SaaS still requires identity and data governance.", "Shared does not mean ownerless."])
    ]

    static let diagnosticQuestions: [DiagnosticQuestion] = [
        DiagnosticQuestion(id: "it-1", domainId: "it-fundamentals", prompt: "How comfortable are you explaining CPU, RAM, storage, and firmware risk to a non-technical stakeholder?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "it-2", domainId: "it-fundamentals", prompt: "Can you identify which team owns a Windows, Linux, or macOS operational issue?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "it-3", domainId: "it-fundamentals", prompt: "Can you connect patching, endpoint hardening, and asset inventory to project risk?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "it-4", domainId: "it-fundamentals", prompt: "Can you read a basic infrastructure dependency map and spot missing ownership?", answers: diagnosticAnswers),
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
        DiagnosticQuestion(id: "cross-1", domainId: "security-operations", prompt: "Can you prioritize action when business pressure conflicts with containment?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "cross-2", domainId: "grc", prompt: "Can you explain every recommendation with a short 'why this next' reason?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "cloud-1", domainId: "cloud-security", prompt: "Can you confidently draw the line of responsibility between your team and the cloud provider?", answers: diagnosticAnswers),
        DiagnosticQuestion(id: "cloud-2", domainId: "cloud-security", prompt: "Are you comfortable configuring least-privilege IAM roles for a new service?", answers: diagnosticAnswers)
    ]

    private static let diagnosticAnswers = [
        DiagnosticAnswer(label: "Emerging", score: 20),
        DiagnosticAnswer(label: "Developing", score: 55),
        DiagnosticAnswer(label: "Ready", score: 90)
    ]
}

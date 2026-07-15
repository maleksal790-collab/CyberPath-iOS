// CyberPath Data Models and Content

export interface QuizQuestion {
  question: string;
  answers: string[];
  correctIndex: number;
  explanation: string;
}

export interface Topic {
  id: string;
  title: string;
  minutes: number;
  difficulty: number;
  overview: string;
  workplaceUse: string;
  deepDive: string[];
  keyTerms: string[];
  relatedTopicIds: string[];
  quizzes: QuizQuestion[];
}

export interface Domain {
  id: string;
  title: string;
  icon: string;
  colorHex: string;
  summary: string;
  stage: string;
  topics: Topic[];
  capstone: string;
}

export interface GlossaryTerm {
  id: string;
  term: string;
  definition: string;
  relatedDomainIds: string[];
}

export interface PortItem {
  port: number;
  protocol: string;
  description: string;
}

export interface FrameworkComparison {
  id: string;
  framework: string;
  scope: string;
  approach: string;
  structure: string;
  bestFor: string;
}

export interface SecurityMetric {
  id: string;
  metric: string;
  fullName: string;
  description: string;
  target: string;
  category: string;
}

export interface ToolCategory {
  id: string;
  category: string;
  tools: string[];
}

export interface Scenario {
  id: string;
  title: string;
  summary: string;
  evidence: { title: string; detail: string }[];
  actions: ScenarioAction[];
}

export interface ScenarioAction {
  id: string;
  label: string;
  score: number;
  feedback: string;
  development: string;
  followUps: { id: string; label: string; consequence: string; recommended: boolean }[];
}

export interface VisualLesson {
  id: string;
  title: string;
  summary: string;
  prompts: string[];
}

export interface DiagnosticQuestion {
  id: string;
  domainId: string;
  prompt: string;
  answers: { label: string; score: number }[];
}

// ===== CONTENT DATA =====

export const domains: Domain[] = [
  {
    id: "it-fundamentals",
    title: "IT Fundamentals",
    icon: "computer",
    colorHex: "#3b82f6",
    summary: "Hardware, operating systems, virtualization, identity, and core IT concepts.",
    stage: "Foundation",
    topics: [
      {
        id: "hardware-basics",
        title: "Hardware Components",
        minutes: 12,
        difficulty: 1,
        overview: "Understanding the physical components that make up computing systems: CPU, RAM, storage devices, motherboards, power supplies, and peripheral devices.",
        workplaceUse: "When your infrastructure team discusses hardware refresh cycles, capacity planning, or performance bottlenecks, understanding these components helps you assess timelines, budget requirements, and risk.",
        deepDive: [
          "CPU: The brain of the computer, measured in cores, clock speed, and architecture. Security relevance includes hardware-level vulnerabilities such as Spectre and Meltdown.",
          "RAM: Volatile memory for active processes. Security relevance includes memory forensics and attacks that target active memory.",
          "Storage: HDDs and SSDs support data at rest, secure destruction, encryption, and disk forensics.",
          "Motherboard and firmware: BIOS or UEFI firmware can become a low-level attack surface.",
          "NIC: Enables network connectivity and introduces risks such as MAC spoofing and packet capture."
        ],
        keyTerms: ["CPU", "RAM", "SSD", "HDD", "NIC", "BIOS", "UEFI", "Firmware", "Motherboard"],
        relatedTopicIds: ["operating-systems", "virtualization"],
        quizzes: [
          { question: "Which component is most relevant to memory forensics investigations?", answers: ["CPU", "RAM", "Hard Drive", "Power Supply"], correctIndex: 1, explanation: "RAM holds active process data and can contain evidence of malware, encryption keys, and user activity that disappears when power is lost." },
          { question: "What hardware-level vulnerability affected Intel CPUs and could leak sensitive data?", answers: ["Heartbleed", "Spectre", "SQL Injection", "Cross-Site Scripting"], correctIndex: 1, explanation: "Spectre and Meltdown are CPU speculative-execution vulnerabilities that can leak sensitive data from memory." }
        ]
      },
      {
        id: "operating-systems",
        title: "Operating Systems",
        minutes: 15,
        difficulty: 1,
        overview: "Operating systems manage hardware resources and provide services to applications. The three major OS families are Windows, Linux, and macOS.",
        workplaceUse: "Your teams will work across multiple OS platforms. Windows dominates enterprise desktops and Active Directory environments. Linux runs most servers and cloud infrastructure.",
        deepDive: [
          "Windows: Dominant in enterprise desktop environments, commonly paired with Active Directory, PowerShell, Defender, BitLocker.",
          "Linux: Common across servers, cloud platforms, and security tooling. Administration uses shells, file permissions, package managers.",
          "macOS: Unix-based with controls such as Gatekeeper, FileVault, and XProtect.",
          "Kernel: The OS core that manages hardware and privileges. Kernel vulnerabilities can cause critical privilege escalation.",
          "File systems: NTFS, ext4, and APFS each have different permission models and forensic artifacts."
        ],
        keyTerms: ["Kernel", "File System", "Process", "Registry", "Permissions", "Shell", "GUI", "CLI", "Daemon"],
        relatedTopicIds: ["hardware-basics", "virtualization"],
        quizzes: [
          { question: "Which OS is most commonly used for enterprise identity management via Active Directory?", answers: ["Linux", "macOS", "Windows", "FreeBSD"], correctIndex: 2, explanation: "Windows Server with Active Directory is the dominant enterprise identity and access management platform." },
          { question: "What Linux distribution is specifically designed for penetration testing?", answers: ["Ubuntu", "CentOS", "Kali Linux", "Red Hat"], correctIndex: 2, explanation: "Kali Linux comes pre-loaded with many security and penetration testing tools." }
        ]
      },
      {
        id: "virtualization",
        title: "Virtualization & Containers",
        minutes: 10,
        difficulty: 2,
        overview: "Virtualization allows multiple operating systems to run on a single physical machine. Containers provide lightweight, isolated environments for applications.",
        workplaceUse: "Virtualization projects involve capacity planning, licensing costs, and migration timelines. Container projects move faster but require different security considerations.",
        deepDive: [
          "Type 1 hypervisors run directly on hardware (VMware ESXi, Hyper-V).",
          "Type 2 hypervisors run on top of a host OS for development and testing.",
          "Containers package applications with dependencies and share the host kernel.",
          "Security implications include VM escape, container breakout, and hypervisor vulnerabilities.",
          "Use cases: server consolidation, disaster recovery, malware sandboxing, cloud infrastructure."
        ],
        keyTerms: ["Hypervisor", "VM", "Container", "Docker", "Kubernetes", "Snapshot", "Orchestration"],
        relatedTopicIds: ["operating-systems", "hardware-basics"],
        quizzes: [
          { question: "What is the key difference between a Type 1 and Type 2 hypervisor?", answers: ["Type 1 is free, Type 2 is paid", "Type 1 runs on bare metal, Type 2 runs on a host OS", "Type 1 is for containers, Type 2 is for VMs", "There is no difference"], correctIndex: 1, explanation: "Type 1 hypervisors run directly on hardware, while Type 2 run as software on an existing OS." }
        ]
      },
      {
        id: "troubleshooting",
        title: "Troubleshooting Methodology",
        minutes: 8,
        difficulty: 1,
        overview: "Systematic troubleshooting helps teams identify, diagnose, and resolve technical issues without jumping to unsupported conclusions.",
        workplaceUse: "When incidents occur, teams follow troubleshooting methodologies. Understanding the steps helps you set realistic timelines and structure post-incident reviews.",
        deepDive: [
          "Identify the problem: Gather information, question users, identify symptoms, determine scope.",
          "Establish a theory: Consider multiple causes, check simple causes first.",
          "Test the theory: Confirm or eliminate possible causes through controlled testing.",
          "Establish and implement a plan: Document the fix, assess impact, execute safely.",
          "Verify and document: Confirm the fix works, record root cause, capture lessons learned."
        ],
        keyTerms: ["Root Cause Analysis", "Escalation", "Change Management", "Incident", "Workaround"],
        relatedTopicIds: ["operating-systems"],
        quizzes: [
          { question: "What is the first step in the CompTIA troubleshooting methodology?", answers: ["Establish a theory", "Implement the solution", "Identify the problem", "Document findings"], correctIndex: 2, explanation: "Always start by identifying and understanding the problem before jumping to solutions." }
        ]
      }
    ],
    capstone: "Create an asset and platform dependency map for a small business unit."
  },
  {
    id: "networking",
    title: "Networking",
    icon: "wifi",
    colorHex: "#06b6d4",
    summary: "OSI/TCP-IP, addressing, routing, switching, DNS, DHCP, firewalls, VPNs, and segmentation.",
    stage: "Foundation",
    topics: [
      {
        id: "osi-tcpip",
        title: "OSI & TCP/IP Models",
        minutes: 15,
        difficulty: 1,
        overview: "The OSI model is a 7-layer conceptual framework for understanding how data moves across networks. The TCP/IP model is the practical 4-layer implementation.",
        workplaceUse: "When your network team says the issue is at Layer 3, they mean routing or IP addressing. Layer 7 attack targets the application itself.",
        deepDive: [
          "Layer 7 - Application: HTTP, HTTPS, DNS, FTP, SMTP. Attacks include SQL injection, XSS, phishing.",
          "Layer 4 - Transport: TCP (reliable) and UDP (fast). Ports identify services. SYN floods target this layer.",
          "Layer 3 - Network: IP addressing and routing. Risks include IP spoofing and routing attacks.",
          "Layer 2 - Data Link: MAC addresses, switches, ARP spoofing, VLAN hopping.",
          "TCP/IP maps OSI into Application, Transport, Internet, and Network Access layers."
        ],
        keyTerms: ["OSI", "TCP/IP", "Layer", "Encapsulation", "Protocol", "PDU", "Frame", "Packet", "Segment"],
        relatedTopicIds: ["ip-addressing", "firewalls-vpns"],
        quizzes: [
          { question: "At which OSI layer do routers primarily operate?", answers: ["Layer 2 - Data Link", "Layer 3 - Network", "Layer 4 - Transport", "Layer 7 - Application"], correctIndex: 1, explanation: "Routers operate at Layer 3, making forwarding decisions based on IP addresses." },
          { question: "A DDoS SYN flood attack targets which OSI layer?", answers: ["Layer 3", "Layer 4", "Layer 5", "Layer 7"], correctIndex: 1, explanation: "SYN floods exploit the TCP three-way handshake at Layer 4." }
        ]
      },
      {
        id: "ip-addressing",
        title: "IP Addressing & Subnetting",
        minutes: 18,
        difficulty: 2,
        overview: "IP addresses are unique identifiers for devices on a network. IPv4 uses 32-bit addresses. Subnetting divides networks into smaller segments.",
        workplaceUse: "Network segmentation is a key security control. New subnets require firewall rules, routing changes, and stakeholder coordination.",
        deepDive: [
          "IPv4 uses 32-bit addresses with private ranges: 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16.",
          "IPv6 uses 128-bit addresses providing a much larger address space.",
          "Subnet masks define network and host portions; CIDR notation like /24 communicates network size.",
          "NAT maps private addresses to public addresses for internet connectivity.",
          "DHCP automatically assigns IP configuration; rogue DHCP can disrupt traffic."
        ],
        keyTerms: ["IPv4", "IPv6", "Subnet", "CIDR", "NAT", "DHCP", "Gateway", "Broadcast"],
        relatedTopicIds: ["osi-tcpip", "firewalls-vpns"],
        quizzes: [
          { question: "How many usable host addresses are in a /24 subnet?", answers: ["256", "254", "255", "128"], correctIndex: 1, explanation: "A /24 subnet has 256 total addresses minus network and broadcast = 254 usable hosts." }
        ]
      },
      {
        id: "firewalls-vpns",
        title: "Firewalls & VPNs",
        minutes: 12,
        difficulty: 2,
        overview: "Firewalls control network traffic based on rules. VPNs create encrypted tunnels for secure remote access and site-to-site connectivity.",
        workplaceUse: "Firewall rule changes require change management. VPN capacity planning affects remote workforce productivity and security posture.",
        deepDive: [
          "Stateless firewalls filter packets individually based on source/destination IP and port.",
          "Stateful firewalls track connection state and make decisions based on traffic context.",
          "Next-gen firewalls (NGFW) add application awareness, IPS, and deep packet inspection.",
          "Site-to-site VPNs connect office networks; remote access VPNs connect individual users.",
          "Zero Trust Network Access (ZTNA) is replacing traditional VPNs in many organizations."
        ],
        keyTerms: ["Firewall", "ACL", "VPN", "IPSec", "SSL/TLS", "ZTNA", "DMZ", "NAT"],
        relatedTopicIds: ["osi-tcpip", "ip-addressing"],
        quizzes: [
          { question: "What advantage does a stateful firewall have over a stateless one?", answers: ["It's faster", "It tracks connection state", "It's cheaper", "It blocks all traffic"], correctIndex: 1, explanation: "Stateful firewalls track the state of connections and can make more intelligent filtering decisions." }
        ]
      },
      {
        id: "dns-dhcp",
        title: "DNS & DHCP",
        minutes: 10,
        difficulty: 1,
        overview: "DNS translates domain names to IP addresses. DHCP automatically assigns network configuration to devices. Both are critical infrastructure services.",
        workplaceUse: "DNS outages affect all internet-facing services. DNS poisoning can redirect users to malicious sites. DHCP issues cause connectivity problems.",
        deepDive: [
          "DNS hierarchy: root servers, TLD servers, authoritative servers, recursive resolvers.",
          "DNS record types: A, AAAA, CNAME, MX, TXT, NS, SOA, PTR.",
          "DNS attacks: cache poisoning, DNS tunneling, typosquatting, DNS amplification DDoS.",
          "DHCP lease process: Discover, Offer, Request, Acknowledge (DORA).",
          "DHCP security: rogue servers, starvation attacks, snooping as a defense."
        ],
        keyTerms: ["DNS", "DHCP", "A Record", "CNAME", "MX", "Resolver", "Zone", "Lease"],
        relatedTopicIds: ["osi-tcpip", "ip-addressing"],
        quizzes: [
          { question: "What is the correct order of the DHCP lease process?", answers: ["Offer, Discover, Request, Acknowledge", "Discover, Offer, Request, Acknowledge", "Request, Discover, Offer, Acknowledge", "Acknowledge, Discover, Offer, Request"], correctIndex: 1, explanation: "DHCP follows DORA: Discover, Offer, Request, Acknowledge." }
        ]
      }
    ],
    capstone: "Design a segmented network topology for a small office with DMZ, internal, and guest zones."
  },
  {
    id: "security-operations",
    title: "Security Operations",
    icon: "shield",
    colorHex: "#8b5cf6",
    summary: "Threat detection, incident response, SIEM, log analysis, vulnerability management, and SOC operations.",
    stage: "Core",
    topics: [
      {
        id: "incident-response",
        title: "Incident Response",
        minutes: 15,
        difficulty: 2,
        overview: "Incident response is the structured approach to handling security breaches and cyberattacks. The goal is to limit damage, reduce recovery time, and prevent future incidents.",
        workplaceUse: "IR plans define roles, communication chains, and escalation paths. Understanding IR helps you coordinate cross-team responses and set stakeholder expectations.",
        deepDive: [
          "Preparation: Policies, tools, training, communication plans, and playbooks before incidents occur.",
          "Detection & Analysis: Identifying indicators of compromise, triaging alerts, determining scope.",
          "Containment: Short-term (isolate) and long-term (patch, rebuild) containment strategies.",
          "Eradication & Recovery: Remove threat, restore systems, verify integrity, monitor for recurrence.",
          "Post-Incident: Lessons learned, timeline documentation, process improvements, evidence preservation."
        ],
        keyTerms: ["IOC", "Playbook", "Containment", "Eradication", "Recovery", "Lessons Learned", "CSIRT"],
        relatedTopicIds: ["siem-logging", "threat-detection"],
        quizzes: [
          { question: "What is the primary goal of the containment phase?", answers: ["Delete malware", "Limit damage spread", "Notify customers", "Update firewall rules"], correctIndex: 1, explanation: "Containment aims to limit the spread of damage while maintaining evidence for investigation." }
        ]
      },
      {
        id: "siem-logging",
        title: "SIEM & Log Analysis",
        minutes: 12,
        difficulty: 2,
        overview: "Security Information and Event Management (SIEM) systems collect, correlate, and analyze log data from across the environment to detect threats and support investigations.",
        workplaceUse: "SIEM deployments require log source onboarding, rule tuning, and alert triage processes. Understanding SIEM helps scope detection engineering projects.",
        deepDive: [
          "Log sources: firewalls, endpoints, servers, applications, cloud services, identity systems.",
          "Correlation rules: combine multiple events to detect attack patterns and reduce false positives.",
          "Alert triage: prioritize, investigate, escalate or close alerts based on context and risk.",
          "Retention policies: balance storage costs with investigation and compliance needs.",
          "Common platforms: Splunk, Microsoft Sentinel, Elastic SIEM, IBM QRadar."
        ],
        keyTerms: ["SIEM", "Log", "Correlation", "Alert", "Triage", "Retention", "Normalization"],
        relatedTopicIds: ["incident-response", "threat-detection"],
        quizzes: [
          { question: "What is the primary purpose of correlation rules in a SIEM?", answers: ["Store logs efficiently", "Combine events to detect attack patterns", "Encrypt log data", "Delete old logs"], correctIndex: 1, explanation: "Correlation rules combine multiple events to identify attack patterns that individual events might not reveal." }
        ]
      },
      {
        id: "threat-detection",
        title: "Threat Detection",
        minutes: 14,
        difficulty: 2,
        overview: "Threat detection involves identifying malicious activity through monitoring, analysis, and intelligence. It combines automated tools with human analysis.",
        workplaceUse: "Detection engineering requires understanding attacker techniques, data sources, and detection logic. This helps prioritize detection coverage and measure SOC effectiveness.",
        deepDive: [
          "Signature-based: matches known patterns (fast but misses novel threats).",
          "Behavioral/anomaly-based: detects deviations from baseline (catches unknowns but more false positives).",
          "Threat intelligence: external feeds of IOCs, TTPs, and actor profiles inform detection priorities.",
          "MITRE ATT&CK: framework mapping adversary techniques to detection opportunities.",
          "Threat hunting: proactive hypothesis-driven search for threats that evade automated detection."
        ],
        keyTerms: ["IOC", "TTP", "MITRE ATT&CK", "Threat Hunting", "Signature", "Anomaly", "Baseline"],
        relatedTopicIds: ["siem-logging", "incident-response"],
        quizzes: [
          { question: "What framework maps adversary techniques to detection opportunities?", answers: ["NIST CSF", "ISO 27001", "MITRE ATT&CK", "CIS Controls"], correctIndex: 2, explanation: "MITRE ATT&CK catalogs adversary tactics, techniques, and procedures to help defenders build detection coverage." }
        ]
      },
      {
        id: "vulnerability-management",
        title: "Vulnerability Management",
        minutes: 10,
        difficulty: 2,
        overview: "Vulnerability management is the continuous process of identifying, classifying, remediating, and mitigating security vulnerabilities in systems and software.",
        workplaceUse: "Vulnerability scanning generates findings that need prioritization. Understanding CVSS scores and risk context helps teams focus on what matters most.",
        deepDive: [
          "Scanning: automated tools discover vulnerabilities across networks, systems, and applications.",
          "CVSS scoring: standardized severity rating (0-10) based on exploitability and impact.",
          "Prioritization: combine CVSS with asset criticality, exposure, and threat intelligence.",
          "Remediation: patching, configuration changes, compensating controls, or risk acceptance.",
          "Metrics: mean time to remediate (MTTR), scan coverage, SLA compliance."
        ],
        keyTerms: ["CVSS", "CVE", "Patch", "Scan", "Remediation", "Risk Acceptance", "SLA"],
        relatedTopicIds: ["incident-response", "threat-detection"],
        quizzes: [
          { question: "What does CVSS measure?", answers: ["Network speed", "Vulnerability severity", "User satisfaction", "System uptime"], correctIndex: 1, explanation: "CVSS (Common Vulnerability Scoring System) provides a standardized severity rating for vulnerabilities." }
        ]
      }
    ],
    capstone: "Build a detection rule and response playbook for a credential-stuffing attack scenario."
  },
  {
    id: "cloud-security",
    title: "Cloud Security",
    icon: "cloud",
    colorHex: "#f59e0b",
    summary: "Cloud models, shared responsibility, IAM, data protection, and cloud-native security controls.",
    stage: "Advanced",
    topics: [
      {
        id: "cloud-models",
        title: "Cloud Service Models",
        minutes: 12,
        difficulty: 1,
        overview: "Cloud computing delivers IT resources on demand. The three service models (IaaS, PaaS, SaaS) define different levels of provider vs customer responsibility.",
        workplaceUse: "Cloud decisions affect budget, security responsibility, and team skills. Understanding models helps assess vendor proposals and migration plans.",
        deepDive: [
          "IaaS: Customer manages OS, apps, data. Provider manages hardware, networking, virtualization. (AWS EC2, Azure VMs)",
          "PaaS: Customer manages apps and data. Provider manages runtime, OS, infrastructure. (Heroku, Azure App Service)",
          "SaaS: Provider manages everything. Customer configures and uses. (Microsoft 365, Salesforce)",
          "Shared Responsibility Model: security responsibilities shift based on service model.",
          "Multi-cloud and hybrid strategies balance risk, cost, and vendor lock-in."
        ],
        keyTerms: ["IaaS", "PaaS", "SaaS", "Shared Responsibility", "Multi-cloud", "Hybrid", "Tenant"],
        relatedTopicIds: ["cloud-iam", "cloud-data-protection"],
        quizzes: [
          { question: "In the IaaS model, who is responsible for patching the operating system?", answers: ["Cloud provider", "Customer", "Shared equally", "Neither"], correctIndex: 1, explanation: "In IaaS, the customer is responsible for the OS, applications, and data while the provider manages the underlying infrastructure." }
        ]
      },
      {
        id: "cloud-iam",
        title: "Cloud IAM",
        minutes: 14,
        difficulty: 2,
        overview: "Identity and Access Management in cloud environments controls who can access what resources. Cloud IAM is more complex due to scale, automation, and cross-account access.",
        workplaceUse: "IAM misconfigurations are the top cloud security risk. Understanding cloud IAM helps review access policies and assess privilege escalation risks.",
        deepDive: [
          "Principals: users, groups, roles, service accounts that can be granted permissions.",
          "Policies: JSON documents defining allowed/denied actions on specific resources.",
          "Least privilege: grant minimum permissions needed; use conditions and boundaries.",
          "Federation: connect cloud IAM to enterprise identity providers (SAML, OIDC).",
          "Common mistakes: overly permissive policies, unused credentials, cross-account trust issues."
        ],
        keyTerms: ["IAM", "Role", "Policy", "Principal", "Federation", "MFA", "Service Account", "Least Privilege"],
        relatedTopicIds: ["cloud-models", "cloud-data-protection"],
        quizzes: [
          { question: "What is the most common cause of cloud security breaches?", answers: ["DDoS attacks", "IAM misconfigurations", "Physical theft", "DNS poisoning"], correctIndex: 1, explanation: "IAM misconfigurations (overly permissive policies, exposed credentials) are consistently the top cause of cloud breaches." }
        ]
      },
      {
        id: "cloud-data-protection",
        title: "Cloud Data Protection",
        minutes: 10,
        difficulty: 2,
        overview: "Protecting data in cloud environments requires encryption, access controls, classification, and monitoring across storage, transit, and processing.",
        workplaceUse: "Data protection requirements drive architecture decisions. Understanding encryption options and data residency helps meet compliance obligations.",
        deepDive: [
          "Encryption at rest: server-side (SSE), client-side, or customer-managed keys (CMK).",
          "Encryption in transit: TLS for all communications, certificate management.",
          "Data classification: identify sensitivity levels to apply appropriate controls.",
          "Data residency: regulatory requirements may restrict where data can be stored/processed.",
          "Backup and recovery: cloud-native backup services, cross-region replication, RTO/RPO planning."
        ],
        keyTerms: ["Encryption", "KMS", "CMK", "Data Classification", "Data Residency", "RTO", "RPO"],
        relatedTopicIds: ["cloud-models", "cloud-iam"],
        quizzes: [
          { question: "What does CMK stand for in cloud encryption?", answers: ["Cloud Management Key", "Customer Managed Key", "Central Master Key", "Cryptographic Module Key"], correctIndex: 1, explanation: "Customer Managed Keys (CMK) give customers control over encryption keys used to protect their cloud data." }
        ]
      }
    ],
    capstone: "Design a cloud security architecture for a startup migrating from on-premises to AWS."
  },
  {
    id: "grc",
    title: "GRC",
    icon: "document-text",
    colorHex: "#10b981",
    summary: "Governance, risk management, compliance frameworks, audit, policy, and security program management.",
    stage: "Advanced",
    topics: [
      {
        id: "risk-management",
        title: "Risk Management",
        minutes: 15,
        difficulty: 2,
        overview: "Risk management is the process of identifying, assessing, and treating risks to an organization. It provides the foundation for security investment decisions.",
        workplaceUse: "Risk assessments drive budget allocation and project prioritization. Understanding risk helps communicate security needs in business terms.",
        deepDive: [
          "Risk identification: asset inventory, threat modeling, vulnerability assessment, business impact analysis.",
          "Risk assessment: likelihood x impact scoring, qualitative vs quantitative methods.",
          "Risk treatment: mitigate (reduce), transfer (insure), avoid (eliminate), accept (acknowledge).",
          "Risk appetite: the level of risk an organization is willing to accept to achieve objectives.",
          "Risk register: documented list of identified risks with owners, scores, and treatment plans."
        ],
        keyTerms: ["Risk", "Threat", "Vulnerability", "Impact", "Likelihood", "Risk Register", "Risk Appetite"],
        relatedTopicIds: ["compliance-frameworks", "security-policy"],
        quizzes: [
          { question: "What are the four risk treatment options?", answers: ["Detect, Prevent, Respond, Recover", "Mitigate, Transfer, Avoid, Accept", "Plan, Do, Check, Act", "Identify, Protect, Detect, Respond"], correctIndex: 1, explanation: "The four risk treatment options are: mitigate (reduce), transfer (insure/share), avoid (eliminate), and accept (acknowledge)." }
        ]
      },
      {
        id: "compliance-frameworks",
        title: "Compliance Frameworks",
        minutes: 12,
        difficulty: 2,
        overview: "Compliance frameworks provide structured approaches to meeting regulatory requirements and industry standards. They help organizations demonstrate due diligence.",
        workplaceUse: "Framework selection affects audit scope, control implementation, and reporting. Understanding frameworks helps scope compliance projects accurately.",
        deepDive: [
          "NIST CSF: voluntary framework with Identify, Protect, Detect, Respond, Recover functions.",
          "ISO 27001: international standard for information security management systems (ISMS).",
          "SOC 2: audit report for service organizations covering security, availability, processing integrity, confidentiality, privacy.",
          "PCI DSS: payment card industry standard with specific technical and operational requirements.",
          "GDPR/CCPA: privacy regulations governing personal data collection, processing, and rights."
        ],
        keyTerms: ["NIST", "ISO 27001", "SOC 2", "PCI DSS", "GDPR", "Audit", "Control", "Compliance"],
        relatedTopicIds: ["risk-management", "security-policy"],
        quizzes: [
          { question: "Which framework uses the functions: Identify, Protect, Detect, Respond, Recover?", answers: ["ISO 27001", "NIST CSF", "PCI DSS", "SOC 2"], correctIndex: 1, explanation: "NIST Cybersecurity Framework organizes security activities into five core functions." }
        ]
      },
      {
        id: "security-policy",
        title: "Security Policy & Governance",
        minutes: 10,
        difficulty: 1,
        overview: "Security policies define organizational rules for protecting information assets. Governance ensures policies are implemented, monitored, and improved.",
        workplaceUse: "Policies set expectations for behavior and controls. Understanding policy hierarchy helps you know which documents to reference for different decisions.",
        deepDive: [
          "Policy hierarchy: policies (what), standards (how), procedures (step-by-step), guidelines (suggestions).",
          "Key policies: acceptable use, access control, incident response, data classification, change management.",
          "Governance structures: security committee, CISO role, risk owners, policy review cycles.",
          "Policy lifecycle: draft, review, approve, publish, train, enforce, review, update.",
          "Metrics: policy compliance rates, exception counts, training completion, audit findings."
        ],
        keyTerms: ["Policy", "Standard", "Procedure", "Guideline", "Governance", "CISO", "Compliance"],
        relatedTopicIds: ["risk-management", "compliance-frameworks"],
        quizzes: [
          { question: "In the policy hierarchy, which document provides step-by-step instructions?", answers: ["Policy", "Standard", "Procedure", "Guideline"], correctIndex: 2, explanation: "Procedures provide detailed step-by-step instructions for implementing policies and standards." }
        ]
      }
    ],
    capstone: "Draft a risk register and policy summary for a fictional mid-size company."
  }
];

export const glossaryTerms: GlossaryTerm[] = [
  { id: "asset", term: "Asset", definition: "A system, data set, account, device, application, or business process that has value and needs ownership.", relatedDomainIds: ["it-fundamentals", "grc"] },
  { id: "control", term: "Control", definition: "A safeguard or activity designed to reduce risk, detect issues, enforce policy, or support recovery.", relatedDomainIds: ["grc", "security-operations"] },
  { id: "evidence", term: "Evidence", definition: "Records, logs, screenshots, approvals, exports, or attestations used to prove that work happened or a control operated.", relatedDomainIds: ["grc", "security-operations"] },
  { id: "least-privilege", term: "Least Privilege", definition: "Granting only the access required for a user, service, or workflow to complete its approved task.", relatedDomainIds: ["cloud-security", "security-operations"] },
  { id: "segmentation", term: "Segmentation", definition: "Separating systems or networks into controlled zones to reduce exposure and limit incident blast radius.", relatedDomainIds: ["networking", "grc"] },
  { id: "telemetry", term: "Telemetry", definition: "Operational data such as logs, events, metrics, and traces collected from systems for monitoring and investigation.", relatedDomainIds: ["security-operations", "networking"] },
  { id: "encryption", term: "Encryption", definition: "The process of converting plaintext data into ciphertext using an algorithm and key, making it unreadable without the decryption key.", relatedDomainIds: ["cloud-security", "networking"] },
  { id: "zero-trust", term: "Zero Trust", definition: "A security model that requires strict identity verification for every person and device trying to access resources, regardless of network location.", relatedDomainIds: ["networking", "cloud-security"] },
  { id: "siem", term: "SIEM", definition: "Security Information and Event Management - a platform that collects, correlates, and analyzes security event data from multiple sources.", relatedDomainIds: ["security-operations"] },
  { id: "iam", term: "IAM", definition: "Identity and Access Management - the framework of policies and technologies ensuring the right individuals access the right resources.", relatedDomainIds: ["cloud-security", "grc"] }
];

export const portItems: PortItem[] = [
  { port: 20, protocol: "TCP", description: "FTP Data Transfer" },
  { port: 21, protocol: "TCP", description: "FTP Control" },
  { port: 22, protocol: "TCP", description: "SSH / SFTP" },
  { port: 23, protocol: "TCP", description: "Telnet (insecure)" },
  { port: 25, protocol: "TCP", description: "SMTP (email sending)" },
  { port: 53, protocol: "TCP/UDP", description: "DNS" },
  { port: 67, protocol: "UDP", description: "DHCP Server" },
  { port: 68, protocol: "UDP", description: "DHCP Client" },
  { port: 80, protocol: "TCP", description: "HTTP" },
  { port: 110, protocol: "TCP", description: "POP3 (email retrieval)" },
  { port: 143, protocol: "TCP", description: "IMAP (email retrieval)" },
  { port: 443, protocol: "TCP", description: "HTTPS" },
  { port: 445, protocol: "TCP", description: "SMB (file sharing)" },
  { port: 3389, protocol: "TCP", description: "RDP (Remote Desktop)" },
  { port: 8080, protocol: "TCP", description: "HTTP Alternate / Proxy" },
  { port: 3306, protocol: "TCP", description: "MySQL" },
  { port: 5432, protocol: "TCP", description: "PostgreSQL" },
  { port: 27017, protocol: "TCP", description: "MongoDB" },
  { port: 6379, protocol: "TCP", description: "Redis" },
  { port: 1433, protocol: "TCP", description: "Microsoft SQL Server" }
];

export const frameworks: FrameworkComparison[] = [
  { id: "nist-csf", framework: "NIST CSF", scope: "All organizations", approach: "Risk-based", structure: "5 Functions, 23 Categories", bestFor: "Comprehensive security program alignment" },
  { id: "iso-27001", framework: "ISO 27001", scope: "International", approach: "Management system", structure: "Clauses + Annex A controls", bestFor: "Certification and global recognition" },
  { id: "cis-controls", framework: "CIS Controls", scope: "All organizations", approach: "Prioritized actions", structure: "18 Controls, 3 Implementation Groups", bestFor: "Practical implementation starting point" },
  { id: "soc2", framework: "SOC 2", scope: "Service organizations", approach: "Trust principles", structure: "5 Trust Service Criteria", bestFor: "Customer assurance for SaaS/cloud services" },
  { id: "pci-dss", framework: "PCI DSS", scope: "Payment card handlers", approach: "Prescriptive", structure: "12 Requirements, 6 Goals", bestFor: "Organizations processing credit card data" }
];

export const securityMetrics: SecurityMetric[] = [
  { id: "mttr", metric: "MTTR", fullName: "Mean Time to Remediate", description: "Average time from vulnerability discovery to fix deployment", target: "< 30 days (critical)", category: "Vulnerability" },
  { id: "mttd", metric: "MTTD", fullName: "Mean Time to Detect", description: "Average time from breach occurrence to detection", target: "< 24 hours", category: "Detection" },
  { id: "mttr-incident", metric: "MTTR-I", fullName: "Mean Time to Respond (Incident)", description: "Average time from alert to initial response action", target: "< 1 hour (critical)", category: "Incident" },
  { id: "patch-compliance", metric: "Patch %", fullName: "Patch Compliance Rate", description: "Percentage of systems with current security patches", target: "> 95%", category: "Vulnerability" },
  { id: "phishing-rate", metric: "Phish %", fullName: "Phishing Click Rate", description: "Percentage of users who click simulated phishing links", target: "< 5%", category: "Awareness" },
  { id: "mfa-coverage", metric: "MFA %", fullName: "MFA Coverage", description: "Percentage of accounts with multi-factor authentication enabled", target: "> 99%", category: "Identity" }
];

export const toolCategories: ToolCategory[] = [
  { id: "siem-tools", category: "SIEM & Log Management", tools: ["Splunk", "Microsoft Sentinel", "Elastic SIEM", "IBM QRadar", "Sumo Logic"] },
  { id: "vuln-tools", category: "Vulnerability Scanning", tools: ["Nessus", "Qualys", "Rapid7 InsightVM", "OpenVAS", "Nuclei"] },
  { id: "edr-tools", category: "Endpoint Detection & Response", tools: ["CrowdStrike Falcon", "Microsoft Defender for Endpoint", "SentinelOne", "Carbon Black"] },
  { id: "network-tools", category: "Network Security", tools: ["Wireshark", "Nmap", "Snort", "Suricata", "Zeek"] },
  { id: "cloud-tools", category: "Cloud Security", tools: ["AWS GuardDuty", "Azure Security Center", "Prisma Cloud", "Wiz", "Lacework"] },
  { id: "pentest-tools", category: "Penetration Testing", tools: ["Burp Suite", "Metasploit", "Cobalt Strike", "Kali Linux", "OWASP ZAP"] }
];

export const scenarios: Scenario[] = [
  {
    id: "credential-compromise",
    title: "Credential Compromise Response",
    summary: "A security alert indicates that an employee's credentials may have been compromised through a phishing attack. The SOC has flagged unusual login activity from an unfamiliar location.",
    evidence: [
      { title: "Login Alert", detail: "Successful login from IP 185.220.101.x (Tor exit node) at 3:47 AM local time for user jsmith@company.com" },
      { title: "Email Report", detail: "User reported clicking a link in an email about a 'mandatory password reset' 6 hours before the alert" },
      { title: "Access Logs", detail: "After login, the session accessed SharePoint, downloaded 3 files from the Finance folder, and attempted to access the VPN admin panel" }
    ],
    actions: [
      {
        id: "immediate-disable",
        label: "Immediately disable the account and reset credentials",
        score: 85,
        feedback: "Strong response. Immediate containment prevents further unauthorized access while investigation continues.",
        development: "Consider also revoking active sessions and tokens, not just resetting the password.",
        followUps: [
          { id: "f1", label: "Revoke all active sessions and OAuth tokens", consequence: "Ensures attacker loses access even if they cached tokens", recommended: true },
          { id: "f2", label: "Notify the user via phone (not email)", consequence: "Confirms the user is aware without alerting the attacker through compromised email", recommended: true },
          { id: "f3", label: "Wait for manager approval before disabling", consequence: "Delays containment; attacker may exfiltrate more data", recommended: false }
        ]
      },
      {
        id: "monitor-first",
        label: "Monitor the session to gather intelligence before acting",
        score: 40,
        feedback: "Risky approach. While gathering intelligence has value, the attacker is actively accessing sensitive files. The risk of data loss outweighs intelligence value.",
        development: "In most enterprise environments, containment speed is prioritized over attacker intelligence gathering.",
        followUps: [
          { id: "f4", label: "Set a 15-minute monitoring window maximum", consequence: "Limits exposure while gathering some intelligence", recommended: true },
          { id: "f5", label: "Continue monitoring indefinitely", consequence: "Unacceptable risk of continued data exfiltration", recommended: false }
        ]
      },
      {
        id: "email-user",
        label: "Send the user an email asking them to verify the activity",
        score: 20,
        feedback: "Poor choice. The attacker likely has access to the user's email and would see this notification, potentially accelerating their attack or covering tracks.",
        development: "Never use a potentially compromised communication channel to verify a compromise.",
        followUps: [
          { id: "f6", label: "Call the user instead", consequence: "Out-of-band verification is more secure", recommended: true },
          { id: "f7", label: "Wait for the user to respond to email", consequence: "Attacker may respond pretending to be the user", recommended: false }
        ]
      }
    ]
  },
  {
    id: "s3-bucket-exposure",
    title: "Cloud Storage Data Exposure",
    summary: "An automated scan has detected that an S3 bucket containing customer data has been publicly accessible for approximately 72 hours following a configuration change.",
    evidence: [
      { title: "Scanner Alert", detail: "Bucket 'prod-customer-exports' has ACL set to 'public-read' since Tuesday's deployment" },
      { title: "Access Logs", detail: "CloudTrail shows 47 GetObject requests from external IPs in the past 72 hours, accessing CSV files with customer names and email addresses" },
      { title: "Change History", detail: "A Terraform change on Tuesday modified the bucket policy as part of a larger infrastructure update. The PR was approved by one reviewer." }
    ],
    actions: [
      {
        id: "restrict-immediately",
        label: "Immediately restrict bucket access and begin impact assessment",
        score: 90,
        feedback: "Excellent response. Immediate restriction stops the bleeding while impact assessment determines notification obligations.",
        development: "Also preserve CloudTrail logs and access records before they rotate.",
        followUps: [
          { id: "f8", label: "Preserve all access logs for forensic analysis", consequence: "Enables accurate determination of what data was accessed", recommended: true },
          { id: "f9", label: "Determine if accessed data triggers breach notification requirements", consequence: "Proactive compliance assessment prevents regulatory issues", recommended: true },
          { id: "f10", label: "Revert the Terraform change without review", consequence: "May break other services that depended on the change", recommended: false }
        ]
      },
      {
        id: "investigate-first",
        label: "Investigate the full scope before making changes",
        score: 50,
        feedback: "Partially correct. Investigation is important but should happen in parallel with immediate restriction. Every hour of exposure increases risk.",
        development: "In data exposure scenarios, stop the exposure first, then investigate.",
        followUps: [
          { id: "f11", label: "Restrict access while investigating in parallel", consequence: "Best of both approaches - stops exposure while gathering facts", recommended: true },
          { id: "f12", label: "Complete full investigation before any action", consequence: "Continued exposure during investigation period", recommended: false }
        ]
      },
      {
        id: "blame-developer",
        label: "Escalate to the developer who made the change for them to fix it",
        score: 30,
        feedback: "Inefficient and potentially slow. Security incidents require immediate action regardless of who caused them. Blame assignment can happen later.",
        development: "Incident response focuses on containment first. Root cause and accountability come in post-incident review.",
        followUps: [
          { id: "f13", label: "Fix the issue yourself and discuss process improvements later", consequence: "Faster resolution, constructive approach to prevention", recommended: true },
          { id: "f14", label: "Wait for the developer to respond", consequence: "Delays resolution; developer may be unavailable", recommended: false }
        ]
      }
    ]
  }
];

export const visualLessons: VisualLesson[] = [
  {
    id: "risk-treatment",
    title: "Risk Treatment Matrix",
    summary: "Explore how organizations decide whether to mitigate, transfer, avoid, or accept different types of risk based on likelihood and impact.",
    prompts: [
      "Consider a risk with HIGH likelihood and HIGH impact. What treatment would you recommend and why?",
      "When might an organization choose to ACCEPT a risk rather than mitigate it?",
      "How does risk TRANSFER work in practice? Give an example with cyber insurance.",
      "Map three real-world scenarios to the risk treatment matrix: ransomware, insider threat, natural disaster."
    ]
  },
  {
    id: "threat-model",
    title: "Threat Modeling Canvas",
    summary: "Walk through a structured threat modeling exercise to identify assets, threats, and controls for a web application.",
    prompts: [
      "What are the key ASSETS in a typical e-commerce application that need protection?",
      "Using STRIDE, identify one threat for each category against a login system.",
      "What TRUST BOUNDARIES exist between the user's browser, the web server, and the database?",
      "Propose CONTROLS for the top 3 threats you identified. Consider both preventive and detective controls."
    ]
  },
  {
    id: "cloud-architecture",
    title: "Cloud Security Architecture",
    summary: "Design a secure cloud architecture by placing security controls at each layer of a typical three-tier application.",
    prompts: [
      "What security controls should exist at the NETWORK layer of a cloud deployment?",
      "How would you secure the APPLICATION layer? Consider both code-level and infrastructure controls.",
      "What DATA protection measures are needed for data at rest, in transit, and in use?",
      "Design an IDENTITY strategy: who needs access, how do they authenticate, and how is access reviewed?"
    ]
  }
];

export const diagnosticQuestions: DiagnosticQuestion[] = [
  { id: "d1", domainId: "it-fundamentals", prompt: "How confident are you in explaining the difference between RAM and storage to a non-technical stakeholder?", answers: [{ label: "Still learning the basics", score: 20 }, { label: "Can explain with some help", score: 55 }, { label: "Can explain clearly and give examples", score: 90 }] },
  { id: "d2", domainId: "it-fundamentals", prompt: "Could you identify which operating system logs to check when investigating a security incident?", answers: [{ label: "Not sure where to start", score: 20 }, { label: "Know the general areas but need guidance", score: 55 }, { label: "Can navigate OS logs confidently", score: 90 }] },
  { id: "d3", domainId: "it-fundamentals", prompt: "How well do you understand virtualization and container security implications?", answers: [{ label: "Basic awareness only", score: 20 }, { label: "Understand concepts, limited hands-on", score: 55 }, { label: "Can assess and configure securely", score: 90 }] },
  { id: "d4", domainId: "networking", prompt: "Can you explain what happens at each OSI layer when you browse a website?", answers: [{ label: "Vague understanding of layers", score: 20 }, { label: "Can describe most layers", score: 55 }, { label: "Can trace a packet through all layers", score: 90 }] },
  { id: "d5", domainId: "networking", prompt: "How comfortable are you with IP subnetting and CIDR notation?", answers: [{ label: "Find it confusing", score: 20 }, { label: "Can do basic calculations", score: 55 }, { label: "Can subnet networks confidently", score: 90 }] },
  { id: "d6", domainId: "networking", prompt: "Could you configure firewall rules for a new application deployment?", answers: [{ label: "Would need significant help", score: 20 }, { label: "Can do it with documentation", score: 55 }, { label: "Can design and implement independently", score: 90 }] },
  { id: "d7", domainId: "networking", prompt: "How well do you understand DNS and DHCP security risks?", answers: [{ label: "Aware they exist", score: 20 }, { label: "Can describe common attacks", score: 55 }, { label: "Can detect and mitigate DNS/DHCP attacks", score: 90 }] },
  { id: "d8", domainId: "security-operations", prompt: "How would you respond to a phishing alert in your organization's SIEM?", answers: [{ label: "Unsure of the process", score: 20 }, { label: "Know the general steps", score: 55 }, { label: "Can triage and respond independently", score: 90 }] },
  { id: "d9", domainId: "security-operations", prompt: "Can you write or tune SIEM correlation rules?", answers: [{ label: "Haven't worked with SIEM rules", score: 20 }, { label: "Can modify existing rules", score: 55 }, { label: "Can create rules from scratch", score: 90 }] },
  { id: "d10", domainId: "security-operations", prompt: "How familiar are you with the MITRE ATT&CK framework?", answers: [{ label: "Heard of it", score: 20 }, { label: "Can navigate and reference it", score: 55 }, { label: "Use it actively for detection engineering", score: 90 }] },
  { id: "d11", domainId: "security-operations", prompt: "Can you prioritize vulnerabilities using CVSS and business context?", answers: [{ label: "Not familiar with CVSS", score: 20 }, { label: "Understand scoring basics", score: 55 }, { label: "Can prioritize with full context", score: 90 }] },
  { id: "d12", domainId: "cloud-security", prompt: "How well do you understand the shared responsibility model across IaaS, PaaS, and SaaS?", answers: [{ label: "Basic awareness", score: 20 }, { label: "Can explain the differences", score: 55 }, { label: "Can apply it to real architecture decisions", score: 90 }] },
  { id: "d13", domainId: "cloud-security", prompt: "Could you review and improve an IAM policy in AWS or Azure?", answers: [{ label: "Haven't worked with cloud IAM", score: 20 }, { label: "Can read policies with help", score: 55 }, { label: "Can write and audit policies", score: 90 }] },
  { id: "d14", domainId: "cloud-security", prompt: "How confident are you in implementing cloud data encryption strategies?", answers: [{ label: "Know encryption is important", score: 20 }, { label: "Understand options but limited implementation", score: 55 }, { label: "Can design and implement encryption architecture", score: 90 }] },
  { id: "d15", domainId: "grc", prompt: "Can you conduct a basic risk assessment for a new project or system?", answers: [{ label: "Unfamiliar with the process", score: 20 }, { label: "Can follow a template", score: 55 }, { label: "Can lead an assessment independently", score: 90 }] },
  { id: "d16", domainId: "grc", prompt: "How well do you understand the differences between NIST CSF, ISO 27001, and SOC 2?", answers: [{ label: "Know they exist", score: 20 }, { label: "Can describe key differences", score: 55 }, { label: "Can recommend frameworks for specific needs", score: 90 }] },
  { id: "d17", domainId: "grc", prompt: "Could you draft or review a security policy for your organization?", answers: [{ label: "Haven't worked with policies", score: 20 }, { label: "Can contribute to policy drafts", score: 55 }, { label: "Can author and maintain policies", score: 90 }] },
  { id: "d18", domainId: "it-fundamentals", prompt: "How well can you apply a structured troubleshooting methodology to IT issues?", answers: [{ label: "Tend to guess and check", score: 20 }, { label: "Follow a loose process", score: 55 }, { label: "Apply systematic methodology consistently", score: 90 }] },
  { id: "d19", domainId: "networking", prompt: "Can you trace network connectivity issues using tools like ping, traceroute, and netstat?", answers: [{ label: "Limited experience", score: 20 }, { label: "Can use basic tools", score: 55 }, { label: "Can diagnose complex network issues", score: 90 }] },
  { id: "d20", domainId: "security-operations", prompt: "How prepared are you to lead or participate in an incident response?", answers: [{ label: "Would need significant guidance", score: 20 }, { label: "Can participate with a playbook", score: 55 }, { label: "Can lead response activities", score: 90 }] }
];

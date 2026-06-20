import Foundation

enum FrameworkReferenceData {
    static let frameworks: [FrameworkComparison] = [
        FrameworkComparison(
            framework: "NIST CSF",
            scope: "Cybersecurity risk management",
            approach: "Outcome-oriented framework organized around core functions.",
            structure: "Govern, Identify, Protect, Detect, Respond, Recover",
            bestFor: "Executive reporting, program maturity, and risk-aligned roadmaps"
        ),
        FrameworkComparison(
            framework: "ISO 27001",
            scope: "Information security management system",
            approach: "Certification-oriented management system with controls and continual improvement.",
            structure: "Clauses plus Annex A controls",
            bestFor: "Auditable security governance and external assurance"
        ),
        FrameworkComparison(
            framework: "CIS Controls",
            scope: "Prioritized technical safeguards",
            approach: "Implementation-focused control set for practical defense improvement.",
            structure: "Safeguards grouped into implementation groups",
            bestFor: "Actionable technical remediation and control baselining"
        )
    ]
}

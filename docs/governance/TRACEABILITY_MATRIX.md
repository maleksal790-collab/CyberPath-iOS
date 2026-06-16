# Traceability Matrix

| Requirement | Implementation Area | Validation |
|---|---|---|
| Local-first app | `ProgressStore.swift` | Relaunch persistence smoke test |
| Account-free workflow | App architecture | Privacy review |
| Dashboard resume path | `DashboardView` | Simulator acceptance |
| Domain learning | `DomainsView`, `DomainDetailView` | Learn tab acceptance |
| Topic learning | `TopicDetailView` | Topic acceptance |
| Quiz scoring | `TopicDetailView` | Quiz acceptance and future XCTest |
| Notes | `ProgressStore`, topic UI | Draft save acceptance |
| Scenario lab | `ScenarioLabView` | Scenario acceptance |
| Interactive visual studio | `VisualStudioView` | Visual studio acceptance |
| Diagnostic | `DiagnosticView` | Diagnostic acceptance and future XCTest |
| Evidence report | `EvidenceReportView` | Report acceptance |
| Export/import | `ProgressStore`, `ProgressDataView` | Valid and malformed import tests |
| App icon | `Assets.xcassets` | Structure validation |
| Release governance | `.github`, `docs/governance`, `scripts` | CI validation |


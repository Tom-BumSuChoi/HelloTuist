# AGENTS.md

## 프로젝트 개요

**NomadSpace** - 디지털 노마드와 글로벌 여행자를 위한 슈퍼 앱. TMA (The Modular Architecture) 기반, Tuist로 프로젝트 관리.

## Cursor Cloud specific instructions

### 플랫폼 제약

이 프로젝트는 **iOS 전용 앱**으로, 완전한 빌드/실행/테스트에는 **macOS + Xcode**가 필요하다. Linux Cloud VM에서는 다음 제한이 있다:

- `tuist install`, `tuist generate`, `tuist build`, `tuist test`: macOS 전용 명령. Linux Tuist 바이너리는 서버/프로젝트 관리 명령만 제공.
- SwiftUI, UIKit: Linux에서 컴파일 불가.
- XCTest 기반 단위 테스트: iOS 시뮬레이터 필요.

### Linux에서 가능한 작업

- **Swift 구문 검증**: `swiftc -parse <파일>` 로 구문 오류 확인.
- **의존성 해결**: `cd Tuist && swift package resolve`.
- **의존성 빌드**: `cd Tuist && swift build --target Alamofire`.
- **Tuist 서버 명령**: `tuist auth`, `tuist project` 등 사용 가능.

### 사전 설치된 도구

- **Swift 6.0.3**: `/opt/swift-6.0.3-RELEASE-ubuntu24.04/usr/bin/`
- **mise**: `~/.local/bin/mise` → Tuist 버전 관리
- **Tuist 4.155.3**: mise로 설치됨

### 아키텍처 (5계층 TMA)

```
App Layer          → NomadSpace (메인 앱, 탭 네비게이션, DI)
Feature Layer      → FlightFeature, StayFeature, WalletFeature, CommunityFeature, WorkspaceFeature
Domain Layer       → TravelDomain, PaymentDomain, AuthDomain
Core Layer         → NetworkCore, StorageCore, LoggerUtility
Shared UI Layer    → DesignSystem
```

**의존성 방향**: App → Features → Domains → Core (단방향). 모듈 간 의존은 Interface 타겟을 통해.

### 새 모듈 추가 방법

`Tuist/ProjectDescriptionHelpers/Module.swift`의 `Module.makeTargets()` 헬퍼 사용:

```swift
Module.makeTargets(
    name: "NewFeature",
    layer: "Features",           // 디렉토리 계층
    dependencies: [...],         // Source 타겟 의존성
    interfaceDependencies: [...], // Interface 타겟 의존성
    hasExample: true             // Feature는 true, Domain/Core는 false
)
```

각 모듈은 TMA 표준 5개 타겟: Interface, Source, Testing, Tests, Example (Feature만).

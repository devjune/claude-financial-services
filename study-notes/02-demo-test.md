# 02. 데모 테스트용 (난이도 + 구현)

> 에이전트 데모 가능성(난이도 매트릭스) + **우리 데모의 구현 방식**.
> 우리 데모는 파이썬/Office가 아니라 **직접 작성한 Claude 스킬 + 마크다운/mermaid**로 한다. → [`study-demo/`](../study-demo/)

## 난이도 매트릭스 (10개)

> 기준(중요): **인터넷 O(웹검색 가능)**. 블로커는 **유료 벤더 MCP**(capiq/factset/daloopa/pitchbook 등 구독 필요)뿐. 회사 자체 시스템 MCP(internal-gl/crm/portfolio/nav)는 샘플 시나리오로 대체 가능.
>
> 🟢 GREEN = 셋업 낮음, 웹/수동입력으로 작동 · 🟡 YELLOW = 시나리오 위조 필요 or 유료데이터 없으면 약해짐 · 🔴 RED = 유료/내부데이터 대량 없으면 무의미.

| # | 에이전트 | vertical | 등급 | 블로커 / 셋업 |
|---|---|---|---|---|
| 1 | **Market Researcher** | equity-research | 🟢 | 없음. 섹터 한 줄. comps만 유료→`[UNSOURCED]` |
| 2 | **GL Reconciler** | fund-admin | 🟢 | 장부 2개 시나리오. internal MCP는 placeholder |
| 3 | **Model Builder (DCF)** | financial-analysis | 🟢 | 가정값 수동입력. MCP는 fetch 전용 |
| 4 | **KYC Screener** ★ | operations | 🟢~🟡 | 온보딩 시나리오 위조. 스크리닝 MCP는 not-run |
| 5 | **Valuation Reviewer** | private-equity | 🟡 | GP 패키지 시나리오 위조 |
| 6 | **Statement Auditor** | fund-admin | 🟡 | NAV 팩 + 명세서 위조 |
| 7 | **Meeting Prep** | wealth-management | 🟡 | 고객 프로필 위조. CapIQ→웹 |
| 8 | **Earnings Reviewer** | equity-research | 🟡 | 웹 transcript+공시 OK. 컨센서스→`[UNSOURCED]` |
| 9 | **Pitch Agent** | investment-banking | 🟡 | comps/선례거래 유료→약함. 제일 큼 |
| 10 | **Month-End Closer** | fund-admin | 🔴 | 결산 전체가 internal-gl에서. 데이터 대량 |

### 핵심 관찰

- **GREEN 4개**(Researcher·GL·DCF·KYC — KYC는 🟢~🟡 경계). KYC는 핀테크 도메인이라 ★.
- **YELLOW 5개** 공통: "회사 자체 데이터를 시나리오로 위조"만 하면 됨. 유료 구독 필요 아님.
- **RED는 Month-End 하나** — 결산은 내부 GL 전체가 있어야 의미.
- **공통 패턴**: ① 데이터는 MCP/웹/수동 택1 ② 마지막에 사람 승인 stop. → 난이도는 "데이터를 얼마나 쉽게 공급하나"로 갈림.

### 발표 라인업 (3개)

**Market Researcher → KYC → DCF** (단순→도메인→임팩트). GL은 백업.

## 우리 데모 구현 — Claude 스킬 + 마크다운/mermaid

처음엔 파이썬(openpyxl/python-pptx)으로 Office 산출물을 흉내냈지만, 레포 취지(=스킬 스터디)에 맞게 **직접 Claude 스킬을 작성**하고 **마크다운+mermaid로 시각화**하도록 바꿨다. **파이썬·Office 의존성 0.**

- 스킬: [`.claude/skills/demo-visualizer/SKILL.md`](../.claude/skills/demo-visualizer/SKILL.md) — 시나리오 → md+mermaid 리포트 (Excel 대체용)
- 슬래시: `.claude/commands/demo-visualizer.md` → `/demo-visualizer <kyc|gl|dcf|...>`
- 입력: `study-demo/scenarios/{kyc,kyc-retail,gl-recon,dcf}.md`
- 결과: **스킬로 라이브 생성** (커밋 안 함, `.gitignore`) — "스킬 돌리는 게 곧 데모"

### 기대 결과 (스킬이 시나리오대로 생성)

| 데모 | 기대 결과 | 시각화 |
|---|---|---|
| **KYC** ★ | risk=high, **escalate-EDD** (R2 RU·R3 PEP fail, R7 not-run) | 지분 그래프 + 룰 판정 흐름 |
| **GL** | 5행 중 break 4개 (Timing/FX/Quantity/GL-only) | 대사 파이프라인 + 버킷 파이 |
| **DCF** | 주당 **$46.15** vs $50 → **−7.7%**, terminal<WACC ✓ | 계산 체인 + 민감도 표 |

> 결과 mermaid는 GitHub·Confluence에서 자동 렌더. 재현성은 스킬의 결정성 계약에 기댄다(라이브라 발표 직전 한 번 돌려 확인 권장).

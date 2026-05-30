# 01. 전체 지도

> anthropics/financial-services 스터디 노트. 금융권 실무용 Claude 에이전트 레퍼런스 모음집.

## 핵심 컨셉: one source, two wrappers

시스템 프롬프트 + 스킬을 한 번 작성 → 두 가지로 배포
- **Cowork 플러그인** (`plugins/agent-plugins/`)
- **Managed Agents API** (`managed-agent-cookbooks/`)

## 폴더 구조

```
plugins/
├── agent-plugins/        ⭐ 완성형 에이전트 10개
│   └── <agent>/
│       ├── agents/<slug>.md   ← 시스템 프롬프트 (원본은 여기 하나)
│       └── skills/            ← vertical에서 복사된 사본
├── vertical-plugins/     ⭐ 스킬 원본 창고 (7개 분야)
│   └── <vertical>/
│       ├── commands/          ← /dcf, /comps 슬래시 커맨드
│       ├── skills/            ← SKILL.md (진짜 노하우)
│       └── .mcp.json          ← 데이터 커넥터
└── partner-built/        파트너 플러그인 (LSEG, S&P Global)

managed-agent-cookbooks/  API 배포 레시피 (agent.yaml + subagents)
scripts/                  검증/동기화 (check.py, sync-agent-skills.py)
```

## 데이터 흐름

```
vertical-plugins (스킬 원본)
   → 골라 묶어서 → agent-plugins (완성형 에이전트)
   → 같은 소스로 → 2가지 배포
```

- 스킬 원본은 `vertical-plugins/`에만. `agent-plugins/.../skills/`는 복사본.
- 수정은 vertical에서 → `sync-agent-skills.py`로 전파.

## 에이전트 10개

| 분야 | 에이전트 | 하는 일 |
|---|---|---|
| 커버리지/자문 | pitch-agent | 컴스·선례·LBO → 피치덱 풀자동 (스킬 11개) |
| | meeting-prep-agent | 고객 미팅 전 브리핑 팩 |
| 리서치/모델링 | market-researcher | 섹터/테마 → 산업개요·경쟁구도·컴스·아이디어 |
| | earnings-reviewer | 실적콜+공시 → 모델 업데이트 → 노트 |
| | model-builder | DCF·LBO·3-statement·컴스 엑셀에 직접 |
| 펀드어드민/재무 | valuation-reviewer | GP 패키지 → 밸류에이션 → LP 리포팅 |
| | gl-reconciler | break 찾기 → 원인추적 → 승인 라우팅 |
| | month-end-closer | 발생주의·롤포워드·차이 코멘터리 |
| | statement-auditor | LP 명세서 배포 전 감사 |
| 운영/온보딩 | kyc-screener | 온보딩 문서 파싱 → 룰엔진 → 누락 플래그 |

공통 기반 스킬: `xlsx-author`(엑셀 생성), `audit-xls`(엑셀 검증) — 거의 모든 에이전트가 공유.

## Vertical 7개

| Vertical | 대표 커맨드 | 성격 |
|---|---|---|
| financial-analysis | /dcf /comps /lbo /3-statement-model | 핵심 모델링 엔진 (다 갖다씀) |
| equity-research | /earnings /initiate /morning-note /thesis | 셀사이드 리서치 |
| investment-banking | /cim /teaser /merger-model /buyer-list | M&A 딜 |
| private-equity | /source /dd-checklist /ic-memo /returns | PE 딜 소싱~심사 |
| wealth-management | /financial-plan /rebalance /tlh /proposal | 자산관리 |
| fund-admin | (커맨드 없음) | 펀드 회계/결산 |
| operations | (커맨드 없음) | KYC 운영 |

- fund-admin, operations는 커맨드 없음 → 에이전트가 백그라운드로 트리거하는 스킬 위주.
- financial-analysis의 `skill-creator` = 스킬 만드는 메타 스킬.

## 다음에 볼 것

- [ ] SKILL.md 실제 구조 (예: dcf-model)
- [ ] 에이전트 시스템 프롬프트 (pitch-agent.md)
- [ ] 배포 설정 (plugin.json / agent.yaml)

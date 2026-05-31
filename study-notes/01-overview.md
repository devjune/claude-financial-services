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

| 분야 | 에이전트 | 하는 일 (README 기준) | 쉬운 설명 |
|---|---|---|---|
| 커버리지/자문 | pitch-agent | 컴스·선례·LBO → 피치덱 풀자동 (스킬 11개) | 은행이 고객사에 "딜 맡겨주세요" 하는 영업 PPT를, 데이터부터 끝까지 자동으로 만들어줌 |
| | meeting-prep-agent | 고객 미팅 전 브리핑 팩 | 고객 만나기 전 "이 사람 누구였더라" 요약 챙겨주는 비서 |
| 리서치/모델링 | market-researcher | 섹터/테마 → 산업개요·경쟁구도·컴스·아이디어 | "이 산업 좀 훑어줘" 하면 조사 리포트 뽑아주는 애널리스트 |
| | earnings-reviewer | 실적콜+공시 → 모델 업데이트 → 노트 | 실적 발표 나오면 모델 갱신하고 코멘트 써주는 주니어 |
| | model-builder | DCF·LBO·3-statement·컴스 엑셀에 직접 | 회사 몸값 계산하는 엑셀 재무모델을 자동으로 짜주는 모델러 |
| 펀드어드민/재무 | valuation-reviewer | GP 패키지 → 밸류에이션 → LP 리포팅 | 운용사가 보낸 평가자료 받아 검토하고, 투자자(LP)한테 보낼 보고서 준비 |
| | gl-reconciler | break 찾기 → 원인추적 → 승인 라우팅 | 장부 두 개 안 맞는 곳 찾아서 "여기 확인하세요" 표시 (수정은 사람) |
| | month-end-closer | 발생주의·롤포워드·차이 코멘터리 | 월말 결산 잡일(비용 미리잡기·잔액 잇기·차이 설명) 대신해줌 |
| | statement-auditor | LP 명세서 배포 전 감사 | 투자자한테 명세서 보내기 전, 숫자 틀린 거 마지막 검수 |
| 운영/온보딩 | kyc-screener | 온보딩 문서 파싱 → 룰엔진 → 누락 플래그 | 신규 고객 서류 읽고 규칙에 대조해 "위험/누락" 표시 (승인은 사람) |

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

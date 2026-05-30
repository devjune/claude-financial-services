# 04. 10개 에이전트 데모 난이도 매트릭스

> 기준(중요): **인터넷 O(웹검색 가능)**. 블로커는 **유료 벤더 MCP**(capiq/factset/daloopa/pitchbook 등 구독 필요)뿐. 회사 자체 시스템 MCP(internal-gl/crm/portfolio/nav)는 "샘플 파일 위조하면 됨". openpyxl/python-pptx는 pip로 설치.
>
> 🟢 GREEN = 셋업 낮음, 웹/수동입력으로 작동 · 🟡 YELLOW = 되는데 파일 위조 필요 or 유료데이터 없으면 약해짐 · 🔴 RED = 유료/내부데이터 대량 없으면 무의미. 4개(pitch·earnings·meeting·valuation)는 서브에이전트 검증, KYC·GL·DCF는 실제 구동 검증 완료.

| # | 에이전트 | vertical | 등급 | 블로커 / 셋업 | 산출물 |
|---|---|---|---|---|---|
| 1 | **Market Researcher** | equity-research | 🟢 | 없음. 섹터 한 줄이면 됨. comps만 유료→`[UNSOURCED]` | 리서치 노트 + pptx |
| 2 | **GL Reconciler** | fund-admin | 🟢 | CSV 2개 위조(쉬움). internal MCP는 placeholder | break 리포트 xlsx |
| 3 | **Model Builder (DCF)** | financial-analysis | 🟢 | 가정값 수동입력. MCP는 fetch 전용 | live-formula xlsx |
| 4 | **KYC Screener** ★ | operations | 🟢~🟡 | 텍스트 문서 위조. 스크리닝 MCP는 not-run | 에스컬레이션 xlsx |
| 5 | **Valuation Reviewer** | private-equity | 🟡 | GP 패키지 파일 위조. returns(IRR/MOIC)는 순수 수식 | LP 리포팅 xlsx |
| 6 | **Statement Auditor** | fund-admin | 🟡 | NAV 팩 + 명세서 2개 위조 | 감사 결과 xlsx |
| 7 | **Meeting Prep** | wealth-management | 🟡 | 고객 프로필 위조(CRM 대체). CapIQ→웹 | 브리핑 팩 + pptx |
| 8 | **Earnings Reviewer** | equity-research | 🟡 | 웹 transcript+공시 OK. 컨센서스→웹`[UNSOURCED]`, 모델 파일 | 모델 xlsx + 노트 |
| 9 | **Pitch Agent** | investment-banking | 🟡 | DCF/LBO/덱은 웹+EDGAR OK. comps/선례거래 유료→약함. 제일 큼 | xlsx + pptx |
| 10 | **Month-End Closer** | fund-admin | 🔴 | 결산 전체가 internal-gl에서. 데이터 대량 위조 | 결산 xlsx |

## 핵심 관찰

- **GREEN 3.5개**(Researcher·GL·DCF + KYC) — 데모는 이 안에서. KYC는 핀테크 도메인이라 ★.
- **YELLOW 5개**의 공통점: "회사 자체 데이터를 샘플 파일로 위조"만 하면 됨. 유료 구독 필요는 아님.
- **RED는 Month-End 하나** — 결산은 본질적으로 내부 GL 전체가 있어야 의미가 생김.
- **공통 패턴**: 거의 모든 에이전트가 ① 데이터는 MCP/웹/수동 중 택1(fetch 단계 분리) ② 산출물은 openpyxl/python-pptx로 오프라인 ③ 마지막에 사람 승인으로 stop. → 데모 난이도는 결국 "데이터를 얼마나 쉽게 공급하나"로 갈림.

## 데모 라인업 (확정)

1. **Market Researcher** — 라이브 훅 (셋업 0, "에이전트가 일하는 느낌")
2. **KYC Screener** ★ — 핀테크 도메인 공감
3. **GL Reconciler** — "AI는 초안, 기표는 사람" 거버넌스
4. **Model Builder(DCF)** — 엑셀 결과물 임팩트

→ 전부 `demo/` 폴더에 구동 가능하게 준비됨. 실행법은 `demo/README.md`.

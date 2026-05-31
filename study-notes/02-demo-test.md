# 02. 데모 테스트용 (난이도 + 검증)

> 데모 에이전트 선정 근거(난이도 매트릭스) + 실제 오프라인 구동 검증 기록.
> 실행 단계는 [`demo/README.md`](../demo/README.md).

## 난이도 매트릭스 (10개)

기준:
- **전제** — 인터넷 O(웹검색 가능).
- **유일한 블로커** — 유료 벤더 MCP(capiq/factset/daloopa/pitchbook — 구독 필요).
- **우회 가능** — 회사 자체 시스템 MCP(internal-gl/crm/portfolio/nav)는 샘플 파일로 대체, 출력 라이브러리는 `pip install openpyxl python-pptx`.

등급: 🟢 GREEN = 셋업 낮음, 웹/수동입력으로 작동 · 🟡 YELLOW = 파일 위조 필요 or 유료데이터 없으면 약해짐 · 🔴 RED = 유료/내부데이터 대량 없으면 무의미.

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

### 핵심 관찰

- **GREEN 4개**(Researcher·GL·DCF·KYC — KYC는 🟢~🟡 경계). KYC는 핀테크 도메인이라 ★.
- **YELLOW 5개** 공통점: "회사 자체 데이터를 샘플 파일로 위조"만 하면 됨. 유료 구독 필요 아님.
- **RED는 Month-End 하나** — 결산은 본질적으로 내부 GL 전체가 있어야 의미.
- **공통 패턴**: ① 데이터는 MCP/웹/수동 택1(fetch 분리) ② 산출물은 openpyxl/python-pptx로 오프라인 ③ 마지막에 사람 승인 stop. → 난이도는 "데이터를 얼마나 쉽게 공급하나"로 갈림.

### 발표 라인업 (확정 3개)

**Market Researcher → KYC → DCF** (단순→도메인→임팩트). GL Reconciler는 검증된 백업("기표는 사람" 거버넌스용).

## ✅ 실제 검증 (오프라인 테스트 완료)

`demo/` 폴더에 만들어 실제로 실행함. 전부 openpyxl/python-pptx만으로 작동 (유료데이터·MS Office·API 키 없음).

| 데모 | 실행 | 결과 |
|---|---|---|
| **Market Researcher** | `demo/01-market-researcher/build_primer_slides.py` | sector-primer.pptx 6슬라이드 생성 (라이브 구동은 세션에서, 미검증) |
| **KYC** ★ | `demo/02-kyc-screener/kyc_screen.py` | risk=high, **escalate-EDD**, 룰 R1~R7 근거 인용, R7 스크리닝 not-run |
| **GL** | `demo/03-gl-reconciler/recon.py` | 5행 중 break 4개 (Timing/FX/Quantity/GL-only) 정확 분류 |
| **DCF** | `demo/04-dcf-model-builder/build_dcf.py` + validate | validate **PASS**, live formula 83개, 주당 $46.15 / -7.7% |

→ 입력·산출물 모두 `demo/`에 커밋됨(산출물 보관). **발표는 위 3개 라인업**(Researcher·KYC·DCF) 사용, GL은 백업. `demo/` 폴더 번호는 제작 순서일 뿐 발표 순서와 무관.

## 공통 함정 (운영 노트)

1. **샘플 데이터 0개** — 레포에 xlsx·csv·pdf 하나도 없음. 입력 파일은 직접 제작. (GL=CSV 2개, DCF=가정값 몇 줄, KYC=텍스트 문서 몇 개 — 다 가벼움)
2. **`pip install openpyxl python-pptx`** 필요. 엑셀/PPT 출력이 순수 파이썬 → MS Office·네트워크 불필요 (Market Researcher 라이브만 인터넷).
3. **실행 경로**: `deploy-managed-agent.sh`(API키+서버배포) 말고 **Claude Code 플러그인 설치**(`claude plugin install`)가 로컬 데모에 제일 간단.
4. **재계산**: 이 환경엔 `recalc.py`/LibreOffice 없음 → DCF 수식 재계산 시연은 발표 때 엑셀/구글시트/LibreOffice에서 파일 열어서.

## 검증 환경

- Python 3.14.4 · openpyxl 3.1.5 · python-pptx 1.0.2
- LibreOffice/`soffice` 없음 (수식 자동 재계산 불가 — 위 4번 참고)

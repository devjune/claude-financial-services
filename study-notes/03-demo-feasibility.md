# 03. 로컬 데모 적합성 검증

> 스터디 발표 때 로컬에서 데모할 에이전트 고르기. 각 에이전트의 스킬·스크립트·쿡북을 직접 까서 "유료 MCP 없이 로컬 샘플파일로 돌아가나" 검증한 결과.

## 등급표

| 에이전트 | 등급 | 핵심 근거 |
|---|---|---|
| **GL Reconciler** | 🟢 GREEN | MCP는 회사 자체 시스템 placeholder. 핵심 로직은 제공한 파일 2개로 돌아감. 샘플 = CSV 2개 |
| **Model Builder (DCF)** | 🟢 GREEN | MCP는 데이터 fetch 전용, 빌더 서브에이전트는 `mcp_servers: []`. 가정값 수동입력 가능. `validate_dcf.py` 오프라인 검증 포함 |
| Model Builder (LBO·3-stmt) | 🟡 YELLOW | 템플릿 `examples/*.xlsx`가 레포에 없음 → 비추 |
| Model Builder (comps) | 🟢/🟡 | 돌지만 "never web search" MCP-first 규칙이 있어 오프라인 설명이 어색 |
| **KYC Screener** | 🟡 YELLOW | 시장데이터 X라 돌긴 함. 단 샘플 문서 직접 제작 + 스크리닝 MCP 단계는 skip/mock |
| Statement Auditor | 🟡 YELLOW | NAV 팩 + 명세서 둘 다 위조 필요 |
| Month-End Closer | 🔴 RED | 결산 전체가 GL MCP에서 당김. 데이터 대량 위조 → 데모 비추 |

## 공통 함정 (전부 해당)

1. **샘플 데이터 0개** — 레포에 xlsx·csv·pdf 하나도 없음. 입력 파일 전부 직접 제작. (GL=CSV 2개, DCF=가정값 몇 줄이라 쉬움)
2. **`pip install openpyxl`** 필요 (덱이면 `python-pptx`). 엑셀 출력이 순수 파이썬 → MS Office·네트워크 불필요.
3. **실행 경로**: `deploy-managed-agent.sh`(API키+서버) 말고 **Claude Code 플러그인 설치**(`claude plugin install`)가 로컬 데모에 제일 간단. `recalc.py`/LibreOffice는 환경에 없음 → 재계산은 그냥 스프레드시트 앱에서 열어서 보여주면 됨.

## 최종 결정 (데모 3종 확정)

- **① KYC Screener (확정)** — ★ 발표자가 카카오페이(한국 핀테크) 소속 → **자사 도메인과 직결**. "우리가 매일 하는 온보딩 심사가 이거다" 공감대가 최고. 룰 엔진 패턴. 텍스트 파일 몇 개 위조 + 스크리닝 단계는 not-run/mock 처리. (노란불이지만 도메인 적합성으로 채택)
- **② GL Reconciler (확정)** — CSV 2개(타이밍 break + FX break + 정상행)만 던지면 됨. `No ledger posting`("기표는 사람") 가드레일이 코드에 박혀 있어 **"AI는 초안만" 철학 데모 펀치라인**이 자동.
- **③ Model Builder = DCF만 (확정)** — 가정값 입력 → live-formula 엑셀. 결과물 임팩트 최고. LBO/3-stmt는 템플릿 없어서 제외.

> 데모 순서 제안: KYC(도메인 공감) → GL(거버넌스/사람승인) → DCF(엑셀 결과물 임팩트). 단순→철학→임팩트 흐름.

## 데모 레시피 (확정 2종)

### GL Reconciler
1. `gl.csv` / `subledger.csv` 작성 — 타이밍 break 1행(posting_date만 다름) + FX break 1행(base_amount/fx_rate 다름) + 정상 1행.
2. `claude plugin install gl-reconciler@...` (deploy 말고 플러그인).
3. 프롬프트: "이 두 추출본을 trade date 기준 대사하고, break 리포트 + 사인오프용 예외 리포트를 ./out에 xlsx로." 파일 경로 제공.
4. 결과: ABC=타이밍, DEF=FX/금액, GHI=매칭. 가드레일("ledger 기표는 사람 승인") 가리키며 마무리.

### Model Builder (DCF)
1. `pip install openpyxl`.
2. `dcf-model` + `xlsx-author` 스킬. "MCP 없음, 가정 직접 제공, ./out/model.xlsx로."
3. 가정 블록 입력: 매출 1,000 / 성장 16·14·12·10·9% / EBIT마진 25~28% / WACC 9% / terminal 3% / 민감도축 WACC 8~10%, g 2~4%.
4. openpyxl로 Inputs·DCF·WACC·민감도(5×5×3) 시트 생성. (선택) `validate_dcf.py`로 검증. 스프레드시트 앱에서 열어 가정 바꾸면 재계산되는 것 시연.

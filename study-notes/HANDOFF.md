# HANDOFF — 작업 맥락 (다른 장비/세션 이어받기용)

> 이 문서를 먼저 읽으면 지금까지의 작업 맥락을 이해할 수 있다. (이전 장비의 Claude 메모리는 이 장비로 안 넘어오므로, 핵심을 여기 담았다.) 마지막 작업: 2026-05-31.

## 0. 한 줄 요약

`anthropics/financial-services` 레포(포크)를 **스터디**하고, 그걸로 **~40분 발표 자료**를 만드는 중. 청중=백엔드(스프링) 개발자, 각도=**소프트웨어 설계 패턴**. 발표자=카카오페이(핀테크) 소속이라 KYC가 자사 도메인.

## 1. 레포 / 환경

- 작업 디렉토리: `/Users/sjune/ai-docs/study/claude-financial-services` (장비마다 경로 다를 수 있음)
- remotes: `origin` = `git@github.com:devjune/claude-financial-services.git` (포크, 여기로 push) · `upstream` = anthropics 원본
- 브랜치 `main`. **작업하면 바로 커밋+푸시**(사용자 합의). 커밋 메시지 끝에 `Co-Authored-By: Claude ...`.
- 레포 본질: 금융 4분야(IB·리서치·PE·자산관리) Claude **에이전트/스킬/커넥터 레퍼런스**. "원본 1개, 배포 2방식(Cowork 플러그인 / Managed Agents API)", "AI는 초안만, 사람이 승인".

## 2. 사용자 스타일 (중요)

- **한국어, 친구처럼 편하게.** 평서체 섞어 캐주얼하게.
- **KISS 강하게.** 군더더기 싫어함 — 지금까지 hello.py, build_primer_slides.py, render-mermaid.sh, demo-visualizer 스킬/커맨드, /research 커맨드 다 **만들었다가 사용자가 "왜 필요해?" 해서 삭제**함. 새 파일/도구 추가는 신중히, 정당성 없으면 만들지 말 것.
- **각 단계 검증 선호.** 명령어 하나씩 돌려보고 같이 확인하는 방식.
- 의사결정은 짧게 제안+추천, 사용자가 고름.

## 3. 산출물 구조

### study-notes/ (4개 + 인덱스 + 이 파일)
- `README.md` — 인덱스 (역할 경계 명시)
- `00-readme-ko.md` — 레포 README 한국어 번역 (평서체)
- `01-presentation.md` — **발표 백본**. 설계 패턴 7개(레포→패턴→스프링→SOLID/KISS/DRY) + mermaid + §3.1 에이전트별 패턴 + 40분 타임박스 + 용어집(부록 B)
- `02-demo-test.md` — 데모 난이도 매트릭스(10개) + 구현 방식
- `03-overview.md` — 레포 구조 지도 + 철학

### study-demo/ (데모)
- `README.md` — **붙여넣기용 프롬프트 4개**(레포 에이전트 직접 호출, 끝에 outputs 저장 지시)
- `scenarios/{kyc,kyc-retail,gl-recon,dcf}.md` — 데모 입력 데이터(마크다운)
- `outputs/` — **gitignore**(커밋 안 함). 결과는 라이브 생성.

## 4. 데모 방식 (★ 핵심 규칙)

- **모든 데모는 레포의 실제 에이전트·스킬을 직접 호출한다 — 재구현 금지.** (사용자 강한 요구)
- 실행: `claude` 대화형 세션에 study-demo/README의 프롬프트 붙여넣기. (헤드리스 `-p`는 스트리밍 없고 웹검색 권한에서 멈춰서 비추.)
- 산출물: Office 파일 대신 **마크다운+mermaid**(Excel/Office 대체용). 파이썬 의존성 0.
- mermaid는 첫 줄 `%%{init: {'theme':'dark'}}%%` (다크모드 가독성). 터미널선 안 보이니 저장 후 `open`(VS Code 프리뷰·GitHub 등).
- 발표 라인업 3개: **Market Researcher(오프너·라이브 웹) → KYC ★(도메인) → DCF(임팩트)**. GL은 백업.

### 4개 데모 ↔ 레포 에이전트
| 데모 | 레포 경로 | 스킬 | 기대 결과 |
|---|---|---|---|
| Market Researcher | plugins/agent-plugins/market-researcher | sector-overview·competitive-analysis·idea-generation | 섹터 노트(웹), comps `[UNSOURCED]` · **비결정적** |
| KYC ★ | plugins/agent-plugins/kyc-screener | kyc-doc-parse·kyc-rules | kyc.md→**escalate-EDD**(R2 RU·R3 PEP, R7 not-run); kyc-retail.md→request-docs |
| GL | plugins/agent-plugins/gl-reconciler | gl-recon·break-trace | 5행 중 break 4개(Timing/FX/Quantity/GL-only) |
| DCF | plugins/agent-plugins/model-builder | dcf-model | 주당 **$46.15** vs $50 → −7.7%, terminal<WACC ✓ |

## 5. 주요 결정 & 근거

- **파이썬→레포 에이전트 호출**: 처음엔 openpyxl/python-pptx로 Office 흉내, 다음엔 자작 demo-visualizer 스킬, 최종엔 **레포 실제 에이전트 직접 호출**. "스킬 스터디인데 레포 스킬을 안 쓰면 의미 없다"는 사용자 지적.
- **outputs 커밋 안 함(라이브)**: "스킬 돌리는 게 곧 데모". 재현성은 규칙 기반이라 거의 동일(Researcher만 라이브 웹이라 비결정적) → 발표 직전 한 번 돌려 저장.
- **커넥터 수정**: 레포 본문 "11 connectors"는 오류, 실제 **12개**(Box 추가). README도 12로 고침.

## 6. 다음 할 일 (TODO)

- [ ] 데모 4개를 `claude` 대화형으로 실제 구동해 검증 (KYC/GL/DCF 먼저=빠름, Researcher는 웹이라 느림). 결과 기대치와 대조.
- [ ] (선택) 검증된 결과를 발표 직전 outputs/에 저장해 백업.
- [ ] 발표 리허설 / 슬라이드화 여부 결정.

## 7. 참고

- mermaid 미리보기: 터미널에선 `base64 < x.mmd | curl "https://mermaid.ink/img/<b64>?type=png&bgColor=0d1117"` 로 PNG 렌더 가능(외부 서비스). 발표/리뷰는 GitHub·Confluence 네이티브 렌더.
- 자료는 나중에 **Confluence 위키**로 변환 예정 (mermaid 소스 유지하는 이유).

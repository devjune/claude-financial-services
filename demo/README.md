# 데모 워크스페이스

스터디 발표용 — 에이전트들을 **유료 데이터 없이 로컬에서** 실제로 돌려본 샘플 입력 + 산출물.
파일 데모의 스크립트는 해당 에이전트의 스킬(SKILL.md)을 그대로 따른 **레퍼런스 구현**이다.
(실제 에이전트는 스킬을 읽고 추론으로 같은 일을 하고 `xlsx-author`/`pptx-author`로 파일을 쓴다.)

전제: `pip install openpyxl python-pptx` (한 번). MS Office·API 키 불필요. (01만 인터넷 사용)

발표 정규 3개: **01 Researcher(라이브 훅) → 02 KYC → 04 DCF**. 00(원리)은 도입 설명용, 03(GL)은 검증된 백업. 폴더 번호 = 제작 순서(발표 순서 아님).

## 0. Hello — `00-hello-xlsx/` (원리)

공통 원리를 15줄로. xlsx-author 3원칙(파란=입력 / 검정=수식 / openpyxl로 ./out 생성).

```bash
cd 00-hello-xlsx && python3 hello.py     # -> out/hello.xlsx (Model!C2=1120)
```

## 1. Market Researcher — `01-market-researcher/` (라이브 오프너 · 서사형)

위조 파일 0, 유료데이터 0. 섹터 한 줄 던지면 에이전트가 라이브로 조사 → 스킬 오케스트레이션 시연.

```bash
pip install python-pptx && cd 01-market-researcher && python3 build_primer_slides.py   # 산출물 형태(6슬라이드)
```
- 메인은 라이브 구동(세션에서 프롬프트). 자세히는 `01-market-researcher/README.md`.
- comps 멀티플은 유료데이터 없으면 `[UNSOURCED]`. 인터넷 필요, 재현성 낮음.

## 2. KYC Screener — `02-kyc-screener/` ★ 핀테크 도메인

법인 온보딩 패킷 파싱 → 룰 그리드 → 리스크 등급/디스포지션.

```bash
cd 02-kyc-screener && python3 kyc_screen.py
```
- 입력: `packets/PKT-DEMO-001/*.txt`(위조), `rules-grid.md`, `parsed.json`(kyc-doc-parse 결과)
- 출력: `out/escalation-PKT-DEMO-001.xlsx` (4탭)
- 결과: **risk=high, escalate-EDD** — UBO 고위험국적(RU)+PEP 신고+인증 ID 누락
- 포인트: 스크리닝(R7)은 `not-run`. 스킬은 **절대 승인 안 함** — 사람(EDD)이 결정.

## 3. GL Reconciler — `03-gl-reconciler/`

총계정원장 ↔ 보조원장 대사 → break 발견·분류 → 사인오프 리포트.

```bash
cd 03-gl-reconciler && python3 recon.py
```
- 입력: `gl.csv`, `subledger.csv`(break 4종)
- 출력: `out/break-report.xlsx` (2탭)
- 결과: 5행 중 break 4개 — Timing / FX Amount / Quantity / GL only
- 포인트: 가드레일 **"기표는 사람 승인"(No ledger posting)**.

## 4. Model Builder (DCF) — `04-dcf-model-builder/`

가정값 수동 입력 → live-formula DCF 엑셀 (Inputs / DCF / WACC / Sensitivity).

```bash
cd 04-dcf-model-builder && python3 build_dcf.py
python3 ../../plugins/agent-plugins/model-builder/skills/dcf-model/scripts/validate_dcf.py out/dcf-DEMO.xlsx
```
- 출력: `out/dcf-DEMO.xlsx` — 수식 83개. 검증 **PASS**(terminal<WACC ✓). 독립검산 주당 **$46.15 / -7.7%**.

> ⚠️ 이 환경엔 LibreOffice 없음 → 수식 재계산 시연은 발표 땐 엑셀/구글시트/LibreOffice에서 파일 열어서.

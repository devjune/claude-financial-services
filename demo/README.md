# 데모 워크스페이스

스터디 발표용 — 3개 에이전트를 **유료 MCP 없이 로컬에서** 실제로 돌려본 샘플 입력 + 산출물.
각 스크립트는 해당 에이전트의 스킬(SKILL.md)을 그대로 따른 **레퍼런스 구현**이다.
(실제 에이전트는 스킬을 읽고 추론으로 같은 일을 하고 `xlsx-author`로 파일을 쓴다.)

전제: `pip install openpyxl` (한 번). 네트워크·MS Office·API 키 불필요.

## 1. KYC Screener — `kyc/` ★ 핀테크 도메인

법인 온보딩 패킷을 파싱 → 룰 그리드 적용 → 리스크 등급/디스포지션 산출.

```bash
cd kyc && python3 kyc_screen.py
```
- 입력: `packets/PKT-DEMO-001/*.txt` (위조 샘플), `rules-grid.md`(회사 룰), `parsed.json`(kyc-doc-parse 결과)
- 출력: `out/escalation-PKT-DEMO-001.xlsx` (Disposition / Rule outcomes / Risk factors / Required docs 4탭)
- 결과: **risk=high, disposition=escalate-EDD** — UBO 1명이 고위험 국적(RU) + PEP 신고 + UBO 인증 ID 누락
- 포인트: 스크리닝(R7)은 MCP 없어 `not-run`. 스킬은 **절대 스스로 승인 안 함** — 사람(EDD)이 결정.

## 2. GL Reconciler — `gl-reconciler/`

총계정원장 ↔ 보조원장 대사 → break 발견·분류 → 사인오프용 리포트.

```bash
cd gl-reconciler && python3 recon.py
```
- 입력: `gl.csv`, `subledger.csv` (break 4종 심어둠)
- 출력: `out/break-report.xlsx` (Break report / Summary 2탭)
- 결과: 5행 중 **break 4개** — Timing(ABC123) / FX Amount(DEF456) / Quantity(MNO345) / GL only(JKL012)
- 포인트: Summary 맨 아래 가드레일 — **"기표는 사람 승인"(No ledger posting)**.

## 3. Model Builder (DCF) — `dcf/`

가정값을 손으로 입력 → live-formula DCF 엑셀 생성 (Inputs / DCF / WACC / Sensitivity).

```bash
cd dcf && python3 build_dcf.py
python3 ../../plugins/agent-plugins/model-builder/skills/dcf-model/scripts/validate_dcf.py out/dcf-DEMO.xlsx
```
- 입력: 스크립트 안 가정 블록 (매출 1,000 / 성장 16~9% / WACC 9% / terminal 3% 등)
- 출력: `out/dcf-DEMO.xlsx` — 셀이 전부 실제 수식(83개). 스프레드시트에서 가정 바꾸면 재계산.
- 검증: `validate_dcf.py` → **PASS** (formula error 0, terminal growth < WACC ✓)
- 모델 결과(독립검산): 주당가치 **$46.15** vs 현재가 $50 → **-7.7%**

> ⚠️ 이 환경엔 LibreOffice가 없어 수식 재계산은 못 보여줌 → 발표 땐 엑셀/구글시트/LibreOffice에서 파일 열어 시연.

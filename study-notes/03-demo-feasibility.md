# 03. 데모 검증 기록

> 역할 분담: **난이도/선정 근거 → [04](04-agent-difficulty-matrix.md)**, **실행법 → [`demo/README.md`](../demo/README.md)**.
> 이 문서는 "선정한 데모가 실제로 오프라인 구동되는지" 직접 돌려본 검증 기록만 남긴다.

## ✅ 실제 검증 (2026-05-30, 오프라인 테스트 완료)

`demo/` 폴더에 만들어 실제로 실행함. 전부 openpyxl/python-pptx만으로 작동 (유료데이터·MS Office·API 키 없음).

| 데모 | 실행 | 결과 |
|---|---|---|
| **Market Researcher** | `demo/01-market-researcher/build_primer_slides.py` | sector-primer.pptx 6슬라이드 생성 (라이브 구동은 세션에서) |
| **KYC** ★ | `demo/02-kyc-screener/kyc_screen.py` | risk=high, **escalate-EDD**, 룰 R1~R7 근거 인용, R7 스크리닝 not-run |
| **GL** | `demo/03-gl-reconciler/recon.py` | 5행 중 break 4개 (Timing/FX/Quantity/GL-only) 정확 분류 |
| **DCF** | `demo/04-dcf-model-builder/build_dcf.py` + validate | validate **PASS**, live formula 83개, 주당 $46.15 / -7.7% |

→ 입력·산출물 모두 `demo/`에 커밋됨. 발표에 그대로 사용.

## 공통 함정 (운영 노트)

1. **샘플 데이터 0개** — 레포에 xlsx·csv·pdf 하나도 없음. 입력 파일은 직접 제작해야 함. (GL=CSV 2개, DCF=가정값 몇 줄, KYC=텍스트 문서 몇 개 — 다 가벼움)
2. **`pip install openpyxl python-pptx`** 필요. 엑셀/PPT 출력이 순수 파이썬 → MS Office·네트워크 불필요 (Market Researcher 라이브만 인터넷 사용).
3. **실행 경로**: `deploy-managed-agent.sh`(API키+서버배포) 말고 **Claude Code 플러그인 설치**(`claude plugin install`)가 로컬 데모에 제일 간단.
4. **재계산**: 이 환경엔 `recalc.py`/LibreOffice 없음 → DCF 수식 재계산 시연은 발표 때 엑셀/구글시트/LibreOffice에서 파일 열어서.

## 검증 환경

- Python 3.14.4 · openpyxl 3.1.5 · python-pptx 1.0.2
- LibreOffice/`soffice` 없음 (수식 자동 재계산 불가 — 위 4번 참고)

---
description: 섹터/테마 라이브 리서치 → 마크다운+mermaid 프라이머 (.md 저장)
argument-hint: <섹터/테마> 예) 디지털결제, AI 인프라
---

다음 섹터/테마를 **웹검색으로 리서치**해서 마크다운+mermaid 프라이머를 만들어 **파일로 저장**해줘.
(이건 Market Researcher 데모 — 시나리오 파일 없이 라이브로 구동한다.)

섹터/테마: $ARGUMENTS

구조 (sector-overview 방식):
1. **시장 개요** — 규모(TAM)·성장률(CAGR). 출처 명시, 못 찾으면 `[UNSOURCED]`.
2. **경쟁 구도** — 주요 플레이어 표 + mermaid `flowchart` (시장 → 플레이어/포지셔닝). mermaid 첫 줄 `%%{init: {'theme':'dark'}}%%`.
3. **핵심 트렌드** — 테일윈드/헤드윈드.
4. **아이디어 숏리스트** — 3~5개, 한 줄 논거.

규칙:
- 웹에서 찾은 수치는 출처 표기. 못 찾으면 `[UNSOURCED]` (지어내지 않음). comps 멀티플처럼 유료데이터 필요한 건 `[UNSOURCED]`.
- 끝에 가드레일 한 줄: **투자 권유 아님, 사람 검토용 초안.**
- 파일에는 **리포트 마크다운만** (앞뒤 설명 없이). 저장: `study-demo/outputs/research-<짧은영문이름>.md` (폴더 없으면 생성, gitignore됨).
- 최종 응답은 **저장 경로 한 줄만**.

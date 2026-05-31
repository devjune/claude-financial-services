---
description: 레포의 market-researcher 에이전트로 섹터/테마 라이브 리서치 (.md 저장)
argument-hint: <섹터/테마> 예) 디지털결제, AI 인프라
---

레포의 **실제 market-researcher 에이전트**를 그대로 사용해 아래 섹터/테마를 리서치해줘.
(우리가 새로 만드는 게 아니라, 레포가 제공하는 에이전트를 구동하는 데모다.)

- **시스템 프롬프트**: `plugins/agent-plugins/market-researcher/agents/market-researcher.md` 를 읽고 그 역할(시니어 리서치 어소시에이트)로 수행.
- **스킬**: 같은 디렉토리 `skills/` 의 `sector-overview` · `competitive-analysis` · `idea-generation` 을 따른다 (각 SKILL.md 참고).
- **섹터/테마**: $ARGUMENTS

환경 (로컬 데모):
- CapIQ/FactSet MCP 없음 → 에이전트 가드레일대로, 출처 못 대는 수치(특히 comps 멀티플)는 **`[UNSOURCED]`** 로 표기(지어내지 않음). 그 외는 웹검색.
- 산출물은 **마크다운 리서치 노트** (pptx-author 슬라이드는 생략). 경쟁 구도는 mermaid `flowchart`(첫 줄 `%%{init: {'theme':'dark'}}%%`)로.
- 끝에 에이전트 가드레일 한 줄: 배포·발간은 사람이 한다(이 에이전트는 초안만).
- 파일에 **리포트 마크다운만**. 저장: `study-demo/outputs/research-<짧은영문>.md` (폴더 없으면 생성, gitignore됨). 최종 응답은 **경로 한 줄만**.

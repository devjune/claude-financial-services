# study-demo — 레포 에이전트로 돌리는 데모

> 이 레포는 **Claude 스킬/에이전트 스터디**다. 그래서 데모는 전부 **레포의 실제 에이전트·스킬을
> 직접 호출**한다 (재구현 없음). 산출물은 Office 파일 대신 **마크다운+mermaid**(Excel/Office 대체용).

## 실행 방법

대화형 세션을 띄우고 — `cd /Users/sjune/ai-docs/study/claude-financial-services && claude` —
아래 프롬프트 중 하나를 **붙여넣고 엔터**. 권한 물으면 승인. 끝나면 저장된 `.md`를 `open`.

```bash
open study-demo/outputs/<name>.md     # mermaid는 VS Code 프리뷰·Typora·Obsidian·GitHub에서 렌더
```

> 입력 시나리오: `study-demo/scenarios/{kyc, kyc-retail, gl-recon, dcf}.md`. Researcher는 시나리오 없이 라이브 웹.
> `study-demo/outputs/`는 gitignore — 결과는 매번 라이브 생성(커밋 안 함).

---

## 데모 커맨드 (붙여넣기용)

### 1. Market Researcher — 발표 오프너 (라이브 웹, 비결정적)

```
plugins/agent-plugins/market-researcher 의 Market Researcher 에이전트로서, sector-overview·competitive-analysis·idea-generation 스킬을 따라 '디지털 결제' 섹터 리서치 노트를 만들어줘. CapIQ/FactSet MCP 없으니 못 대는 수치는 [UNSOURCED], 웹검색 사용. 경쟁 구도는 mermaid(다크 테마). 그리고 결과를 study-demo/outputs/research-payments.md 에 저장해줘(폴더 없으면 만들고).
```

### 2. KYC Screener ★ — 카카오페이 도메인

```
plugins/agent-plugins/kyc-screener 의 KYC Screener 에이전트로서, kyc-doc-parse·kyc-rules 스킬을 따라 study-demo/scenarios/kyc.md 온보딩 패킷을 심사해줘. 스크리닝 MCP 없으니 제재/PEP 스크리닝은 not-run으로. 산출물은 엑셀 대신 마크다운+mermaid — 지분 구조와 룰 판정 흐름 다이어그램(다크), 룰 결과 표, 디스포지션 포함. 승인은 사람. 그리고 결과를 study-demo/outputs/kyc.md 에 저장해줘(폴더 없으면 만들고).
```

### 3. GL Reconciler — "AI는 초안, 기표는 사람"

```
plugins/agent-plugins/gl-reconciler 의 GL Reconciler 에이전트로서, gl-recon·break-trace 스킬을 따라 study-demo/scenarios/gl-recon.md 의 GL과 보조원장을 대사해줘. 내부 MCP 없이 제공된 표만으로. 산출물은 엑셀 대신 마크다운+mermaid — 대사 파이프라인과 버킷 분포 다이어그램(다크), break 표(|Δ| 내림차순) 포함. 기표는 사람. 그리고 결과를 study-demo/outputs/gl.md 에 저장해줘(폴더 없으면 만들고).
```

### 4. Model Builder (DCF) — 임팩트 클로징

```
plugins/agent-plugins/model-builder 의 Model Builder 에이전트로서, dcf-model 스킬을 따라 study-demo/scenarios/dcf.md 의 가정으로 DCF를 계산해줘. CapIQ 없이 시나리오 가정값만 사용. 산출물은 live-formula 엑셀 대신 마크다운+mermaid — 계산 체인 다이어그램(다크), 연도별 추정·민감도 표 포함. 투자권유 아님. 그리고 결과를 study-demo/outputs/dcf.md 에 저장해줘(폴더 없으면 만들고).
```

---

## 참고

- **결정성**: Researcher만 비결정적(라이브 웹데이터). KYC/GL/DCF는 규칙 기반이라 재실행해도 거의 동일.
- **다른 시나리오**: KYC를 개인·저위험으로 보려면 `scenarios/kyc.md` → `scenarios/kyc-retail.md` (결과 escalate-EDD 대신 request-docs).
- **발표**: 관객 앞에서 `claude` 띄우고 위 프롬프트 한 줄 → 에이전트가 일하는 모습이 곧 데모. 미리 한 번 돌려 `outputs/`에 저장해두면 안전.

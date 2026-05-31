# study-demo — Claude 스킬로 만드는 데모

> 이 레포는 **Claude 스킬/에이전트 스터디**다. 그래서 데모도 파이썬 스크립트가 아니라
> **직접 작성한 Claude 스킬**(`demo-visualizer`)로 한다. 스킬이 시나리오를 읽어
> **마크다운 + mermaid.js 리포트**를 만든다 — **Excel/Office 산출물의 대체용**, 의존성 0.

## 구조

소스는 **스킬 + 시나리오** 둘뿐. 결과는 스킬을 돌려 **라이브로 생성**한다(커밋 안 함 → `.gitignore`).

```
.claude/skills/demo-visualizer/SKILL.md   ← 스킬 (프로젝트 스코프, 노하우)
.claude/commands/demo-visualizer.md       ← /demo-visualizer 슬래시 커맨드 (래퍼)
study-demo/scenarios/                       ← 입력 (kyc · kyc-retail · gl-recon · dcf)
       └─ (결과는 스킬이 그때그때 생성)
```

## 왜 이렇게 (파이썬 → 스킬, 라이브 중심)

- 이 레포의 본질은 **"SKILL.md를 어떻게 쓰는가"**다. 파이썬으로 엑셀을 찍는 건 취지와 무관 → **스킬 작성 + 마크다운/mermaid 출력**으로.
- 결과물을 미리 만들어 커밋하지 않는다. **스킬 돌리는 것 자체가 데모.** (소스 = 시나리오+스킬, 결과 = 매번 재생성)
- 마크다운+mermaid는 **GitHub·Confluence에서 그대로 렌더** — 파이썬·Office 불필요.

## 돌려보는 법

`/demo-visualizer`는 결과를 `study-demo/outputs/<arg>.md`로 **저장**한다 (gitignore됨). mermaid는 터미널에서 안 보이니 **`.md`로 만들고 `open`으로 확인**:

```bash
# 대화형 세션:  /demo-visualizer gl   →  then:
open study-demo/outputs/gl.md

# 헤드리스 한 줄:
claude -p "/demo-visualizer gl" && open study-demo/outputs/gl.md
```

`<arg>` = `kyc | kyc-retail | gl | dcf`. mermaid가 렌더되는 뷰어(VS Code 프리뷰·Typora·Obsidian 등)나 GitHub에서 열면 다이어그램까지 보인다.

## 데모 3종 (발표 라인업)

| 시나리오 | 입력 | 보여주는 것 |
|---|---|---|
| **KYC** ★ | [scenarios/kyc.md](scenarios/kyc.md) | 신뢰경계 + 룰 판정 + 승인 게이트 (지분 그래프·판정 흐름) |
| **GL 대사** | [scenarios/gl-recon.md](scenarios/gl-recon.md) | 대사 파이프라인 + break 분류 (파이 차트) |
| **DCF** | [scenarios/dcf.md](scenarios/dcf.md) | 선언적 가정 → 계산 체인 → 민감도 |

> Market Researcher(라이브 리서치)는 시나리오 파일 없이 세션에서 직접 구동 — 발표 오프너.

## 재현성 (라이브인데 항상 같게?)

결과를 커밋하지 않으니 "항상 동일"은 **스킬의 결정성 계약**에 기댄다: 섹션·표·다이어그램 구조 고정 + 숫자는 규칙으로만 결정적 도출(DCF·GL분류·룰판정 모두 deterministic). 변동 여지는 문장 표현뿐. 단, **LLM은 바이트 단위로 결정적이진 않다** — 발표 직전 한 번 돌려 확인하고 그 화면을 쓰면 안전.

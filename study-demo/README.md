# study-demo — Claude 스킬로 만드는 데모

> 이 레포는 **Claude 스킬/에이전트 스터디**다. 그래서 데모도 파이썬 스크립트가 아니라
> **직접 작성한 Claude 스킬**(`demo-visualizer`)로 한다. 스킬이 시나리오를 읽어
> **마크다운 + mermaid.js 리포트**를 만든다 — **Excel/Office 산출물의 대체용**, 의존성 0.

## 구조

스킬은 **프로젝트 스코프**로 설치되어 세션에서 바로 호출된다.

```
.claude/skills/demo-visualizer/SKILL.md   ← 직접 작성한 Claude 스킬 (프로젝트 스코프)
study-demo/
├── scenarios/   ← 입력 (kyc.md · kyc-retail.md · gl-recon.md · dcf.md)
└── outputs/     ← 스킬이 만든 골든 결과 (md+mermaid, Excel 대체용)
    └── kyc-screening.md · kyc-retail.md · gl-recon.md · dcf-valuation.md
```

> 결과의 mermaid는 **GitHub·Confluence에서 자동 렌더**된다 (별도 도구 불필요).

## 왜 이렇게 (파이썬 → 스킬)

- 이 레포의 본질은 **"SKILL.md를 어떻게 쓰는가"**다. 파이썬으로 openpyxl 엑셀을 찍는 건
  레포 취지와 무관 — 그래서 **스킬 작성 + 마크다운/mermaid 출력**으로 바꿨다.
- 마크다운+mermaid는 **GitHub·Confluence에서 그대로 렌더**되고 파이썬·Office가 필요 없다.

## 돌려보는 법 (라이브)

Claude 세션(Cowork/Claude Code)에서 `demo-visualizer` 스킬을 깔고:

```
demo-visualizer 스킬로 scenarios/kyc.md 를 시각화해줘.
```

→ Claude가 스킬을 따라 `outputs/kyc-screening.md` 같은 리포트를 만든다.

### 멱등성 (발표·리뷰용) ★

`outputs/`의 파일들은 검토·커밋된 **골든(고정) 결과**다. **발표는 라이브 재생성이 아니라 이 커밋된 파일을 그대로 쓴다** → 항상 동일.

- 골든이 진실: 재생성 시 스킬은 골든 파일을 **그대로 재현**(섹션·수치·다이어그램까지). 다르면 골든이 이긴다.
- 숫자는 규칙대로 **결정적**(DCF·GL분류·룰판정 모두 deterministic)이라, 변동 여지는 문장 표현뿐 — 스킬의 "결정성 계약"이 그것까지 억제.
- LLM은 바이트 단위로 결정적이진 않으므로, **보장은 "골든 파일 + 빡빡한 스킬"** 조합에서 나온다.

## 데모 3종 (발표 라인업)

| 시나리오 | 결과 | 보여주는 것 |
|---|---|---|
| **KYC** ★ | [kyc-screening.md](outputs/kyc-screening.md) | 신뢰경계 + 룰 판정 + 승인 게이트 (지분 그래프·판정 흐름) |
| **GL 대사** | [gl-recon.md](outputs/gl-recon.md) | 대사 파이프라인 + break 분류 (파이 차트) |
| **DCF** | [dcf-valuation.md](outputs/dcf-valuation.md) | 선언적 가정 → 계산 체인 → 민감도 |

> Market Researcher(라이브 리서치)는 시나리오 파일이 아니라 세션에서 직접 구동 — 발표 오프너.

---
description: demo-visualizer 스킬로 데모 시나리오를 마크다운+mermaid로 시각화
argument-hint: kyc | kyc-retail | gl | dcf | <scenario 파일 경로>
---

`.claude/skills/demo-visualizer/SKILL.md` 스킬을 따라, 아래 시나리오를 시각화한
마크다운+mermaid 리포트를 만들어줘.

시나리오: $ARGUMENTS

- 약어면 `study-demo/scenarios/` 에서 매핑: `kyc`→kyc.md · `kyc-retail`→kyc-retail.md · `gl`→gl-recon.md · `dcf`→dcf.md
- 파일 경로면 그 파일을 그대로 사용.

규칙:
- `study-demo/outputs/` 의 골든 파일은 **참고하지 말고** 시나리오 데이터로만 생성 (멱등성 확인용).
- 스킬의 **결정성 계약**을 따른다 (섹션·표·수치·다이어그램 고정, 자유 서술 금지).
- 리포트 **마크다운 본문만** 출력.

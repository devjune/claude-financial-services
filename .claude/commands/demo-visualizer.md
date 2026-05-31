---
description: demo-visualizer 스킬로 데모 시나리오를 시각화해 .md 파일로 저장
argument-hint: kyc | kyc-retail | gl | dcf | <scenario 파일 경로>
---

`.claude/skills/demo-visualizer/SKILL.md` 스킬을 따라, 아래 시나리오를 시각화한
마크다운+mermaid 리포트를 만들어 **파일로 저장**해줘.

시나리오: $ARGUMENTS

- 약어 매핑(`study-demo/scenarios/`): `kyc`→kyc.md · `kyc-retail`→kyc-retail.md · `gl`→gl-recon.md · `dcf`→dcf.md
- 파일 경로면 그 파일을 그대로 사용.
- **저장 경로**: `study-demo/outputs/$ARGUMENTS.md` (디렉토리 없으면 생성). 이 폴더는 gitignore됨.

규칙:
- 골든 없음 — `study-demo/scenarios/` + 스킬 규칙만으로 생성 (결정성 계약 준수).
- 파일에는 **리포트 마크다운만** (앞뒤 설명·인사·질문 없이).
- 최종 응답은 **저장 경로 한 줄만** 출력: 예) `→ study-demo/outputs/gl.md  (open 으로 확인)`

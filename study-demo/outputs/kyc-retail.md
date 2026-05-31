# KYC 스크리닝 결과 — PKT-RETAIL-007 (Kim Min-jun)

> 📄 **Excel/Office 산출물 대체용** — 마크다운+mermaid 시각화 (파이썬 의존성 없음).
> 입력: [`scenarios/kyc-retail.md`](../scenarios/kyc-retail.md) · 스킬: [`demo-visualizer`](../../.claude/skills/demo-visualizer/SKILL.md)

## 신청자

| 항목 | 값 |
|---|---|
| 신청자 | Kim Min-jun |
| 유형 / 관할 | individual / 대한민국 (KR) |
| 리스크 등급 | **LOW** |
| 디스포지션 | **request-docs** |

## 지분 구조

개인(individual) 신청자 — UBO/지분 구조 **해당 없음**(본인이 직접 보유). 지분 그래프 생략.

## 룰 판정 흐름

```mermaid
%%{init: {'theme':'dark'}}%%
flowchart LR
  P["패킷 PKT-RETAIL-007"] --> R1["R1 관할 KR<br/>✅ 오프쇼어 아님"]
  R1 --> R2["R2 고위험 국적?<br/>✅ 아님"]
  R2 --> R3["R3 PEP?<br/>✅ 아님"]
  R3 --> R5["R5 주소증빙<br/>❌ 누락"]
  R5 --> R7["R7 제재 스크리닝<br/>⏸ not-run (MCP 없음)"]
  R7 --> DSP["risk: LOW<br/>request-docs"]
  DSP --> H["주소증빙 수령 후 재심사"]
```

## 룰 결과

| rule_id | outcome | 근거 |
|---|---|---|
| R1 | pass | 관할 KR (오프쇼어 아님) |
| R2 | pass | 국적 KR (고위험 아님) |
| R3 | pass | PEP 신고 없음 |
| R4 | pass | 인증 신분증(주민등록증) 존재 |
| R5 | **fail** | 주소 증빙 누락 |
| R6 | pass | 자금출처 ref SOF-SAL-2026-0142 |
| R7 | n/a | 스크리닝 MCP 없음 — **clear 전 반드시 실행** |

**누락 서류**: 주소 증빙(utility bill/은행 명세)
**에스컬레이션 사유**: 없음 (R2/R3/R7 미발동)

> ⚠️ **스킬은 승인하지 않는다.** 점수·라우팅만 하고, 최종 판단은 사람(심사자)이 한다. 여기선 주소증빙 보완 요청 후 재심사.

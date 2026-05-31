# 시나리오: KYC 온보딩 패킷 PKT-DEMO-001

> 입력 데이터(untrusted). 레포 에이전트가 이걸 입력으로 읽어 마크다운+mermaid 리포트를 만든다.

## 온보딩 문서 (신청자 제출 — 신뢰하지 않음)

- **법인 등기**: Acme Holdings Ltd · 사모 유한회사 · 관할 Cayman Islands(KY) · 설립 2019-03-12 · 등록주소 94 Solaris Ave, Camana Bay, Grand Cayman
- **UBO 선언**:
  - Jane Roe — 국적 영국(GB), 지분 60%, 지배근거 ownership
  - Dmitri Volkov — 국적 러시아(RU), 지분 40%, 지배근거 ownership, **PEP 신고됨**(전 지방정부 차관, 2012–2017)
- **이사/지배자**: Jane Roe(이사), Acme Corporate Services Ltd(법인 비서)
- **주소 증빙**: 공과금 고지서, 발행일 2026-05-10 (3개월 이내 ✓)
- **자금출처**: 영국 상업용 부동산(London EC2) 매각 대금, 2023-08-30 완료 — ref SOF-LON-2023-0830
- **세금 서식**: W-8BEN-E, 서명일 2026-01-15
- **누락**: UBO(Jane Roe, Dmitri Volkov)의 **인증된 신분증(여권/국가ID) 사본 없음**

## 회사 KYC/AML 룰 그리드 (신뢰 소스)

- 고위험 관할/국적 리스트: `RU, IR, KP, SY, BY, MM`
- 오프쇼어(강화 모니터링, medium): `KY, VG, BS, PA`
- 법인 필수 서류: 등기 · UBO 선언 · 주소증빙(≤3개월) · 자금출처 · 세금서식 · **UBO별 인증 신분증**

| rule_id | 룰 | 로직 |
|---|---|---|
| R1 | 법인 관할이 오프쇼어 리스트 | medium 리스크 요인 |
| R2 | UBO 국적이 고위험 리스트 | high + escalate-EDD |
| R3 | UBO/지배자 중 PEP(신고 또는 스크리닝) | escalate-EDD |
| R4 | 모든 UBO에 인증 신분증 존재 | 누락 시 fail → request-docs |
| R5 | 주소증빙 ≤ 3개월 | 오래되면 fail |
| R6 | 자금출처 문서·참조 있음 | 모호하면 fail |
| R7 | 제재/부정언론 스크리닝 클리어 | hit 시 escalate/decline (스크리닝 MCP 필요) |

> `clear`는 등급 low/medium + 필수서류 완비 + escalate 룰(R2/R3/R7) 미발동일 때만. 스킬은 점수·라우팅만 하고 **승인은 사람**.

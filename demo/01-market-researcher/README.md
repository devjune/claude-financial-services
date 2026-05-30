# 01. Market Researcher — 라이브 오프너 데모

세 파일 데모(KYC/GL/DCF)와 성격이 다른 **에이전트/서사형** 데모. 위조 파일 0,
유료 데이터 0 — 인터넷만 있으면 "에이전트가 라이브로 조사하는 과정"을 보여준다.
발표 오프너로 적합.

## 두 가지로 보여줄 수 있다

### (A) 라이브 — 에이전트를 실제로 구동 (메인)
Claude 세션(Cowork 또는 Claude Code 플러그인)에서 섹터/테마 한 줄을 던진다:

```
디지털 결제/핀테크 섹터 primer 만들어줘. 앵글은 "지역 디지털지갑·임베디드
파이낸스 확산". 웹검색으로 시장규모·플레이어 찾고, comps 멀티플은 유료 데이터가
없으면 [UNSOURCED]로 표시해줘.
```

그러면 에이전트가 스킬을 순서대로 호출하는 걸 라이브로 보여준다:
`sector-overview` → `competitive-analysis` → (`comps-analysis`) → `idea-generation` → `pptx-author`

- 데이터 없이 도는 부분: 산업 개요·경쟁 구도·아이디어 (Claude 지식 + 웹검색)
- 약해지는 부분: comps 멀티플 — CapIQ/FactSet 없으면 `[UNSOURCED]` (가드레일대로)
- 가드레일: "draft만, 배포는 사람" — 발표 펀치라인

### (B) 산출물 형태 — 슬라이드 셸 오프라인 생성 (보조)
라이브가 부담되면, 에이전트가 마지막에 `pptx-author`로 뽑는 덱의 **형태**를
오프라인으로 재현:

```bash
pip install python-pptx
python3 build_primer_slides.py     # -> out/sector-primer.pptx (6슬라이드)
```
- sector-overview 6단계 구조를 슬라이드로: 타이틀 → 시장개요 → 트렌드 → 경쟁구도(표) → 밸류에이션 → 아이디어
- `[web]` = 라이브 에이전트가 웹검색으로 채우는 칸, `[UNSOURCED]` = 유료데이터 필요 칸

## 데모에서 말할 포인트

- "파일 안 줘도 됨 — 섹터 이름만." → 셋업 마찰 최저
- "스킬이 순서대로 불리는 게 보임" → 에이전트 = 스킬 오케스트레이션
- "숫자는 출처 없으면 [UNSOURCED]" → 환각 대신 정직, 규제산업 태도
- 단점도 솔직히: 인터넷 의존, 매번 결과 다름(재현성 낮음), comps 약함

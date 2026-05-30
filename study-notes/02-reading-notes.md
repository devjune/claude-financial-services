# 02. 리딩 노트 (핵심만 누적)

> README를 읽으며 나온 핵심/깨달음을 한 줄씩 쌓는 곳. 정독하며 계속 추가.

## 큰 철학

- **에이전트·스킬·데이터 커넥터** 세 가지 모음. 셋 다 필요하지만, 알맹이(노하우)는 **스킬**에 다 들어있음.
- **원본 1개, 배포 2방식** (two ways from one source): 같은 시스템 프롬프트+스킬을 ① Cowork 플러그인(사람이 직접) ② Managed Agents API(서버 자동)로 씀.
- **AI는 초안만, 결정은 사람** — 권유/거래실행/리스크확정/기표/온보딩승인은 안 함. 전부 사람 승인 대기(staged for human sign-off). 금융=규제산업이라 책임 경계를 명확히 그음.

## 구조

- 두 덩어리: **완성품(agent-plugins)** vs **부품(vertical-plugins)**. 가볍게 쓰려면 vertical만.
- 4대 분야: 투자은행(IB) / 주식 리서치 / 사모펀드(PE) / 자산관리. FSI = Financial Services Industry.

## 용어 메모

- **Reference(레퍼런스)** = 완제품 아님. 보고 배우고 변형하는 본보기.
- **Cowork** = 앤트로픽 데스크톱/웹 작업 앱. 사람이 직접 대화하며 일함.
- **Managed Agents API** = 서버에서 자동으로 에이전트 돌리는 API. `/v1/agents`로 배포.

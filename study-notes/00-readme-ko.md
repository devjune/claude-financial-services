# README 번역본

> 원문: [README.md](../README.md) · 학습용 한국어 번역. 의역 포함. 평서체(~이다). 금융 용어는 실무 표현 유지.

---

# 금융 서비스를 위한 Claude

우리가 가장 자주 보는 금융 서비스 워크플로 — 투자은행(IB), 주식 리서치, 사모펀드(PE), 자산관리 — 를 위한 **레퍼런스 에이전트, 스킬, 데이터 커넥터** 모음이다.

여기 있는 모든 것은 **하나의 소스에서 두 가지 방식으로** 쓸 수 있다: [Claude Cowork](https://claude.com/product/cowork) 플러그인으로 설치하거나, 회사 자체 워크플로 엔진 뒤에서 [Claude Managed Agents API](https://docs.claude.com/en/api/managed-agents)로 배포하거나. 같은 시스템 프롬프트, 같은 스킬 — 어디서 돌릴지는 네가 정한다.

> [!IMPORTANT]
> 이 저장소의 어떤 것도 투자·법률·세무·회계 자문이 아니다. 이 에이전트들은 자격을 갖춘 전문가의 검토를 위한 **애널리스트 작업물 초안**(모델, 메모, 리서치 노트, 대사 자료)을 작성할 뿐이다. 투자 권유를 하거나, 거래를 실행하거나, 리스크를 확정하거나, 원장에 기표하거나, 온보딩을 승인하지 않는다. 모든 산출물은 사람의 최종 승인을 위해 준비된 상태(staged)다. 산출물 검증과 회사에 적용되는 법규 준수의 책임은 너에게 있다.

저장소에 담긴 것:

- **[에이전트(Agents)](#에이전트)** — 이름이 붙은, 처음부터 끝까지(end-to-end) 워크플로를 수행하는 에이전트 (Pitch Agent, Market Researcher, GL Reconciler 등). 각각 Cowork 플러그인으로도, `/v1/agents`로 배포하는 [Claude Managed Agent 템플릿](./managed-agent-cookbooks)으로도 제공된다.
- **[Vertical 플러그인](#vertical-플러그인)** — 그 바탕이 되는 스킬, 슬래시 커맨드, 데이터 커넥터를 금융(FSI) 분야별로 묶은 것. 풀 에이전트 없이 `/comps`, `/dcf`, `/earnings`랑 커넥터만 원하면 이것만 따로 설치하면 된다.

## 에이전트

각 에이전트는 자신이 수행하는 워크플로 이름을 그대로 가진다. 이들은 **출발점**이다: 내 업무에 맞는 걸 설치한 뒤, 프롬프트·스킬·커넥터를 우리 회사 방식에 맞게 튜닝하면 된다.

각 에이전트 플러그인은 **자기완결적(self-contained)**이다 — 자신이 쓰는 스킬을 함께 번들로 담고 있어서, 에이전트만 설치하면 끝이다.

| 기능 | 에이전트 | 하는 일 |
|---|---|---|
| **커버리지 & 자문** | **[Pitch Agent](./plugins/agent-plugins/pitch-agent)** | 컴스·선례거래·LBO → 브랜딩된 피치덱, 처음부터 끝까지 |
| | **[Meeting Prep Agent](./plugins/agent-plugins/meeting-prep-agent)** | 모든 고객 미팅 전 브리핑 팩 |
| **리서치 & 모델링** | **[Market Researcher](./plugins/agent-plugins/market-researcher)** | 섹터/테마 → 산업 개요, 경쟁 구도, 피어 컴스, 아이디어 숏리스트 |
| | **[Earnings Reviewer](./plugins/agent-plugins/earnings-reviewer)** | 실적 콜 + 공시 → 모델 업데이트 → 노트 초안 |
| | **[Model Builder](./plugins/agent-plugins/model-builder)** | DCF, LBO, 3-statement, 컴스 — 엑셀에서 직접 |
| **펀드 어드민 & 재무 운영** | **[Valuation Reviewer](./plugins/agent-plugins/valuation-reviewer)** | GP 패키지 인제스트, 밸류에이션 템플릿 실행, LP 리포팅 준비 |
| | **[GL Reconciler](./plugins/agent-plugins/gl-reconciler)** | 불일치(break) 발견, 근본원인 추적, 승인 라우팅 |
| | **[Month-End Closer](./plugins/agent-plugins/month-end-closer)** | 발생주의(accruals), 롤포워드, 차이(variance) 코멘터리 |
| | **[Statement Auditor](./plugins/agent-plugins/statement-auditor)** | 배포 전 LP 명세서 감사 |
| **운영 & 온보딩** | **[KYC Screener](./plugins/agent-plugins/kyc-screener)** | 온보딩 문서 파싱, 룰 엔진 실행, 누락 플래그 |

Managed Agent 배포 관련(`agent.yaml`, 리프 워커 서브에이전트, 스티어링 이벤트 예시, 에이전트별 보안 노트)은 **[managed-agent-cookbooks/](./managed-agent-cookbooks)** 참고.

## 저장소 레이아웃

```
plugins/
  agent-plugins/               # 이름 붙은 에이전트 — 각각 자기완결형 플러그인 하나
  vertical-plugins/            # FSI 분야별 스킬+커맨드 묶음, 그리고 MCP 커넥터
  partner-built/               # 파트너가 만든 플러그인 (LSEG, S&P Global)
managed-agent-cookbooks/       # Claude Managed Agent 쿡북 — 에이전트당 디렉토리 하나
claude-for-msft-365-install/   # Claude Microsoft 365 애드인 프로비저닝용 어드민 도구
scripts/                       # deploy-managed-agent.sh · check.py · validate.py · orchestrate.py · sync-agent-skills.py
```

## 시작하기

### Cowork

Cowork에서 **Settings → Plugins → Add plugin** 열고 둘 중 하나:

- **이 레포 URL 붙여넣기** — `https://github.com/anthropics/financial-services` — 그다음 마켓플레이스 목록에서 원하는 에이전트와 vertical 선택, 또는
- **zip 업로드** — `plugins/` 아래 아무 디렉토리(예: `plugins/agent-plugins/pitch-agent/`)를 zip으로 묶어서 끌어다 놓기.

### Claude Code

```bash
# 마켓플레이스 추가
claude plugin marketplace add anthropics/financial-services

# 핵심 스킬 + 커넥터 (먼저 설치)
claude plugin install financial-analysis@claude-for-financial-services

# 이름 붙은 에이전트 — 원하는 것 선택
claude plugin install pitch-agent@claude-for-financial-services
claude plugin install gl-reconciler@claude-for-financial-services
claude plugin install market-researcher@claude-for-financial-services

# Vertical 스킬 묶음
claude plugin install investment-banking@claude-for-financial-services
claude plugin install equity-research@claude-for-financial-services
```

설치하면 에이전트는 Cowork 디스패치에 나타나고, 스킬은 관련 있을 때 자동 발동, 슬래시 커맨드는 세션에서 사용 가능(`/comps`, `/dcf`, `/earnings`, `/ic-memo` 등).

### Claude Managed Agents

```bash
export ANTHROPIC_API_KEY=sk-ant-...
scripts/deploy-managed-agent.sh gl-reconciler
```

[`managed-agent-cookbooks/`](./managed-agent-cookbooks) 아래 각 템플릿은 플러그인 짝과 **동일한 시스템 프롬프트와 스킬을 참조**한다. 배포 스크립트가 파일 참조를 해석하고, 스킬을 업로드하고, 리프 워커 서브에이전트를 생성하고, 오케스트레이터를 `/v1/agents`에 POST한다. 자체 오케스트레이션 레이어를 통해 에이전트 간 `handoff_request` 이벤트를 라우팅하는 레퍼런스 이벤트 루프는 [`scripts/orchestrate.py`](./scripts/orchestrate.py) 참고.

> **리서치 프리뷰:** 서브에이전트 위임(`callable_agents`)은 프리뷰 기능이다. 보안 및 핸드오프 가이드는 에이전트별 README 참고.

## 어떻게 맞물리나 (How It Fits Together)

| | 무엇인가 | 어디 있나 |
|---|---|---|
| **에이전트(Agents)** | 워크플로를 처음부터 끝까지 소유하는 자기완결형 플러그인 — 시스템 프롬프트 + 그것이 쓰는 스킬. Cowork와 Managed Agent 래퍼 둘 다 **같은 디렉토리**를 참조. | `plugins/agent-plugins/<slug>/` |
| **스킬(Skills)** | 도메인 전문지식, 관행, 단계별 방법. 관련 있을 때 Claude가 자동으로 끌어다 씀. vertical에서 **한 번만 작성**되고, 각 에이전트는 필요한 것의 **동기화된 사본**을 번들로 가짐. | `plugins/vertical-plugins/<vertical>/skills/` (원본) · `plugins/agent-plugins/<slug>/skills/` (번들 사본) |
| **커맨드(Commands)** | 명시적으로 호출하는 슬래시 액션(`/comps`, `/earnings`, `/ic-memo`). | `plugins/vertical-plugins/<vertical>/commands/` |
| **커넥터(Connectors)** | Claude를 당신 데이터에 연결하는 [MCP 서버](https://modelcontextprotocol.io/) — 터미널, 리서치 플랫폼, 문서 저장소. | `plugins/vertical-plugins/financial-analysis/.mcp.json` |
| **Managed-agent 래퍼** | headless 배포용 `agent.yaml` + 깊이 1 서브에이전트 + 스티어링 예시. | `managed-agent-cookbooks/<slug>/` |

모든 것이 **파일 기반** — 마크다운과 JSON, 빌드 단계 없음.

## Vertical 플러그인

**financial-analysis**부터 시작하면 된다 — 공유 모델링 스킬과 모든 데이터 커넥터를 담고 있다. 필요한 워크플로에 맞는 vertical을 추가하면 된다.

| 플러그인 | 추가되는 것 |
|---|---|
| **[financial-analysis](./plugins/vertical-plugins/financial-analysis)** *(코어)* | 컴스, DCF, LBO, 3-statement, 덱 QC, 엑셀 감사. 데이터 커넥터 12개 전부 (아래 MCP 표 참고 — 원문은 "11"이나 Box 추가로 실제 12개). |
| **[investment-banking](./plugins/vertical-plugins/investment-banking)** | CIM, 티저, 프로세스 레터, 바이어 리스트, 합병 모델, 딜 트래킹. |
| **[equity-research](./plugins/vertical-plugins/equity-research)** | 실적 노트, 커버리지 개시, 모델 업데이트, 논리(thesis)·촉매(catalyst) 추적. |
| **[private-equity](./plugins/vertical-plugins/private-equity)** | 소싱, 스크리닝, 실사 체크리스트, IC 메모, 포트폴리오 모니터링. |
| **[wealth-management](./plugins/vertical-plugins/wealth-management)** | 고객 리뷰, 재무 설계, 리밸런싱, 리포팅, TLH(절세 매도). |
| **[fund-admin](./plugins/vertical-plugins/fund-admin)** | GL 대사, 불일치 추적, 발생주의, 롤포워드, 차이 코멘터리, NAV 타이아웃. |
| **[operations](./plugins/vertical-plugins/operations)** | KYC 문서 파싱과 룰 그리드 평가. |
| **[lseg](./plugins/partner-built/lseg)** *(파트너)* | 채권 RV, 스왑 커브, FX 캐리, 옵션 변동성, 매크로 금리 모니터링 (LSEG 데이터). |
| **[sp-global](./plugins/partner-built/spglobal)** *(파트너)* | 티어시트, 실적 프리뷰, 펀딩 다이제스트 (S&P Capital IQ). |

## MCP 통합

모든 커넥터는 **financial-analysis** 코어 플러그인에 모여 있고 나머지에서 공유된다.

| 제공자 | URL |
|---|---|
| [Daloopa](https://www.daloopa.com/) | `https://mcp.daloopa.com/server/mcp` |
| [Morningstar](https://www.morningstar.com/) | `https://mcp.morningstar.com/mcp` |
| [S&P Global](https://www.spglobal.com/) | `https://kfinance.kensho.com/integrations/mcp` |
| [FactSet](https://www.factset.com/) | `https://mcp.factset.com/mcp` |
| [Moody's](https://www.moodys.com/) | `https://api.moodys.com/genai-ready-data/m1/mcp` |
| [MT Newswires](https://www.mtnewswires.com/) | `https://vast-mcp.blueskyapi.com/mtnewswires` |
| [Aiera](https://www.aiera.com/) | `https://mcp-pub.aiera.com` |
| [LSEG](https://www.lseg.com/) | `https://api.analytics.lseg.com/lfa/mcp` |
| [PitchBook](https://pitchbook.com/) | `https://premium.mcp.pitchbook.com/mcp` |
| [Chronograph](https://www.chronograph.pe/) | `https://ai.chronograph.pe/mcp` |
| [Egnyte](https://www.egnyte.com/) | `https://mcp-server.egnyte.com/mcp` |
| [Box](https://www.box.com/home) | `https://mcp.box.com` |

> MCP 접근에는 제공자의 구독이나 API 키가 필요할 수 있다.

## Claude for Microsoft 365 — 설치 도구

회사에서 Microsoft 365 애드인을 통해 Excel·PowerPoint·Word·Outlook 안에서 Claude를 돌린다면, [`claude-for-msft-365-install/`](./claude-for-msft-365-install)이 그것을 **당신 자체 클라우드**(Vertex AI, Bedrock, 또는 내부 LLM 게이트웨이) — 앤트로픽 API가 아니라 — 에 맞춰 프로비저닝하는 어드민 도구다.

이것은 (Cowork 플러그인이 아니라) **Claude Code 플러그인**으로, IT 관리자가 커스텀 애드인 매니페스트 생성, Azure 관리자 동의 부여, Microsoft Graph로 사용자별 라우팅 설정 작성을 단계별로 진행하도록 안내한다. 설치:

```bash
claude plugin install claude-for-msft-365-install@claude-for-financial-services
/claude-for-msft-365-install:setup
```

이것은 위의 에이전트·vertical 플러그인과 **별개**다 — 테넌트에 애드인을 배포하는 진입로(on-ramp)이고, 그 후 여기 있는 에이전트와 스킬이 그 안에서 돌아간다.

## 내 것으로 만들기 (Making It Yours)

이것들은 레퍼런스 템플릿이다 — 우리 회사 방식에 맞게 튜닝할수록 좋아진다.

- **커넥터 교체** — `.mcp.json`을 당신의 데이터 제공자와 내부 시스템으로 향하게 하기.
- **회사 컨텍스트 추가** — 용어, 프로세스, 포맷 기준을 스킬 파일에 넣기.
- **당신 템플릿 가져오기** — `/ppt-template`로 Claude에게 브랜딩된 PPT 레이아웃 학습시키기.
- **에이전트 범위 조정** — `agents/<slug>.md`를 팀이 실제 일하는 방식에 맞게 수정.
- **직접 추가** — 다루지 않은 워크플로는 구조를 복사해서 만들기.

## 스킬 & 커맨드 레퍼런스

<details>
<summary><b>financial-analysis</b> — 코어 모델링, 엑셀, 덱 QC</summary>

| 스킬 | 커맨드 | 설명 |
|---|---|---|
| comps-analysis | `/comps` | 거래 배수 기반 비교기업 분석 |
| dcf-model | `/dcf` | WACC와 민감도 분석 포함 DCF 밸류에이션 |
| lbo-model | `/lbo` | 차입매수(LBO) 모델 |
| 3-statement-model | `/3-statement-model` | 3-statement 재무모델 템플릿 채우기 |
| audit-xls | `/debug-model` | 엑셀 모델 감사 — 수식 추적, 하드코드 탐지, 밸런스 체크 |
| clean-data-xls | — | 엑셀 표 데이터 정규화·정리 |
| deck-refresh | — | 덱 전반의 차트/표 재연결·새로고침 |
| competitive-analysis | `/competitive-analysis` | 경쟁 구도와 시장 포지셔닝 |
| ib-check-deck | — | 프레젠테이션 오류·일관성 QC |
| pptx-author | — | headless로 `.pptx` 생성 (Managed Agent 모드) |
| xlsx-author | — | headless로 `.xlsx` 생성 (Managed Agent 모드) |
| ppt-template-creator | `/ppt-template` | 재사용 가능한 PPT 템플릿 스킬 생성 |
| skill-creator | — | 새 스킬 만들기 가이드 |

</details>

<details>
<summary><b>investment-banking</b> — 딜 자료와 실행</summary>

| 스킬 | 커맨드 | 설명 |
|---|---|---|
| strip-profile | `/one-pager` | 피치북용 1페이지 기업 프로필 |
| pitch-deck | — | 피치덱 템플릿에 데이터 채우기 |
| datapack-builder | — | CIM과 공시로 데이터 팩 구축 |
| cim-builder | `/cim` | 비밀유지 정보각서(CIM) 초안 |
| teaser | `/teaser` | 익명 1페이지 기업 티저 |
| buyer-list | `/buyer-list` | 전략적·재무적 인수후보 유니버스 |
| merger-model | `/merger-model` | 인수 후 주당이익 증감(accretion/dilution) M&A 분석 |
| process-letter | `/process-letter` | 입찰 지침과 프로세스 서신 |
| deal-tracker | `/deal-tracker` | 진행 중인 딜·마일스톤·액션 추적 |

</details>

<details>
<summary><b>equity-research</b> — 커버리지와 발간</summary>

| 스킬 | 커맨드 | 설명 |
|---|---|---|
| earnings-analysis | `/earnings` | 실적 발표 후 분기 업데이트 리포트 |
| earnings-preview | `/earnings-preview` | 실적 전 시나리오 분석과 핵심 지표 |
| initiating-coverage | `/initiate` | 기관 수준 커버리지 개시 리포트 |
| model-update | `/model-update` | 신규 데이터로 재무모델 업데이트 |
| morning-note | `/morning-note` | 모닝 미팅 노트와 트레이드 아이디어 |
| sector-overview | `/sector` | 산업 구도와 테마 리포트 |
| thesis-tracker | `/thesis` | 투자 논리 유지·업데이트 |
| catalyst-calendar | `/catalysts` | 커버리지 전반의 예정 촉매 추적 |
| idea-generation | `/screen` | 종목 스크리닝과 아이디어 소싱 |

</details>

<details>
<summary><b>private-equity</b> — 소싱부터 포트폴리오 운영까지</summary>

| 스킬 | 커맨드 | 설명 |
|---|---|---|
| deal-sourcing | `/source` | 기업 발굴, CRM 확인, 창업자 아웃리치 초안 |
| deal-screening | `/screen-deal` | 인바운드 CIM·티저 빠른 통과/탈락 판정 |
| dd-checklist | `/dd-checklist` | 워크스트림별 실사 체크리스트 |
| dd-meeting-prep | `/dd-prep` | 경영진 PT·전문가 콜 준비 |
| unit-economics | `/unit-economics` | ARR 코호트, LTV/CAC, 순유지율, 매출 품질 |
| returns-analysis | `/returns` | IRR/MOIC 민감도 표 |
| ic-memo | `/ic-memo` | 투자위원회(IC) 메모 초안 |
| portfolio-monitoring | `/portfolio` | 포트폴리오사 KPI·차이 추적 |
| value-creation-plan | `/value-creation` | 인수 후 100일 계획과 EBITDA 브릿지 |
| ai-readiness | `/ai-readiness` | 포트폴리오사 AI 준비도 평가 |

</details>

<details>
<summary><b>wealth-management</b> — 어드바이저 워크플로</summary>

| 스킬 | 커맨드 | 설명 |
|---|---|---|
| client-review | `/client-review` | 성과·토킹포인트와 함께 고객 미팅 준비 |
| financial-plan | `/financial-plan` | 은퇴·교육·상속·현금흐름 추정 |
| portfolio-rebalance | `/rebalance` | 배분 이탈 분석과 세금 고려 리밸런싱 |
| client-report | `/client-report` | 고객 대상 성과 리포트 |
| investment-proposal | `/proposal` | 잠재 고객 대상 제안서 |
| tax-loss-harvesting | `/tlh` | TLH 기회 식별과 워시세일 관리 |

</details>

## 기여 (Contributing)

여기 있는 모든 것은 마크다운과 YAML이다. 포크, 수정, PR. 새 콘텐츠:

- 새 스킬 → `plugins/vertical-plugins/<vertical>/skills/` 아래 추가, 그다음 `python3 scripts/sync-agent-skills.py`로 그걸 번들하는 에이전트에 전파.
- 새 에이전트 → `plugins/agent-plugins/<slug>/` (`agents/<slug>.md` + `skills/`) 와 짝이 되는 `managed-agent-cookbooks/<slug>/`.
- 푸시 전 `python3 scripts/check.py` 실행 — 모든 매니페스트를 린트하고, 모든 교차 파일 참조가 해석되는지 확인하고, 번들된 스킬이 vertical 원본과 어긋났으면 실패시킴.

## 라이선스

[Apache License 2.0](../LICENSE)

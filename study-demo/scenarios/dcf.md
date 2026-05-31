# 시나리오: DCF 밸류에이션 — DEMO Corp

> 입력 가정(전부 수동 입력 — 유료 시장데이터 불필요). `demo-visualizer` 스킬이 이걸 읽어 마크다운+mermaid 리포트를 만든다. 단위 $M.

## 기준 입력

| 항목 | 값 |
|---|---|
| 최근 매출 (FY0) | 1,000 |
| 희석 주식수 (M) | 100 |
| 순부채 | 200 |
| 현재 주가 ($) | 50.00 |
| 세율 | 25% |
| WACC | 9.0% |
| Terminal growth | 3.0% |

## 연도별 가정 (FY1–FY5)

| 항목 | FY1 | FY2 | FY3 | FY4 | FY5 |
|---|---|---|---|---|---|
| 매출 성장 | 16% | 14% | 12% | 10% | 9% |
| EBIT 마진 | 25% | 26% | 27% | 28% | 28% |
| D&A % 매출 | 4% | 4% | 4% | 4% | 4% |
| Capex % 매출 | 5% | 5% | 5% | 5% | 5% |
| ΔNWC % of Δ매출 | 10% | 10% | 10% | 10% | 10% |

## 계산 규칙

- 매출(t) = 매출(t-1) × (1+성장)
- FCF = EBIT×(1−세율) + D&A − Capex − ΔNWC
- 할인계수 = 1/(1+WACC)^t · PV(FCF) = FCF × 할인계수
- Terminal value = FCF(FY5)×(1+g)/(WACC−g) · PV(TV) = TV × 할인계수(FY5)
- Enterprise value = Σ PV(FCF) + PV(TV) · Equity = EV − 순부채 · 주당 = Equity / 주식수
- 민감도: WACC 8.5/9.0/9.5% × terminal growth 2.5/3.0/3.5%

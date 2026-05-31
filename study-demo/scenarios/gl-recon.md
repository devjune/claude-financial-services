# 시나리오: GL ↔ 보조원장 대사 (2026-05-05, 주식)

> 입력 데이터. `demo-visualizer` 스킬이 이걸 읽어 `outputs/gl-recon.md`를 만든다.
> 키 = security_id + account + trade_date. 허용오차: 금액 0.01, 수량 0.

## 총계정원장 (GL)

| security_id | account | trade_date | quantity | local_amount | base_amount | fx_rate | posting_date |
|---|---|---|---|---|---|---|---|
| ABC123 | 11420 | 2026-05-05 | 1000 | 50000.00 | 50000.00 | 1.0000 | 2026-05-07 |
| DEF456 | 21330 | 2026-05-05 | 2000 | 40000.00 | 43600.00 | 1.0900 | 2026-05-05 |
| GHI789 | 11410 | 2026-05-05 | 500 | 12500.00 | 12500.00 | 1.0000 | 2026-05-05 |
| MNO345 | 11420 | 2026-05-05 | 800 | 20000.00 | 20000.00 | 1.0000 | 2026-05-05 |
| JKL012 | 31200 | 2026-05-05 | 300 | 9000.00 | 9000.00 | 1.0000 | 2026-05-05 |

## 보조원장 (Subledger)

| security_id | account | trade_date | quantity | local_amount | base_amount | fx_rate | posting_date |
|---|---|---|---|---|---|---|---|
| ABC123 | 11420 | 2026-05-05 | 1000 | 50000.00 | 50000.00 | 1.0000 | 2026-05-05 |
| DEF456 | 21330 | 2026-05-05 | 2000 | 40000.00 | 43200.00 | 1.0800 | 2026-05-05 |
| GHI789 | 11410 | 2026-05-05 | 500 | 12500.00 | 12500.00 | 1.0000 | 2026-05-05 |
| MNO345 | 11420 | 2026-05-05 | 850 | 21250.00 | 21250.00 | 1.0000 | 2026-05-05 |

## 분류 기준 (버킷)

Matched / Amount break(금액만 차이) / Quantity break(수량 차이) / Timing break(날짜만 차이, 금액 일치) / GL only / Subledger only.
원인 태그: Timing, FX(local 일치·base 불일치), Mapping, Duplicate/missing, Fee/accrual, Data quality.

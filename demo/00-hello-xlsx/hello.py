#!/usr/bin/env python3
"""
가장 작은 데모 — 이 레포의 모든 엑셀 산출물이 여기서 출발한다.
xlsx-author 스킬의 핵심 3원칙만 보여준다:
  1) 파란 글씨 = 하드코딩 입력 (Inputs 탭에만)
  2) 검정 글씨 = 수식 (계산 탭은 전부 수식, 하드코딩 금지)
  3) openpyxl로 ./out/*.xlsx 생성 — 네트워크/Office/API 키 불필요

Run:  python3 hello.py   ->  ./out/hello.xlsx
"""
import os
from openpyxl import Workbook
from openpyxl.styles import Font

BLUE = Font(color="0000FF")   # 입력
PCT = "0.0%"

wb = Workbook()

# Inputs 탭 — 사람이 손으로 넣는 값(파란색)
inp = wb.active; inp.title = "Inputs"
inp["B2"] = "Revenue";        inp["C2"] = 1000;  inp["C2"].font = BLUE
inp["B3"] = "Growth";         inp["C3"] = 0.12;  inp["C3"].font = BLUE; inp["C3"].number_format = PCT
inp.column_dimensions["B"].width = 14

# Model 탭 — 전부 수식(검정). 숫자 직접 안 씀, Inputs를 참조.
m = wb.create_sheet("Model")
m["B2"] = "Next-year revenue"
m["C2"] = "=Inputs!C2*(1+Inputs!C3)"     # ← live formula: Inputs 바꾸면 자동 재계산
m.column_dimensions["B"].width = 18

os.makedirs("./out", exist_ok=True)
wb.save("./out/hello.xlsx")
print("wrote ./out/hello.xlsx  ->  Model!C2 = Revenue x (1+Growth) = 1000 x 1.12 = 1120")

#import "../deps.typ": algorithm-figure, cap-style, capfig-style, captab-style, i-figured, style-algorithm, zh
#import "../utils.typ": 字体

// 统一编号格式状态：正文 "1-1"，附录 "A-1"
#let numbering-format = state("nwpu-numbering-format", "1-1")

#let with-numbering-format(format, it) = {
  numbering-format.update(format)
  show: cap-style.with(numbering-format: format)
  it
}

#let algorithm(english-writing: false, title: none, ..body) = {
  algorithm-figure(
    title,
    supplement: if english-writing { [Algorithm] } else { [算法] },
    inset: 0.43em,
    ..body,
  )
}

#let equation-note(english-writing: false, body) = {
  block(width: 100%)[
    #set par(first-line-indent: 0pt, justify: false)
    #set text(zh(5))
    #if english-writing {
      [where ]
    } else {
      [式中，]
    }
    #body
  ]
}

#let setup-floats(
  graduate: false,
  english-writing: false,
  body,
) = {
  // 算法样式
  show figure.where(kind: "algorithm"): set text(zh(5))
  show: style-algorithm.with(
    caption-style: body => text(zh(5), strong(body)),
    hlines: (
      grid.hline(stroke: 1.5pt + black),
      grid.hline(stroke: 1pt + black),
      grid.hline(stroke: 1.5pt + black),
    ),
  )

  // 公式编号
  set math.equation(supplement: if english-writing { [Equation] } else { [式] })
  show math.equation.where(block: true): i-figured.show-equation.with(
    numbering: (..nums) => context {
      if graduate {
        text(font: 字体.宋体混排)[#numbering("(" + numbering-format.get() + ")", ..nums)]
      } else {
        text(font: 字体.宋体混排)[(#numbering(numbering-format.get(), ..nums))]
      }
    },
  )

  // cap-able 全局样式（共享参数）
  show: cap-style.with(
    numbering-format: "1-1",
    use-chapter: true,
    caption-size: zh(5),
    pre-supplement-number-spacing: if english-writing { 0.3em } else { 0em },
  )

  // 表格样式
  show table: set par(justify: false)
  set table(stroke: if graduate { 1pt } else { 0.5pt }, align: center + horizon)

  // 表格独有配置
  show: captab-style.with(
    three-line-table: if graduate { true } else { false },
    supplement: if english-writing { "Table" } else { "表" },
    body-size: zh(5),
    cell-inset: (x: if graduate { 0.5em } else { 0.8em }, y: if graduate { 0.55em } else { 0.7em }),
    middle-rule: 1pt,
    caption-text: if graduate { (font: 字体.宋体混排) } else { (font: 字体.黑体) },
    caption-below: if graduate { auto } else { 10pt },
    table-below: if graduate { 11pt } else { 20pt },
    caption-above: if graduate { auto } else { 20pt },
    breakable: false,
    continued-caption: true,
    width: if graduate { 100% } else { auto },
    number-title-spacing: if graduate { auto } else { 0.5em },
    extra-rule: if graduate { 1pt } else { 0.5pt },
  )

  // 图片独有配置
  show: capfig-style.with(
    supplement: if english-writing { "Figure" } else { "图" },
    number-title-spacing: 0.5em,
    number-title-spacing-en: 0.5em,
    show-subcaption: true,
    label-style: "（a）",
    subcaption-number-title-spacing: 0pt,
    caption-above: 0pt,
    figure-below: if graduate { auto } else { 20pt },
    figure-above: if graduate { auto } else { 20pt },
    subref-style: "full",
  )

  body
}

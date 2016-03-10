//
//  CDPainDatumTask.swift
//  ControlaDor
//
//  Created by Isaías Lima on 09/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//

import Foundation
import ResearchKit

public var CDPainDatumTask: ORKOrderedTask? {

    // MARK: - Creating the steps

    var steps = [ORKStep]()

    let scaleAnswerFormat = ORKAnswerFormat.continuousScaleAnswerFormatWithMaximumValue(10, minimumValue: 0, defaultValue: 0, maximumFractionDigits: 0, vertical: false, maximumValueDescription: "", minimumValueDescription: "")

    // MARK: - Body Shader

    let instruction = ORKInstructionStep(identifier: "Instrução para o desenho")
    instruction.title = "Marque nos desenhos a seguir aonde você está sentindo dor"
    instruction.text = "Toque e arraste para ir desenhando, passe mais camadas de tinta para destacar locais com mais dor\n1) Na frente de seu corpo\n2) Atrás de seu corpo"
    steps.append(instruction)

    let step1 = ORKBodyShaderStep(identifier: "HumanBodyFront")
    step1.title = "Marque no desenho abaixo aonde você está sentindo dor"
    steps.append(step1)

    let step2 = ORKBodyShaderStep(identifier: "HumanBodyBack")
    step2.title = "Marque no desenho abaixo aonde você está sentindo dor"
    steps.append(step2)

    // MARK:  - Pain intensity

    let scaleQuestionStep = ORKQuestionStep(identifier: "Intensidade da dor", title: "Qual a intensidade da dor que você está sentindo agora?", answer: scaleAnswerFormat)
    steps.append(scaleQuestionStep)
    scaleQuestionStep.optional = false

    // MARK: - Completion step

    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Fim"
    summaryStep.text = "Dado de dor cadastrado"
    steps.append(summaryStep)

    return ORKOrderedTask(identifier: "Dado de dor", steps: steps)
}
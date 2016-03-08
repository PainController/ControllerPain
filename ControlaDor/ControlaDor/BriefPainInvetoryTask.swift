//
//  SurveyTask.swift
//  Research Test
//
//  Created by Isaías Lima on 04/02/16.
//  Copyright © 2016 Lima. All rights reserved.
//

import ResearchKit

let path = NSBundle.mainBundle().pathForResource("inventory", ofType: "json")
let JSONData = NSData(contentsOfFile: path!)

public var BriefPainInvetoryTask: ORKOrderedTask {

    // MARK: - parsing the json

    var scaleQuestions = [String  : AnyObject]()
    do {
        let json = try NSJSONSerialization.JSONObjectWithData(JSONData!, options: .MutableContainers) as! [String : AnyObject]
        scaleQuestions = json
    } catch {
        print(error)
    }
    var questions = [(String , AnyObject)]()
    for scaleQuestion in scaleQuestions {
        questions.append(scaleQuestion)
    }
    questions.sortInPlace { $0.0 < $1.0 }

    // MARK: - Creating the steps

    var steps = [ORKStep]()

    // MARK: - Instructions

    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "Inventário breve de dor"
    instructionStep.text = "Preencha os dados seguintes relativos à intensidade"
    instructionStep.optional = false
    steps.append(instructionStep)

    // MARK: - If the user is feeling pain

    let scaleAnswerFormat = ORKAnswerFormat.continuousScaleAnswerFormatWithMaximumValue(10, minimumValue: 0, defaultValue: 0, maximumFractionDigits: 0, vertical: false, maximumValueDescription: "", minimumValueDescription: "")

    let questQuestionStepTitle = "Durante a vida, a maioria das pessoas apresenta dor de vez em quando (dor de cabeça, dor de dente, etc). Você teve uma dor diferente dessas?"
    let textChoices = [
        ORKTextChoice(text: "Não", value: 0),
        ORKTextChoice(text: "Sim", value: 1)
    ]
    let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    let questQuestionStep = ORKQuestionStep(identifier: "Teve dor diferente hoje?", title: questQuestionStepTitle, answer: questAnswerFormat)
    questQuestionStep.optional = false
    steps.append(questQuestionStep)

    // MARK: - Body Shader

    let instruction = ORKInstructionStep(identifier: "Instrução para o desenho")
    instruction.title = "Marque nos desenhos a seguir aonde você está sentindo dor"
    instruction.text = "Toque e arraste para ir desenhando\n1) Na frente de seu corpo\n2) Atrás de seu corpo"
    steps.append(instruction)

    let step1 = ORKBodyShaderStep(identifier: "HumanBodyFront")
    step1.title = "Marque no desenho abaixo aonde você está sentindo dor"
    steps.append(step1)

    let step2 = ORKBodyShaderStep(identifier: "HumanBodyBack")
    step2.title = "Marque no desenho abaixo aonde você está sentindo dor"
    steps.append(step2)

    // MARK:  - Pain intensity

    for question in questions {
        let dictionary = question.1 as! [String : String]
        let scaleQuestionStep = ORKQuestionStep(identifier: dictionary["identifier"]!, title: dictionary["question"]!, answer: scaleAnswerFormat)
        steps.append(scaleQuestionStep)
        scaleQuestionStep.optional = false
    }

    // MARK: - Medications

    let formStep = ORKFormStep(identifier: "Medicamentos")
    formStep.title = "Medicamentos e tratamentos"
    formStep.text = "Descreva medicamentos ou tratamentos relacionados à dor que você tenha recebido e escolha o número que represente a intensidade da melhora proporcionada por eles"
    formStep.optional = false
    let textFormat = ORKTextAnswerFormat()
    textFormat.multipleLines = true
    let nameItem = ORKFormItem(identifier: "Medicamentos e tratamentos", text: "Medicamentos/Tratamentos", answerFormat: textFormat, optional: false)
    nameItem.placeholder = "Nome, dose/frequência e data de início"
    let moduleItem = ORKFormItem(identifier: "Intensidade da melhora causada por medicamentos ou tratamentos", text: "Intensidade da melhora", answerFormat: scaleAnswerFormat, optional: false)
    formStep.formItems = [nameItem , moduleItem]
    steps.append(formStep)

    // MARK: - Completion step

    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Fim"
    summaryStep.text = "Seus dados estão atualizados"
    steps.append(summaryStep)

    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}

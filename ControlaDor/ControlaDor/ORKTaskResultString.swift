//
//  ORKTaskResultString.swift
//  Research Test
//
//  Created by Isaías Lima on 05/02/16.
//  Copyright © 2016 Lima. All rights reserved.
//

import ResearchKit

extension ORKTaskViewController {

    func dictionaryWithTaskResult(taskResult: ORKTaskResult) -> [String : String] {
        var taskResultsDictionary = [String : String]()
        let results = taskResult.results
        for result in results! {
            let dictionary = result.dictionaryWithValuesForKeys(["results"])
            let leResultado =  dictionary["results"] as! [AnyObject]
            if leResultado.first != nil && leResultado.count == 1 {
                let leObjeto = leResultado.first
                let answer = leObjeto?.valueForKey("answer")
                let identifier = leObjeto?.valueForKey("identifier")
                var finalTaskResultValue = "Com resposta"
                if answer == nil {
                    finalTaskResultValue = "Sem resposta"
                } else {
                    finalTaskResultValue = "\(answer!)"
                }
                let finalTaskResultKey = "\(identifier!)"
                taskResultsDictionary[finalTaskResultKey] = finalTaskResultValue
            } else if leResultado.first != nil && leResultado.count > 1 {
                for leObjeto in leResultado {
                    let answer = leObjeto.valueForKey("answer")
                    let identifier = leObjeto.valueForKey("identifier")
                    var finalTaskResultValue = "Com resposta"
                    if answer == nil {
                        finalTaskResultValue = "Sem resposta"
                    } else {
                        finalTaskResultValue = "\(answer!)"
                    }
                    let finalTaskResultKey = "\(identifier!)"
                    taskResultsDictionary[finalTaskResultKey] = finalTaskResultValue
                }
            }
        }
        return taskResultsDictionary
    }

}

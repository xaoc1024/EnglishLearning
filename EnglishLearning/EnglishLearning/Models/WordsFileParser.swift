//
//  WordsFileParser.swift
//  Words
//
//  Created by Andriy Zhuk on 9/16/17.
//  Copyright © 2017 azhuk. All rights reserved.
//

import Foundation

class WordsFileParser: NSObject {
	let managedObjectContext: NSManagedObjectContext

	@objc init(managedObjectContext: NSManagedObjectContext) {
		self.managedObjectContext = managedObjectContext
	}

	@objc func parseWordsRecords(_ wordLines: [String]) {
		var wordsArray = [Word]()

		for line in wordLines {
			if line.isEmpty {
				continue
			}

			if let word = parseWordLine(line) {
				wordsArray.append(word)
			}
		}

		try? self.managedObjectContext.save()
	}

	private func parseWordLine(_ textLine: String) -> Word? {
		let elements = textLine.components(separatedBy: ",")
//		guard elements.count >= 4 else {
//			return nil
//		}

		return parseWordElements(elements)

	}

	private func parseWordElements(_ elements: [String]) -> Word? {
		let identifier = elements[0]
		let originalWord = elements[1]
		let translations = elements[2]
		let transcription = elements[3]

		let word = NSEntityDescription.insertNewObject(forEntityName: "Word", into: managedObjectContext) as! Word

		word.identifier = identifier.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		word.originalWord = originalWord.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		word.translation = translations.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		word.transcription = transcription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

		return word
	}
}

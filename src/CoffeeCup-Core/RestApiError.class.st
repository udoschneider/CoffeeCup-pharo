Class {
	#name : #RestApiError,
	#superclass : #Error,
	#category : #'CoffeeCup-Core'
}

{ #category : #'as yet unclassified' }
RestApiError class >> signalMissingArgument: parameter [

	^ self signal:
		  'Parameter ' , parameter name , ' (' , parameter key printString
		  , ') required but no argument or default given'
]

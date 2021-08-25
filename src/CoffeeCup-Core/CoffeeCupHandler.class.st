Class {
	#name : #CoffeeCupHandler,
	#superclass : #Object,
	#instVars : [
		'url',
		'spec',
		'queryParameters',
		'queryArguments'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #'instance creation' }
CoffeeCupHandler class >> spec: aSpec url: anUrl queryParameters: aCollection arguments: aDictionary [

	^ self new
		  setSpec: aSpec
		  url: anUrl
		  queryParameters: aCollection
		  arguments: aDictionary;
		  yourself
]

{ #category : #'double dispatch' }
CoffeeCupHandler >> copyAppend: aSpec with: arguments [

	^ aSpec appendTo: self with: arguments
]

{ #category : #'double dispatch' }
CoffeeCupHandler >> copyAppendApi: api with: arguments [

	^ CoffeeCupHandler
		  spec: api
		  url: api baseUrl / api path
		  queryParameters: self queryParameters , api queryParameters
		  arguments: self queryArguments , arguments
]

{ #category : #'double dispatch' }
CoffeeCupHandler >> copyAppendEndpoint: endpoint with: arguments [

	| newUrl newQueryParameters newQueryArguments |
	newUrl := url / (self mapPath: endpoint with: arguments).
	newQueryParameters := self queryParameters , endpoint queryParameters.
	newQueryArguments := self queryArguments , arguments.
	(self mapArguments: newQueryArguments to: newQueryParameters) 
		keysAndValuesDo: [ :key :value | newUrl queryAt: key put: value ].

	^ endpoint request:
		  (ZnRequest method: endpoint method asUppercase url: newUrl)
]

{ #category : #'double dispatch' }
CoffeeCupHandler >> copyAppendNamespace: namespace with: arguments [

	^ CoffeeCupHandler
		  spec: namespace
		  url: url / (self mapPath: namespace with: arguments)
		  queryParameters: self queryParameters , namespace queryParameters
		  arguments: self queryArguments , arguments
]

{ #category : #'reflective operations' }
CoffeeCupHandler >> doesNotUnderstand: aMessage [

	^ (self splitSelector: aMessage selector)
		  ifNil: [ 
			  MessageNotUnderstood new
				  message: aMessage;
				  receiver: spec;
				  signal ]
		  ifNotNil: [ :splitted | 
			  | child arguments |
			  child := splitted first.

			  arguments := ((aMessage arguments size = 1 and: [ 
				                 child pathParameters size = 1 ]) and: [ 
				                splitted second isEmpty ])
				               ifTrue: [ 
					               Dictionary new
						               at: child pathParameters asArray first name
						               put: aMessage arguments first;
						               yourself ]
				               ifFalse: [ 
					               Dictionary
						               newFromKeys: splitted second
						               andValues: aMessage arguments ].
			  (CoffeeCupHandler
				   spec: self
				   url: url
				   queryParameters: self queryParameters
				   arguments: self queryArguments) copyAppend: child with: arguments ]
]

{ #category : #initialization }
CoffeeCupHandler >> initialize [

	|  |
	queryParameters := Set new.
	queryArguments := Dictionary new
]

{ #category : #private }
CoffeeCupHandler >> mapArguments: arguments to: parameters [
	| mapped |
	mapped := Dictionary new.
	parameters do: [ :parameter | 
		parameter isRequired
			ifTrue: [ 
				arguments
					at: parameter key
					ifPresent: [ :argumentValue | 
					mapped at: parameter name put: argumentValue ]
					ifAbsent: [ 
						parameter default
							ifNotNil: [ :defaultValue | 
							mapped at: parameter name put: defaultValue ]
							ifNil: [ CoffeeCupError signalMissingArgument: parameter ] ] ]
			ifFalse: [ 
				arguments
					at: parameter key
					ifPresent: [ :argumentValue | 
					mapped at: parameter name put: argumentValue ] ] ].
	^ mapped
]

{ #category : #private }
CoffeeCupHandler >> mapPath: endpoint with: arguments [

	^ endpoint path format:
		  (self mapArguments: arguments to: endpoint pathParameters)
]

{ #category : #accessing }
CoffeeCupHandler >> queryArguments [
	^ queryArguments
]

{ #category : #accessing }
CoffeeCupHandler >> queryParameters [
	^ queryParameters
]

{ #category : #initialization }
CoffeeCupHandler >> setSpec: aSpec url: anUrl queryParameters: aCollection arguments: aDictionary [

	spec := aSpec.
	url := anUrl.
	queryParameters := aCollection.
	queryArguments := aDictionary
]

{ #category : #private }
CoffeeCupHandler >> splitSelector: selector [

	| splitted arguments |
	splitted := ($: split: selector) select: #notEmpty.

	arguments := splitted allButFirst.

	splitted := splitted first splitCamelCase.
	1 to: splitted size do: [ :index | 
		| possibleSelector |
		possibleSelector := ('' join: (splitted copyFrom: 1 to: index))
			                    asCoffeeCupSelector.

		spec children at: possibleSelector ifPresent: [ :endpoint | 
			| firstArgument |
			firstArgument := { ('' join: (splitted allButFirst: index)) }.
			arguments := (firstArgument , arguments
				              select: #notEmpty
				              thenCollect: [ :each | each asCoffeeCupSelector ])
				             asArray.
			^ { 
				  endpoint.
				  arguments } ] ].
	^ nil
]

{ #category : #accessing }
CoffeeCupHandler >> url [

	^ url
]

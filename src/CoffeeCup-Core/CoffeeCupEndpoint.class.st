Class {
	#name : #CoffeeCupEndpoint,
	#superclass : #Object,
	#instVars : [
		'api',
		'name',
		'path',
		'parameters'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #'instance creation' }
CoffeeCupEndpoint class >> api: anApi name: aSymbol [

	^ self new
		  setApi: anApi name: aSymbol;
		  yourself
]

{ #category : #'as yet unclassified' }
CoffeeCupEndpoint >> _parameter: parameter required: aBoolean default: defaultValue [

	parameters add: (CoffeeCupQueryParameter
			 key: parameter asCoffeeCupSelector
			 name: parameter
			 required: aBoolean
			 default: defaultValue)
]

{ #category : #accessing }
CoffeeCupEndpoint >> allParameters [

	^ api parameters, parameters 
]

{ #category : #accessing }
CoffeeCupEndpoint >> allPathParameters [

	^ self allParameters select: #isPathParameter  
	
]

{ #category : #accessing }
CoffeeCupEndpoint >> allQueryParameters [

	^ self allParameters select: #isQueryParameter
]

{ #category : #'as yet unclassified' }
CoffeeCupEndpoint >> call: method with: arguments [

	| mappedPath url request |
	mappedPath := self mappedPath: arguments.
	url := api baseUrl / mappedPath.
	
	(self mappedQueryParameters: arguments) keysAndValuesDo: [ :key :value | 
		url queryAt: key put: value ].

	request := ZnRequest
		           method: method asCoffeeCupSelector asUppercase
		           url: url.

	^ api request: request
]

{ #category : #'reflective operations' }
CoffeeCupEndpoint >> doesNotUnderstand: aMessage [

	| selector |
	selector := aMessage selector.

	^ selector isRestApiCall
		  ifTrue: [ 
			  self call: selector coffeeCupMethod with: (OrderedDictionary
					   newFromKeys: selector coffeeCupArguments
					   andValues: aMessage arguments) ]
		  ifFalse: [ super doesNotUnderstand: aMessage ]
]

{ #category : #initialization }
CoffeeCupEndpoint >> initialize [

	super initialize.
	parameters := Set new
]

{ #category : #'as yet unclassified' }
CoffeeCupEndpoint >> mappedPath: arguments [

	^ self path format: (self mappedPathParameters: arguments)
]

{ #category : #'as yet unclassified' }
CoffeeCupEndpoint >> mappedPathParameters: arguments [

	| mapped |
	mapped := Dictionary new.
	self allParameters select: #isPathParameter thenDo: [ :parameter | 
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

{ #category : #'as yet unclassified' }
CoffeeCupEndpoint >> mappedQueryParameters: arguments [

	| mapped |
	mapped := Dictionary new.
	self allParameters select: #isQueryParameter thenDo: [ :parameter | 
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

{ #category : #'as yet unclassified' }
CoffeeCupEndpoint >> parameter: aString [

^	parameters add:
		(CoffeeCupQueryParameter key: aString asCoffeeCupSelector name: aString)
]

{ #category : #accessing }
CoffeeCupEndpoint >> parameters [

	^ parameters
]

{ #category : #accessing }
CoffeeCupEndpoint >> path [

	^ path ifNil: [ name asSymbol ]
]

{ #category : #initialization }
CoffeeCupEndpoint >> path: aString [


	path := aString.

	path coffeeCupFormatParameters do: [ :pathParameter | 
		parameters add: (CoffeeCupPathParameter
				 key: pathParameter asCoffeeCupSelector
				 name: pathParameter) ]
]

{ #category : #initialization }
CoffeeCupEndpoint >> setApi: anApi name: aSymbol [

	api := anApi.
	name := aSymbol.
	
]

{ #category : #'instance creation' }
CoffeeCupEndpoint >> with: aBlockOrNil [

	aBlockOrNil ifNotNil: [ :block | block value: self ].
]
